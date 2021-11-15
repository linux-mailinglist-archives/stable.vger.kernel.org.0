Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBD045013C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 10:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbhKOJ1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 04:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237611AbhKOJ1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 04:27:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 081C463211;
        Mon, 15 Nov 2021 09:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636968248;
        bh=5a1yfWliqHyroChYn0d1Kl9ZhWMorOiL7YXR3oZikKQ=;
        h=Subject:To:From:Date:From;
        b=A5IYIOwzAX8r44gwQNC9wgfsFSGLpA5/rHM+Ej8MnoLMTKYWFanb50C1j5FlogaCU
         tFYlxwnHt1AzAFJ4JJkdKOEcfyRUEUltUUh79QGO+qAC+W5UbOmCVSw6zmma4egWa6
         8Gq91defNkasTYnrrtaUd/4NNQJN8ojkcCS+7q1k=
Subject: patch "staging: r8188eu: Use kzalloc() with GFP_ATOMIC in atomic context" added to staging-linus
To:     fmdefrancesco@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 10:23:50 +0100
Message-ID: <163696823065139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: r8188eu: Use kzalloc() with GFP_ATOMIC in atomic context

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c15a059f85de49c542e6ec2464967dd2b2aa18f6 Mon Sep 17 00:00:00 2001
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Date: Mon, 1 Nov 2021 20:18:47 +0100
Subject: staging: r8188eu: Use kzalloc() with GFP_ATOMIC in atomic context

Use the GFP_ATOMIC flag of kzalloc() with two memory allocation in
report_del_sta_event(). This function is called while holding spinlocks,
therefore it is not allowed to sleep. With the GFP_ATOMIC type flag, the
allocation is high priority and must not sleep.

This issue is detected by Smatch which emits the following warning:
"drivers/staging/r8188eu/core/rtw_mlme_ext.c:6848 report_del_sta_event()
warn: sleeping in atomic context".

After the change, the post-commit hook output the following message:
"CHECK: Prefer kzalloc(sizeof(*pcmd_obj)...) over
kzalloc(sizeof(struct cmd_obj)...)".

According to the above "CHECK", use the preferred style in the first
kzalloc().

Fixes: 79f712ea994d ("staging: r8188eu: Remove wrappers for kalloc() and kzalloc()")
Fixes: 15865124feed ("staging: r8188eu: introduce new core dir for RTL8188eu driver")
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Link: https://lore.kernel.org/r/20211101191847.6749-1-fmdefrancesco@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
---
 drivers/staging/r8188eu/core/rtw_mlme_ext.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/r8188eu/core/rtw_mlme_ext.c b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
index 5b60e6df5f87..b4820ad2cee7 100644
--- a/drivers/staging/r8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
@@ -6847,12 +6847,12 @@ void report_del_sta_event(struct adapter *padapter, unsigned char *MacAddr, unsi
 	struct mlme_ext_priv		*pmlmeext = &padapter->mlmeextpriv;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	pcmd_obj = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
+	pcmd_obj = kzalloc(sizeof(*pcmd_obj), GFP_ATOMIC);
 	if (!pcmd_obj)
 		return;
 
 	cmdsz = (sizeof(struct stadel_event) + sizeof(struct C2HEvent_Header));
-	pevtcmd = kzalloc(cmdsz, GFP_KERNEL);
+	pevtcmd = kzalloc(cmdsz, GFP_ATOMIC);
 	if (!pevtcmd) {
 		kfree(pcmd_obj);
 		return;
-- 
2.33.1


