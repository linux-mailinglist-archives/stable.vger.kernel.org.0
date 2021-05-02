Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319A4370C04
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhEBOFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232587AbhEBOE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1199A6102A;
        Sun,  2 May 2021 14:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964247;
        bh=4lQy9e8dkXC93bot0YqUtqhnEIMxfdIuRsAE80tMiwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQWxoios/r6fMcIPTLPhm31hwuPYPdKKAZ9Oe38ft2mDDxDBJf1CF8lRTV1k7Yx9H
         O9J3NWmNp7pySwnLOTH+n0obKR8mmPBXXqxCs28oBXsvNzRT9FCDrfPPb3rwDxxSni
         i0MSTuPdYtvx1NrC6qDJ0xpevkhzfWXg1j3xS0zYIqXQMfE0QYZ++RahSVnV6RyW+7
         jy2mx915Rw8XHPEeIsgDb8YMrLMZ/BccWhneRkftlqT8LfHh3ib0dIqM0op+vh4z2J
         FZoJShDa4mLsZ97hPGOCkJQ0/KNR2lcfArvF7wnuVHqa83mwlbFPYYPIXhzSuzNcdl
         Y+fyK2mR/lCOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 16/70] usb: gadget: f_uac1: validate input parameters
Date:   Sun,  2 May 2021 10:02:50 -0400
Message-Id: <20210502140344.2719040-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140344.2719040-1-sashal@kernel.org>
References: <20210502140344.2719040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruslan Bilovol <ruslan.bilovol@gmail.com>

[ Upstream commit a59c68a6a3d1b18e2494f526eb19893a34fa6ec6 ]

Currently user can configure UAC1 function with
parameters that violate UAC1 spec or are not supported
by UAC1 gadget implementation.

This can lead to incorrect behavior if such gadget
is connected to the host - like enumeration failure
or other issues depending on host's UAC1 driver
implementation, bringing user to a long hours
of debugging the issue.

Instead of silently accept these parameters, throw
an error if they are not valid.

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Link: https://lore.kernel.org/r/1614599375-8803-5-git-send-email-ruslan.bilovol@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uac1.c | 43 ++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/function/f_uac1.c
index 560382e0a8f3..e65f474ad7b3 100644
--- a/drivers/usb/gadget/function/f_uac1.c
+++ b/drivers/usb/gadget/function/f_uac1.c
@@ -19,6 +19,9 @@
 #include "u_audio.h"
 #include "u_uac1.h"
 
+/* UAC1 spec: 3.7.2.3 Audio Channel Cluster Format */
+#define UAC1_CHANNEL_MASK 0x0FFF
+
 struct f_uac1 {
 	struct g_audio g_audio;
 	u8 ac_intf, as_in_intf, as_out_intf;
@@ -30,6 +33,11 @@ static inline struct f_uac1 *func_to_uac1(struct usb_function *f)
 	return container_of(f, struct f_uac1, g_audio.func);
 }
 
+static inline struct f_uac1_opts *g_audio_to_uac1_opts(struct g_audio *audio)
+{
+	return container_of(audio->func.fi, struct f_uac1_opts, func_inst);
+}
+
 /*
  * DESCRIPTORS ... most are static, but strings and full
  * configuration descriptors are built on demand.
@@ -505,11 +513,42 @@ static void f_audio_disable(struct usb_function *f)
 
 /*-------------------------------------------------------------------------*/
 
+static int f_audio_validate_opts(struct g_audio *audio, struct device *dev)
+{
+	struct f_uac1_opts *opts = g_audio_to_uac1_opts(audio);
+
+	if (!opts->p_chmask && !opts->c_chmask) {
+		dev_err(dev, "Error: no playback and capture channels\n");
+		return -EINVAL;
+	} else if (opts->p_chmask & ~UAC1_CHANNEL_MASK) {
+		dev_err(dev, "Error: unsupported playback channels mask\n");
+		return -EINVAL;
+	} else if (opts->c_chmask & ~UAC1_CHANNEL_MASK) {
+		dev_err(dev, "Error: unsupported capture channels mask\n");
+		return -EINVAL;
+	} else if ((opts->p_ssize < 1) || (opts->p_ssize > 4)) {
+		dev_err(dev, "Error: incorrect playback sample size\n");
+		return -EINVAL;
+	} else if ((opts->c_ssize < 1) || (opts->c_ssize > 4)) {
+		dev_err(dev, "Error: incorrect capture sample size\n");
+		return -EINVAL;
+	} else if (!opts->p_srate) {
+		dev_err(dev, "Error: incorrect playback sampling rate\n");
+		return -EINVAL;
+	} else if (!opts->c_srate) {
+		dev_err(dev, "Error: incorrect capture sampling rate\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* audio function driver setup/binding */
 static int f_audio_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct usb_composite_dev	*cdev = c->cdev;
 	struct usb_gadget		*gadget = cdev->gadget;
+	struct device			*dev = &gadget->dev;
 	struct f_uac1			*uac1 = func_to_uac1(f);
 	struct g_audio			*audio = func_to_g_audio(f);
 	struct f_uac1_opts		*audio_opts;
@@ -519,6 +558,10 @@ static int f_audio_bind(struct usb_configuration *c, struct usb_function *f)
 	int				rate;
 	int				status;
 
+	status = f_audio_validate_opts(audio, dev);
+	if (status)
+		return status;
+
 	audio_opts = container_of(f->fi, struct f_uac1_opts, func_inst);
 
 	us = usb_gstrings_attach(cdev, uac1_strings, ARRAY_SIZE(strings_uac1));
-- 
2.30.2

