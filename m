Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4A33CDD4D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244610AbhGSO5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239045AbhGSO4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01FA861166;
        Mon, 19 Jul 2021 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708842;
        bh=PixDz5PfxA+JCUrWBu8bcADbB5TXSXqC+ObPbJyllNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fc0ANLIar0It6PSO/73VAYnhif0fweigy0NmmkZYwNAWnammuSQs4QTt5aqxO4N1o
         zddbbnXghTRZoLqa6nVfLakjZgYn7o189VdlJb6J7KNQ/G+1xYAlzE1FtH1kGE20Nw
         hL8KA9KbbkuDDJlsb+YQQ5PZM/tAqMvlfxNiL+Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/421] media: gspca/gl860: fix zero-length control requests
Date:   Mon, 19 Jul 2021 16:48:38 +0200
Message-Id: <20210719144950.292269600@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 262200af76a3..7da437e7785f 100644
--- a/drivers/media/usb/gspca/gl860/gl860.c
+++ b/drivers/media/usb/gspca/gl860/gl860.c
@@ -573,8 +573,8 @@ int gl860_RTx(struct gspca_dev *gspca_dev,
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



