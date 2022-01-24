Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B6499396
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385930AbiAXUes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347217AbiAXU2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:28:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEBEC082554;
        Mon, 24 Jan 2022 11:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E94F4B811F9;
        Mon, 24 Jan 2022 19:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25789C340E5;
        Mon, 24 Jan 2022 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053309;
        bh=qfAGAbyPTg3olyE7z+5FG/FBdquTGx9E7vNPDPs2aZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMY9bwONWpsN897sJ5kfF+kqkvZ0b7NHEWzhsUW7pJu9psTMMBPJau9ebfc+xec0+
         ETRDqRl9Sata5Uzn07EcxxMQF/oPuPcZX9ahsduvmiTnnBiGHr3ehbHpbuPh7c7Ie6
         wac6b7P3+a6XGTcPFX5Ad7qmW838YceSRBvULPYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 023/563] media: cpia2: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:36:28 +0100
Message-Id: <20220124184025.226832463@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 10729be03327f53258cb196362015ad5c6eabe02 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: ab33d5071de7 ("V4L/DVB (3376): Add cpia2 camera support")
Cc: stable@vger.kernel.org      # 2.6.17
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/cpia2/cpia2_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -550,7 +550,7 @@ static int write_packet(struct usb_devic
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	kfree(buf);
 	return ret;
@@ -582,7 +582,7 @@ static int read_packet(struct usb_device
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	if (ret >= 0)
 		memcpy(registers, buf, size);


