Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA021F45A9
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732538AbgFIRth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730925AbgFIRtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:49:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC0B2081A;
        Tue,  9 Jun 2020 17:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724976;
        bh=et9YtkaNWCi90vne3IgotzdPWzrupwfZhlFMkeqow5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlrXtT38WxwU8GtocmYUUTododx/JW2+wN/q4vvCrn6gSFX2j7U46a8xis5yFy8nD
         iHhO7ojic/9u0PNVxdXhv4nQq+Id9kyK+I1ka9WpsGgQnWUooH5YIhcul5cHUZqkoH
         GS87bEMHMGhejZ7UoxpwEIneOyyYuL+pfBixsw2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: =?UTF-8?q?=5BPATCH=204=2E14=2002/46=5D=20libnvdimm=3A=20Fix=20endian=20conversion=20issues=C2=A0?=
Date:   Tue,  9 Jun 2020 19:44:18 +0200
Message-Id: <20200609174023.128836157@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 86aa66687442ef45909ff9814b82b4d2bb892294 upstream.

nd_label->dpa issue was observed when trying to enable the namespace created
with little-endian kernel on a big-endian kernel. That made me run
`sparse` on the rest of the code and other changes are the result of that.

Fixes: d9b83c756953 ("libnvdimm, btt: rework error clearing")
Fixes: 9dedc73a4658 ("libnvdimm/btt: Fix LBA masking during 'free list' population")
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Link: https://lore.kernel.org/r/20190809074726.27815-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvdimm/btt.c            |    8 ++++----
 drivers/nvdimm/namespace_devs.c |    7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -399,9 +399,9 @@ static int btt_flog_write(struct arena_i
 	arena->freelist[lane].sub = 1 - arena->freelist[lane].sub;
 	if (++(arena->freelist[lane].seq) == 4)
 		arena->freelist[lane].seq = 1;
-	if (ent_e_flag(ent->old_map))
+	if (ent_e_flag(le32_to_cpu(ent->old_map)))
 		arena->freelist[lane].has_err = 1;
-	arena->freelist[lane].block = le32_to_cpu(ent_lba(ent->old_map));
+	arena->freelist[lane].block = ent_lba(le32_to_cpu(ent->old_map));
 
 	return ret;
 }
@@ -567,8 +567,8 @@ static int btt_freelist_init(struct aren
 		 * FIXME: if error clearing fails during init, we want to make
 		 * the BTT read-only
 		 */
-		if (ent_e_flag(log_new.old_map) &&
-				!ent_normal(log_new.old_map)) {
+		if (ent_e_flag(le32_to_cpu(log_new.old_map)) &&
+		    !ent_normal(le32_to_cpu(log_new.old_map))) {
 			arena->freelist[i].has_err = 1;
 			ret = arena_clear_freelist_error(arena, i);
 			if (ret)
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1978,7 +1978,7 @@ struct device *create_namespace_pmem(str
 		nd_mapping = &nd_region->mapping[i];
 		label_ent = list_first_entry_or_null(&nd_mapping->labels,
 				typeof(*label_ent), list);
-		label0 = label_ent ? label_ent->label : 0;
+		label0 = label_ent ? label_ent->label : NULL;
 
 		if (!label0) {
 			WARN_ON(1);
@@ -2315,8 +2315,9 @@ static struct device **scan_labels(struc
 			continue;
 
 		/* skip labels that describe extents outside of the region */
-		if (nd_label->dpa < nd_mapping->start || nd_label->dpa > map_end)
-			continue;
+		if (__le64_to_cpu(nd_label->dpa) < nd_mapping->start ||
+		    __le64_to_cpu(nd_label->dpa) > map_end)
+				continue;
 
 		i = add_namespace_resource(nd_region, nd_label, devs, count);
 		if (i < 0)


