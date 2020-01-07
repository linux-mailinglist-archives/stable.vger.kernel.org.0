Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C80E01333EC
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgAGVBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728198AbgAGVBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB44F214D8;
        Tue,  7 Jan 2020 21:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430906;
        bh=YfJojMYmFBRmvjmDVhNyyI6ol4s3eXlLwuaoetSSiGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNSkCxj9n5xYWUtG6DFdPjJdw1ZEecNFc3PZK+jhjLE1o979LLmrj6q/+/SLE8Xwp
         9UMY0wGGMNfDajvInhuczovMlewB70Obwu04dGUqN4a+1DCuHRhV0STj6QXVYTbo38
         BArFQxWt9I99Lso2a6naU2P9H7QK65t+/2RIWnRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 145/191] of: overlay: add_changeset_property() memory leak
Date:   Tue,  7 Jan 2020 21:54:25 +0100
Message-Id: <20200107205340.734502711@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

commit 637392a8506a3a7dd24ab9094a14f7522adb73b4 upstream.

No changeset entries are created for #address-cells and #size-cells
properties, but the duplicated properties are never freed.  This
results in a memory leak which is detected by kmemleak:

 unreferenced object 0x85887180 (size 64):
   backtrace:
     kmem_cache_alloc_trace+0x1fb/0x1fc
     __of_prop_dup+0x25/0x7c
     add_changeset_property+0x17f/0x370
     build_changeset_next_level+0x29/0x20c
     of_overlay_fdt_apply+0x32b/0x6b4
     ...

Fixes: 6f75118800ac ("of: overlay: validate overlay properties #address-cells and #size-cells")
Reported-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Tested-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/overlay.c |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -305,7 +305,6 @@ static int add_changeset_property(struct
 {
 	struct property *new_prop = NULL, *prop;
 	int ret = 0;
-	bool check_for_non_overlay_node = false;
 
 	if (target->in_livetree)
 		if (!of_prop_cmp(overlay_prop->name, "name") ||
@@ -318,6 +317,25 @@ static int add_changeset_property(struct
 	else
 		prop = NULL;
 
+	if (prop) {
+		if (!of_prop_cmp(prop->name, "#address-cells")) {
+			if (!of_prop_val_eq(prop, overlay_prop)) {
+				pr_err("ERROR: changing value of #address-cells is not allowed in %pOF\n",
+				       target->np);
+				ret = -EINVAL;
+			}
+			return ret;
+
+		} else if (!of_prop_cmp(prop->name, "#size-cells")) {
+			if (!of_prop_val_eq(prop, overlay_prop)) {
+				pr_err("ERROR: changing value of #size-cells is not allowed in %pOF\n",
+				       target->np);
+				ret = -EINVAL;
+			}
+			return ret;
+		}
+	}
+
 	if (is_symbols_prop) {
 		if (prop)
 			return -EINVAL;
@@ -330,33 +348,18 @@ static int add_changeset_property(struct
 		return -ENOMEM;
 
 	if (!prop) {
-		check_for_non_overlay_node = true;
 		if (!target->in_livetree) {
 			new_prop->next = target->np->deadprops;
 			target->np->deadprops = new_prop;
 		}
 		ret = of_changeset_add_property(&ovcs->cset, target->np,
 						new_prop);
-	} else if (!of_prop_cmp(prop->name, "#address-cells")) {
-		if (!of_prop_val_eq(prop, new_prop)) {
-			pr_err("ERROR: changing value of #address-cells is not allowed in %pOF\n",
-			       target->np);
-			ret = -EINVAL;
-		}
-	} else if (!of_prop_cmp(prop->name, "#size-cells")) {
-		if (!of_prop_val_eq(prop, new_prop)) {
-			pr_err("ERROR: changing value of #size-cells is not allowed in %pOF\n",
-			       target->np);
-			ret = -EINVAL;
-		}
 	} else {
-		check_for_non_overlay_node = true;
 		ret = of_changeset_update_property(&ovcs->cset, target->np,
 						   new_prop);
 	}
 
-	if (check_for_non_overlay_node &&
-	    !of_node_check_flag(target->np, OF_OVERLAY))
+	if (!of_node_check_flag(target->np, OF_OVERLAY))
 		pr_err("WARNING: memory leak will occur if overlay removed, property: %pOF/%s\n",
 		       target->np, new_prop->name);
 


