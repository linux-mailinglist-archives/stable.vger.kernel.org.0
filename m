Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70E64998CC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453395AbiAXVaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376425AbiAXVTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:19:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03384C06F8ED;
        Mon, 24 Jan 2022 12:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 953EA61028;
        Mon, 24 Jan 2022 20:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A470C340E5;
        Mon, 24 Jan 2022 20:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055218;
        bh=qfAGAbyPTg3olyE7z+5FG/FBdquTGx9E7vNPDPs2aZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXNV7GeZslVamN2y2f2a0z2vQ9LHJyk+UPyMt9oKAhX6seiiVXEjb814m5g5bR9sM
         axyJ31ak/nU0GYWXKBf7+hqYSIBqAM0ImRZ/T/uB6FTSljYnybuVZ5djB1knYb8nVe
         4VP5ssJunEWwRbdPcu9YwTXhLACfH6v+D79X1c7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 046/846] media: cpia2: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:32:43 +0100
Message-Id: <20220124184102.538367716@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


