Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D29A32AED7
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhCCAGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1837219AbhCBHkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 02:40:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE3216186A;
        Tue,  2 Mar 2021 07:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614670795;
        bh=oAuKMZPh03GwdJNdm8gYs8eFDxfoWj37ma0KYdqYu3U=;
        h=Subject:To:From:Date:From;
        b=Yh1IFVnHzLxdsH9zQj52RNTTn0nwyI96Iz1Sl8cdBm7EqwWpnTlZCnA7NZ4UcJ3Z2
         oW2ZcfEcviqk2ikglmDy1tt7hb+9alBtFAHSIF3chCJN2jKrbR968JcgJVB32NvGvF
         2gRUc0wwdjrZbW98aHFlIh8JCD4rX4mcNZSbp2MQ=
Subject: patch "USB: gadget: u_ether: Fix a configfs return code" added to usb-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        lorenzo@google.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 08:39:45 +0100
Message-ID: <1614670785229160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: u_ether: Fix a configfs return code

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1236c1d95c99e9f34cd7547e53af71142a3854ea Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 15 Feb 2021 15:57:16 +0000
Subject: USB: gadget: u_ether: Fix a configfs return code

If the string is invalid, this should return -EINVAL instead of 0.

Fixes: 73517cf49bd4 ("usb: gadget: add RNDIS configfs options for class/subclass/protocol")
Cc: stable <stable@vger.kernel.org>
Acked-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YCqZ3P53yyIg5cn7@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether_configfs.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether_configfs.h b/drivers/usb/gadget/function/u_ether_configfs.h
index 3dfb460908fa..f558c3139ebe 100644
--- a/drivers/usb/gadget/function/u_ether_configfs.h
+++ b/drivers/usb/gadget/function/u_ether_configfs.h
@@ -182,12 +182,11 @@ out:									\
 						size_t len)		\
 	{								\
 		struct f_##_f_##_opts *opts = to_f_##_f_##_opts(item);	\
-		int ret;						\
+		int ret = -EINVAL;					\
 		u8 val;							\
 									\
 		mutex_lock(&opts->lock);				\
-		ret = sscanf(page, "%02hhx", &val);			\
-		if (ret > 0) {						\
+		if (sscanf(page, "%02hhx", &val) > 0) {			\
 			opts->_n_ = val;				\
 			ret = len;					\
 		}							\
-- 
2.30.1


