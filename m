Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24CB38A509
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbhETKMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236027AbhETKKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:10:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 118846195C;
        Thu, 20 May 2021 09:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503780;
        bh=Nr2UyS5O9GbSvzBZgqZxImUZAKmN8r9OxMeGt7I8qKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/ayX8dVlgKD4XUqV14qAaETSboSDBthB8KMxavbQgTYNwCvCBbX3eJrvILoJyjwc
         cg9/YTXy/BD1Hkbwb0q2u607zecL4hc07BWG39hwmgvDdzG/o17ABmBhJwZllxC1L6
         1ZiKMVJKhC6/ui6Xgk3SuxV5SVwVLZMalCUfBG38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianping Fang <tianping.fang@mediatek.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 4.19 377/425] usb: core: hub: fix race condition about TRSMRCY of resume
Date:   Thu, 20 May 2021 11:22:26 +0200
Message-Id: <20210520092143.782761921@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -3539,9 +3539,6 @@ int usb_port_resume(struct usb_device *u
 		 * sequence.
 		 */
 		status = hub_port_status(hub, port1, &portstatus, &portchange);
-
-		/* TRSMRCY = 10 msec */
-		msleep(10);
 	}
 
  SuspendCleared:
@@ -3556,6 +3553,9 @@ int usb_port_resume(struct usb_device *u
 				usb_clear_port_feature(hub->hdev, port1,
 						USB_PORT_FEAT_C_SUSPEND);
 		}
+
+		/* TRSMRCY = 10 msec */
+		msleep(10);
 	}
 
 	if (udev->persist_enabled)


