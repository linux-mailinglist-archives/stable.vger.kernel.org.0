Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D143C48D6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbhGLGlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34399 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238389AbhGLGkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE08E610A6;
        Mon, 12 Jul 2021 06:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071828;
        bh=ZQFZCT/1GaOWG3E45wzTaTzlAdhXKypjkxuIrHodONA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNCaF0BCO5Q8S6iUW4tq2zKggbGCE67RQeqB3Zt3g8pTLizSvNtLMlNbVKcJ0//kP
         c0r8IuXJ+8XxP4fBTyOFhsG87Cm6L0Sf38kUGWOe0zT7Sn98GK7SOdxx/Qd+4tHowu
         UIn/s3a8DoxQd4R6IcLv965X8pjoIdTwVpDtvWvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/593] media: gspca/gl860: fix zero-length control requests
Date:   Mon, 12 Jul 2021 08:06:36 +0200
Message-Id: <20210712060908.852800321@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 8ed339f23d41e21660a389adf2e7b2966d457ff6 ]

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Control transfers without a data stage are treated as OUT requests by
the USB stack and should be using usb_sndctrlpipe(). Failing to do so
will now trigger a warning.

Fix the gl860_RTx() helper so that zero-length control reads fail with
an error message instead. Note that there are no current callers that
would trigger this.

Fixes: 4f7cb8837cec ("V4L/DVB (12954): gspca - gl860: Addition of GL860 based webcams")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/gl860/gl860.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/gl860/gl860.c b/drivers/media/usb/gspca/gl860/gl860.c
index 2c05ea2598e7..ce4ee8bc75c8 100644
--- a/drivers/media/usb/gspca/gl860/gl860.c
+++ b/drivers/media/usb/gspca/gl860/gl860.c
@@ -561,8 +561,8 @@ int gl860_RTx(struct gspca_dev *gspca_dev,
 					len, 400 + 200 * (len > 1));
 			memcpy(pdata, gspca_dev->usb_buf, len);
 		} else {
-			r = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-					req, pref, val, index, NULL, len, 400);
+			gspca_err(gspca_dev, "zero-length read request\n");
+			r = -EINVAL;
 		}
 	}
 
-- 
2.30.2



