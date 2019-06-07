Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6339C390C5
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbfFGPqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731437AbfFGPqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:46:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F6D72146E;
        Fri,  7 Jun 2019 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922396;
        bh=GlWOorS1xItpTubUtbbteEcDFsKw9k0MWsdCTC4hn88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZamvVMKOX0i8KQcv4nNmXJjSvFGheDJNvyk4yi7cjkMpf20vpJeWs8fEG3Sjj5mR
         0jxQN3AG9U5VCNHNf98V6jBGS3YpNH0KnX4KLTBJ5gR8MqLyx6Ki3EXtnJfAQ/S0Hi
         mnJo3ZxKMuPLdVs3GvXfUuJ8lw/7wlZJzJQM5e/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Tull <atull@kernel.org>,
        Frank Rowand <frank.rowand@sony.com>
Subject: [PATCH 4.19 71/73] of: overlay: validate overlay properties #address-cells and #size-cells
Date:   Fri,  7 Jun 2019 17:39:58 +0200
Message-Id: <20190607153856.691091191@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

commit 6f75118800acf77f8ad6afec61ca1b2349ade371 upstream.

If overlay properties #address-cells or #size-cells are already in
the live devicetree for any given node, then the values in the
overlay must match the values in the live tree.

If the properties are already in the live tree then there is no
need to create a changeset entry to add them since they must
have the same value.  This reduces the memory used by the
changeset and eliminates a possible memory leak.

Tested-by: Alan Tull <atull@kernel.org>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/overlay.c |   32 +++++++++++++++++++++++++++++---
 include/linux/of.h   |    6 ++++++
 2 files changed, 35 insertions(+), 3 deletions(-)

--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -287,7 +287,12 @@ err_free_target_path:
  * @target may be either in the live devicetree or in a new subtree that
  * is contained in the changeset.
  *
- * Some special properties are not updated (no error returned).
+ * Some special properties are not added or updated (no error returned):
+ * "name", "phandle", "linux,phandle".
+ *
+ * Properties "#address-cells" and "#size-cells" are not updated if they
+ * are already in the live tree, but if present in the live tree, the values
+ * in the overlay must match the values in the live tree.
  *
  * Update of property in symbols node is not allowed.
  *
@@ -300,6 +305,7 @@ static int add_changeset_property(struct
 {
 	struct property *new_prop = NULL, *prop;
 	int ret = 0;
+	bool check_for_non_overlay_node = false;
 
 	if (!of_prop_cmp(overlay_prop->name, "name") ||
 	    !of_prop_cmp(overlay_prop->name, "phandle") ||
@@ -322,12 +328,32 @@ static int add_changeset_property(struct
 	if (!new_prop)
 		return -ENOMEM;
 
-	if (!prop)
+	if (!prop) {
+		check_for_non_overlay_node = true;
 		ret = of_changeset_add_property(&ovcs->cset, target->np,
 						new_prop);
-	else
+	} else if (!of_prop_cmp(prop->name, "#address-cells")) {
+		if (!of_prop_val_eq(prop, new_prop)) {
+			pr_err("ERROR: changing value of #address-cells is not allowed in %pOF\n",
+			       target->np);
+			ret = -EINVAL;
+		}
+	} else if (!of_prop_cmp(prop->name, "#size-cells")) {
+		if (!of_prop_val_eq(prop, new_prop)) {
+			pr_err("ERROR: changing value of #size-cells is not allowed in %pOF\n",
+			       target->np);
+			ret = -EINVAL;
+		}
+	} else {
+		check_for_non_overlay_node = true;
 		ret = of_changeset_update_property(&ovcs->cset, target->np,
 						   new_prop);
+	}
+
+	if (check_for_non_overlay_node &&
+	    !of_node_check_flag(target->np, OF_OVERLAY))
+		pr_err("WARNING: memory leak will occur if overlay removed, property: %pOF/%s\n",
+		       target->np, new_prop->name);
 
 	if (ret) {
 		kfree(new_prop->name);
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -968,6 +968,12 @@ static inline int of_cpu_node_to_id(stru
 #define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
 #endif
 
+static inline int of_prop_val_eq(struct property *p1, struct property *p2)
+{
+	return p1->length == p2->length &&
+	       !memcmp(p1->value, p2->value, (size_t)p1->length);
+}
+
 #if defined(CONFIG_OF) && defined(CONFIG_NUMA)
 extern int of_node_to_nid(struct device_node *np);
 #else


