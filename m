Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242776ADB25
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjCGJ4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjCGJzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:55:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5145071E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:55:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E973612AB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B59C433EF;
        Tue,  7 Mar 2023 09:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182920;
        bh=A/R0g5G0DVRejeIZXgsvksk+jewmb3vAH5t5RHHOoqA=;
        h=Subject:To:Cc:From:Date:From;
        b=bESjK5XPb4Qt44sFcEYzh3uXWbIqilfO2bSs0E/8MLhjneqj54aCuyncluoS1Ns4m
         AGw4jQc1QZYJsfjIo4RQAuRIJOFbL7/AVjarK6EkCsHg5N/hfZXM/cOIez1++xtJIb
         Gfuw5+TeGbXjL8rbf1d7kkkaGKdDi2rFM5D3O0Ik=
Subject: FAILED: patch "[PATCH] iommu/amd: Add a length limitation for the ivrs_acpihid" failed to apply to 5.10-stable tree
To:     Ilia.Gavrilov@infotecs.ru, jroedel@suse.de, kim.phillips@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:55:09 +0100
Message-ID: <1678182909225188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x b6b26d86c61c441144c72f842f7469bb686e1211
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678182909225188@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

b6b26d86c61c ("iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter")
1198d2316dc4 ("iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options")
bbe3a106580c ("iommu/amd: Add PCI segment support for ivrs_[ioapic/hpet/acpihid] commands")
42bb5aa04338 ("iommu/amd: Increase timeout waiting for GA log enablement")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b6b26d86c61c441144c72f842f7469bb686e1211 Mon Sep 17 00:00:00 2001
From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Date: Thu, 2 Feb 2023 08:26:56 +0000
Subject: [PATCH] iommu/amd: Add a length limitation for the ivrs_acpihid
 command-line parameter

The 'acpiid' buffer in the parse_ivrs_acpihid function may overflow,
because the string specifier in the format string sscanf()
has no width limitation.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
Reviewed-by: Kim Phillips <kim.phillips@amd.com>
Link: https://lore.kernel.org/r/20230202082719.1513849-1-Ilia.Gavrilov@infotecs.ru
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 467b194975b3..19a46b9f7357 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3475,15 +3475,26 @@ static int __init parse_ivrs_hpet(char *str)
 	return 1;
 }
 
+#define ACPIID_LEN (ACPIHID_UID_LEN + ACPIHID_HID_LEN)
+
 static int __init parse_ivrs_acpihid(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
 	char *hid, *uid, *p, *addr;
-	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
+	char acpiid[ACPIID_LEN] = {0};
 	int i;
 
 	addr = strchr(str, '@');
 	if (!addr) {
+		addr = strchr(str, '=');
+		if (!addr)
+			goto not_found;
+
+		++addr;
+
+		if (strlen(addr) > ACPIID_LEN)
+			goto not_found;
+
 		if (sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid) == 4 ||
 		    sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid) == 5) {
 			pr_warn("ivrs_acpihid%s option format deprecated; use ivrs_acpihid=%s@%04x:%02x:%02x.%d instead\n",
@@ -3496,6 +3507,9 @@ static int __init parse_ivrs_acpihid(char *str)
 	/* We have the '@', make it the terminator to get just the acpiid */
 	*addr++ = 0;
 
+	if (strlen(str) > ACPIID_LEN + 1)
+		goto not_found;
+
 	if (sscanf(str, "=%s", acpiid) != 1)
 		goto not_found;
 

