Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D5F32AED9
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbhCCAGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1837237AbhCBHlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 02:41:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C38F64DE4;
        Tue,  2 Mar 2021 07:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614670836;
        bh=/oB6Ig9C+dmrURq4jrWk01VmH9SLma9K/g0moZLmLdA=;
        h=Subject:To:From:Date:From;
        b=YQK/oEA9lD+UrsoWCjNpLPdCeDHsja88WlMYVHFajExIo0o5vRt4rTC8/Jl+9Hts7
         BjIHenIAcaNAm8IrwLPTqxSsKuD+LDlxaa2PKzQ/x5VVKXlHQ8eIr0+YQK4LxNSsJk
         SgWaAs6CTnD4EzFgTmciVkb+W5z3cWXxBehH8Cd4=
Subject: patch "usb: gadget: f_uac1: stop playback on function disable" added to usb-linus
To:     ruslan.bilovol@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 08:40:26 +0100
Message-ID: <161467082655241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_uac1: stop playback on function disable

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 466b4bed6798e912264325bb4d90dfcd3a8a9128 Mon Sep 17 00:00:00 2001
From: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Date: Mon, 1 Mar 2021 13:49:32 +0200
Subject: usb: gadget: f_uac1: stop playback on function disable

There is missing playback stop/cleanup in case of
gadget's ->disable callback that happens on
events like USB host resetting or gadget disconnection

Fixes: 0591bc236015 ("usb: gadget: add f_uac1 variant based on a new u_audio api")
Cc: <stable@vger.kernel.org> # 4.13+
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Link: https://lore.kernel.org/r/1614599375-8803-3-git-send-email-ruslan.bilovol@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/function/f_uac1.c
index 00d346965f7a..560382e0a8f3 100644
--- a/drivers/usb/gadget/function/f_uac1.c
+++ b/drivers/usb/gadget/function/f_uac1.c
@@ -499,6 +499,7 @@ static void f_audio_disable(struct usb_function *f)
 	uac1->as_out_alt = 0;
 	uac1->as_in_alt = 0;
 
+	u_audio_stop_playback(&uac1->g_audio);
 	u_audio_stop_capture(&uac1->g_audio);
 }
 
-- 
2.30.1


