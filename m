Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E988D45013E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 10:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbhKOJ1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 04:27:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237349AbhKOJ1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 04:27:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E25961BFE;
        Mon, 15 Nov 2021 09:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636968242;
        bh=edXI53IUDlrw/mgDN23d5wIxBkNlwmaX2mzMcHToDSk=;
        h=Subject:To:From:Date:From;
        b=U6nuneZ0qLIglqAgcCd4EXBtFAAmuShgCT7wgxweefyu/x+oQ5gvPANPAnD5sev+i
         qf/Jtt/sD6vIQBGzHjuFkTBvsvSH2s/nquakj5RN72I4DxAqPogT9815nXwMxDbW2J
         +RGFJxEeQGAkGyEfIvAf1+MmVPn7dut6pbXXzGts=
Subject: patch "staging: r8188eu: use GFP_ATOMIC under spinlock" added to staging-linus
To:     straube.linux@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 10:23:50 +0100
Message-ID: <163696823043193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: r8188eu: use GFP_ATOMIC under spinlock

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4a293eaf92a510ff688dc7b3f0815221f99c9d1b Mon Sep 17 00:00:00 2001
From: Michael Straube <straube.linux@gmail.com>
Date: Mon, 8 Nov 2021 11:55:37 +0100
Subject: staging: r8188eu: use GFP_ATOMIC under spinlock

In function rtw_report_sec_ie() kzalloc() is called under a spinlock,
so the allocation have to be atomic.

Call tree:

-> rtw_select_and_join_from_scanned_queue() <- takes a spinlock
   -> rtw_joinbss_cmd()
      -> rtw_restruct_sec_ie()
         -> rtw_report_sec_ie()

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Link: https://lore.kernel.org/r/20211108105537.31655-1-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/mlme_linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/r8188eu/os_dep/mlme_linux.c b/drivers/staging/r8188eu/os_dep/mlme_linux.c
index a9b6ffdbf31a..f7ce724ebf87 100644
--- a/drivers/staging/r8188eu/os_dep/mlme_linux.c
+++ b/drivers/staging/r8188eu/os_dep/mlme_linux.c
@@ -112,7 +112,7 @@ void rtw_report_sec_ie(struct adapter *adapter, u8 authmode, u8 *sec_ie)
 
 	buff = NULL;
 	if (authmode == _WPA_IE_ID_) {
-		buff = kzalloc(IW_CUSTOM_MAX, GFP_KERNEL);
+		buff = kzalloc(IW_CUSTOM_MAX, GFP_ATOMIC);
 		if (!buff)
 			return;
 		p = buff;
-- 
2.33.1


