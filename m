Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B553CAB75
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343497AbhGOTUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244104AbhGOTSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:18:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 622436115B;
        Thu, 15 Jul 2021 19:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376405;
        bh=yD8e8WJdVZmULPVGiZv1xgiYX5ubqFqt5bbOCI7VAJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXp8EkbyRyVfk839t7FVYpAPI7IFYcDrsoNEKYsk4/IjXlAuDjuJZxYkDHETuE4/a
         s7OcuYRmbqisfkg/JTEVb9LQgHQzHxmPFRDwEgCOx7+cQW5zJnVmsofxIvybpt6g4/
         C/TK/7eIAu0BN+msClVo2WSZDsiZJygYwNpaISAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.13 250/266] media: gspca/sq905: fix control-request direction
Date:   Thu, 15 Jul 2021 20:40:05 +0200
Message-Id: <20210715182652.058248158@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 53ae298fde7adcc4b1432bce2dbdf8dac54dfa72 upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the USB_REQ_SYNCH_FRAME request which erroneously used
usb_sndctrlpipe().

Fixes: 27d35fc3fb06 ("V4L/DVB (10639): gspca - sq905: New subdriver.")
Cc: stable@vger.kernel.org      # 2.6.30
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/sq905.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -116,7 +116,7 @@ static int sq905_command(struct gspca_de
 	}
 
 	ret = usb_control_msg(gspca_dev->dev,
-			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      usb_rcvctrlpipe(gspca_dev->dev, 0),
 			      USB_REQ_SYNCH_FRAME,                /* request */
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      SQ905_PING, 0, gspca_dev->usb_buf, 1,


