Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D7562540
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbfGHPQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732443AbfGHPP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 712B221738;
        Mon,  8 Jul 2019 15:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598958;
        bh=4yAOqHe/Tnu0uN2tFe+uZ1CGfVPCGx4vijPr2fKlwzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VukZkM/LXWUY+BjsOWKqtJ2qbgBkUFJtlrsQk+cLtIYbHNawjOYjtRDgGS/QCwNDK
         9e2i1hrll33MRvykZLcxEYzT2hoIpJkwiVJxRli0JnTrruUO6HNK0qlSlXfPSQ7xRS
         XOKWUPhwjXEAI5C3etzRL5c1MXxx/rdfauBsuXRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.4 07/73] Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD
Date:   Mon,  8 Jul 2019 17:12:17 +0200
Message-Id: <20190708150518.545015393@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>

commit 7c7da40da1640ce6814dab1e8031b44e19e5a3f6 upstream.

In the case of compat syscall ioctl numbers for UI_BEGIN_FF_UPLOAD and
UI_END_FF_UPLOAD need to be adjusted before being passed on
uinput_ioctl_handler() since code built with -m32 will be passing
slightly different values. Extend the code already covering
UI_SET_PHYS to cover UI_BEGIN_FF_UPLOAD and UI_END_FF_UPLOAD as well.

Reported-by: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/misc/uinput.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -894,13 +894,31 @@ static long uinput_ioctl(struct file *fi
 
 #ifdef CONFIG_COMPAT
 
-#define UI_SET_PHYS_COMPAT	_IOW(UINPUT_IOCTL_BASE, 108, compat_uptr_t)
+/*
+ * These IOCTLs change their size and thus their numbers between
+ * 32 and 64 bits.
+ */
+#define UI_SET_PHYS_COMPAT		\
+	_IOW(UINPUT_IOCTL_BASE, 108, compat_uptr_t)
+#define UI_BEGIN_FF_UPLOAD_COMPAT	\
+	_IOWR(UINPUT_IOCTL_BASE, 200, struct uinput_ff_upload_compat)
+#define UI_END_FF_UPLOAD_COMPAT		\
+	_IOW(UINPUT_IOCTL_BASE, 201, struct uinput_ff_upload_compat)
 
 static long uinput_compat_ioctl(struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
-	if (cmd == UI_SET_PHYS_COMPAT)
+	switch (cmd) {
+	case UI_SET_PHYS_COMPAT:
 		cmd = UI_SET_PHYS;
+		break;
+	case UI_BEGIN_FF_UPLOAD_COMPAT:
+		cmd = UI_BEGIN_FF_UPLOAD;
+		break;
+	case UI_END_FF_UPLOAD_COMPAT:
+		cmd = UI_END_FF_UPLOAD;
+		break;
+	}
 
 	return uinput_ioctl_handler(file, cmd, arg, compat_ptr(arg));
 }


