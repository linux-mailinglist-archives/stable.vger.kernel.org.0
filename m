Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3011B38A9BF
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbhETLGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238904AbhETLEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:04:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC7AF61D18;
        Thu, 20 May 2021 10:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505082;
        bh=FTzwyjt6Q+HO2/iZymre7bCZ/r3haZklXwZJ9kdhC/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NT8ioos+ZJ1oyzxk/mEyo7rMDeEGS8AzMlsfxQHnnuQLTOMdcryY8WF8XWBxQBeg4
         Qyp9P/hvCLOfGjRmZtRoYHRBmxq2J2GaAGIgpGqdmNwRz6x6hjlXQUdhBLP1IwNiEz
         jz8Kmz1OyU3+nc1Xvr7SRu4+aK44PkuFEs50yEVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianping Fang <tianping.fang@mediatek.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 4.9 213/240] usb: core: hub: fix race condition about TRSMRCY of resume
Date:   Thu, 20 May 2021 11:23:25 +0200
Message-Id: <20210520092115.829789969@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 975f94c7d6c306b833628baa9aec3f79db1eb3a1 upstream.

This may happen if the port becomes resume status exactly
when usb_port_resume() gets port status, it still need provide
a TRSMCRY time before access the device.

CC: <stable@vger.kernel.org>
Reported-by: Tianping Fang <tianping.fang@mediatek.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20210512020738.52961-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3486,9 +3486,6 @@ int usb_port_resume(struct usb_device *u
 		 * sequence.
 		 */
 		status = hub_port_status(hub, port1, &portstatus, &portchange);
-
-		/* TRSMRCY = 10 msec */
-		msleep(10);
 	}
 
  SuspendCleared:
@@ -3503,6 +3500,9 @@ int usb_port_resume(struct usb_device *u
 				usb_clear_port_feature(hub->hdev, port1,
 						USB_PORT_FEAT_C_SUSPEND);
 		}
+
+		/* TRSMRCY = 10 msec */
+		msleep(10);
 	}
 
 	if (udev->persist_enabled)


