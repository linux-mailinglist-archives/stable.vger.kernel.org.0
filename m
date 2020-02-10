Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AE9158266
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 19:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgBJScq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 13:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgBJScq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 13:32:46 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7241C214DB;
        Mon, 10 Feb 2020 18:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581359565;
        bh=pj4V4DsU/npXonQsEQLDrs//TDN0yRjKy3spABgu1X8=;
        h=Subject:To:From:Date:From;
        b=ENpNDPB8AmCwxAa2GLSnFalANTvNnNMp4acS2tw9kGDtr10X8M3pVYkyZs6CukBAa
         94wufqYZEYlpsbGyHqpJi7mnU1uW6YV7WqNskB7Z3AtQcjNh6Dr19NLoX5iCMgdoqF
         Y8P8Q+H3JvGXMkyE8qdarcM6GbBTEUX6arlKefGo=
Subject: patch "staging: rtl8723bs: Fix potential security hole" added to staging-linus
To:     Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        pietroliva@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 10:32:44 -0800
Message-ID: <158135956464233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8723bs: Fix potential security hole

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ac33597c0c0d1d819dccfe001bcd0acef7107e7c Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 10 Feb 2020 12:02:31 -0600
Subject: staging: rtl8723bs: Fix potential security hole

In routine rtw_hostapd_ioctl(), the user-controlled p->length is assumed
to be at least the size of struct ieee_param size, but this assumption is
never checked. This could result in out-of-bounds read/write on kernel
heap in case a p->length less than the size of struct ieee_param is
specified by the user. If p->length is allowed to be greater than the size
of the struct, then a malicious user could be wasting kernel memory.
Fixes commit 554c0a3abf216 ("0taging: Add rtl8723bs sdio wifi driver").

Reported by: Pietro Oliva <pietroliva@gmail.com>
Cc: Pietro Oliva <pietroliva@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Fixes 554c0a3abf216 ("0taging: Add rtl8723bs sdio wifi driver").
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Link: https://lore.kernel.org/r/20200210180235.21691-3-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index db6528a01229..3128766dd50e 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -4207,7 +4207,7 @@ static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
 
 
 	/* if (p->length < sizeof(struct ieee_param) || !p->pointer) { */
-	if (!p->pointer) {
+	if (!p->pointer || p->length != sizeof(*param)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.25.0


