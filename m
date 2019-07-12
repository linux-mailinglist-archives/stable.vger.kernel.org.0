Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E643466E2F
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfGLMb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728961AbfGLMbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:31:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD2C2208E4;
        Fri, 12 Jul 2019 12:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934683;
        bh=MSPgBwwjCbXeXXZrUmdqZApuH6gsttF8DqwzR4eoduQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlncjxuAmJEFasaCBotP4mBPVtFfM7A13W1KDMd+McqChwWIv7TA7JFUx9pmOnzKf
         Alj38EfLDHmSp+1do7E+3xmck/20tgMxRxkNSL2UflKKvgUZYGERNRANXpaOQD0Zr1
         pEs9mz+7xquKmNUPRioEtp/WReW3G+cVc5Eya6t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.1 136/138] staging: bcm2835-camera: Remove check of the number of buffers supplied
Date:   Fri, 12 Jul 2019 14:20:00 +0200
Message-Id: <20190712121633.926594793@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.org>

commit bb8e97006d701ae725a177f8f322e5a75fa761b7 upstream.

Before commit "staging: bcm2835-camera: Remove V4L2/MMAL buffer remapping"
there was a need to ensure that there were sufficient buffers supplied from
the user to cover those being sent to the VPU (always 1).

Now the buffers are linked 1:1 between MMAL and V4L2,
therefore there is no need for that check, and indeed it is wrong
as there is no need to submit all the buffers before starting streaming.

Fixes: 938416707071 ("staging: bcm2835-camera: Remove V4L2/MMAL buffer remapping")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -1328,16 +1328,6 @@ static int port_enable(struct vchiq_mmal
 	if (port->enabled)
 		return 0;
 
-	/* ensure there are enough buffers queued to cover the buffer headers */
-	if (port->buffer_cb) {
-		hdr_count = 0;
-		list_for_each(buf_head, &port->buffers) {
-			hdr_count++;
-		}
-		if (hdr_count < port->current_buffer.num)
-			return -ENOSPC;
-	}
-
 	ret = port_action_port(instance, port,
 			       MMAL_MSG_PORT_ACTION_TYPE_ENABLE);
 	if (ret)


