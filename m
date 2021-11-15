Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93846450B9F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhKORZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:25:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236971AbhKORVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:21:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 386A663253;
        Mon, 15 Nov 2021 17:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996614;
        bh=UJSLc3jDBIUc9tkqyUOvxzR5SQxuThss1h9VtgQA6mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKfRFrWs9n0gpCF2cQL2OI85W3bQ6Nfd0yBjYue0/poHB04tx3x/tG+FdGl3sRdPW
         RIZrmCVga4P5nQz3x3efhrzNrIRxC3+1qYBIgJMQ5VWEJLRRyGl2TynDGtvWRvKNKe
         IeT1FCtrcL+xCvjLIu28yuXIClMndTpesQFD9M/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/355] media: tm6000: Avoid card name truncation
Date:   Mon, 15 Nov 2021 18:02:07 +0100
Message-Id: <20211115165320.328889270@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 42bb98e420d454fef3614b70ea11cc59068395f6 ]

The "card" string only holds 31 characters (and the terminating NUL).
In order to avoid truncation, use a shorter card description instead of
the current result, "Trident TVMaster TM5600/6000/60".

Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: e28f49b0b2a8 ("V4L/DVB: tm6000: fix some info messages")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/tm6000/tm6000-video.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index c46cbcfafab3f..8874b0b922eee 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -854,8 +854,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct tm6000_core *dev = ((struct tm6000_fh *)priv)->dev;
 
 	strscpy(cap->driver, "tm6000", sizeof(cap->driver));
-	strscpy(cap->card, "Trident TVMaster TM5600/6000/6010",
-		sizeof(cap->card));
+	strscpy(cap->card, "Trident TM5600/6000/6010", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
 			    V4L2_CAP_DEVICE_CAPS;
-- 
2.33.0



