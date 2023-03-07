Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D9C6ADB26
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjCGJ4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjCGJzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:55:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1809C509BC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:55:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 643D3B816B3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAADEC433D2;
        Tue,  7 Mar 2023 09:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182923;
        bh=+uSPYjFzagS76J0nyc6BcL9AGp2FsgmA3DVjQezm7Fc=;
        h=Subject:To:Cc:From:Date:From;
        b=Jy1A3OrOBBS5abFr0IM4W2Uox/anr4RwmcGZkSHlsrRy77pKr2SxxWHZJCE/d6fkn
         O3WCavj4tRfXLnaq6iVeo5XHP+ODIag59SsWIwIycxvM7+X+sN63r4FMTFaFdjsjEb
         uurTXiCYX3OH/D1Wg6HQrZ0qQNLlPAHON+ysX+g4=
Subject: FAILED: patch "[PATCH] iommu/amd: Add a length limitation for the ivrs_acpihid" failed to apply to 5.4-stable tree
To:     Ilia.Gavrilov@infotecs.ru, jroedel@suse.de, kim.phillips@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:55:10 +0100
Message-ID: <167818291020229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x b6b26d86c61c441144c72f842f7469bb686e1211
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167818291020229@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

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
 

