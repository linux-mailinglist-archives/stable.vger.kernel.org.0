Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537916C0CF5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCTJSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjCTJSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:18:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4F2233DB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA71EB80DB4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F695C4339E;
        Mon, 20 Mar 2023 09:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679303915;
        bh=dwPBUmJ3Dkyul6G0hV3AjItNezZxnXOGhYeqowyXiFk=;
        h=Subject:To:Cc:From:Date:From;
        b=fo/BWShuKEn0Kegft1zq7s0LawJQDhft3k8XWuLNlfq+IrUl3ojyuyVAgQENPJUnE
         IWVc8cDPCzxLTmDq8buqI8Xkbg9wGM7p3z7VqqT+kAOy3MZq4pPEEIVV5u8dgoERXc
         h5bJQHyfBpA5yexKNX4s7NXapdnvxqLCXXeqbbUc=
Subject: FAILED: patch "[PATCH] s390/ipl: add missing intersection check to ipl_report" failed to apply to 5.10-stable tree
To:     svens@linux.ibm.com, gor@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:18:28 +0100
Message-ID: <16793039081369@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
git cherry-pick -x a52e5cdbe8016d4e3e6322fd93d71afddb9a5af9
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16793039081369@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

a52e5cdbe801 ("s390/ipl: add missing intersection check to ipl_report handling")
84733284f67b ("s390/boot: introduce boot data 'initrd_data'")
9f744abb4639 ("s390/boot: replace magic string check with a bootdata flag")
73045a08cf55 ("s390: unify identity mapping limits handling")
d7e7fbba67a3 ("s390/early: rewrite program parameter setup in C")
0c4ec024a481 ("s390/kasan: move memory needs estimation into a function")
92bca2fe61f5 ("s390/kasan: avoid confusing naming")
90178c190079 ("s390/mm: let vmalloc area size depend on physical memory size")
a3453d923ece ("s390/kasan: remove 3-level paging support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a52e5cdbe8016d4e3e6322fd93d71afddb9a5af9 Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@linux.ibm.com>
Date: Tue, 7 Mar 2023 14:35:23 +0100
Subject: [PATCH] s390/ipl: add missing intersection check to ipl_report
 handling

The code which handles the ipl report is searching for a free location
in memory where it could copy the component and certificate entries to.
It checks for intersection between the sections required for the kernel
and the component/certificate data area, but fails to check whether
the data structures linking these data areas together intersect.

This might cause the iplreport copy code to overwrite the iplreport
itself. Fix this by adding two addtional intersection checks.

Cc: <stable@vger.kernel.org>
Fixes: 9641b8cc733f ("s390/ipl: read IPL report at early boot")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/boot/ipl_report.c b/arch/s390/boot/ipl_report.c
index 9b14045065b6..74b5cd264862 100644
--- a/arch/s390/boot/ipl_report.c
+++ b/arch/s390/boot/ipl_report.c
@@ -57,11 +57,19 @@ static unsigned long find_bootdata_space(struct ipl_rb_components *comps,
 	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && initrd_data.start && initrd_data.size &&
 	    intersects(initrd_data.start, initrd_data.size, safe_addr, size))
 		safe_addr = initrd_data.start + initrd_data.size;
+	if (intersects(safe_addr, size, (unsigned long)comps, comps->len)) {
+		safe_addr = (unsigned long)comps + comps->len;
+		goto repeat;
+	}
 	for_each_rb_entry(comp, comps)
 		if (intersects(safe_addr, size, comp->addr, comp->len)) {
 			safe_addr = comp->addr + comp->len;
 			goto repeat;
 		}
+	if (intersects(safe_addr, size, (unsigned long)certs, certs->len)) {
+		safe_addr = (unsigned long)certs + certs->len;
+		goto repeat;
+	}
 	for_each_rb_entry(cert, certs)
 		if (intersects(safe_addr, size, cert->addr, cert->len)) {
 			safe_addr = cert->addr + cert->len;

