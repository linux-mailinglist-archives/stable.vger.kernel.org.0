Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7C91C4598
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgEDSQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730675AbgEDR7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6709E206D9;
        Mon,  4 May 2020 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615145;
        bh=Z+tyRfl1Y/I0+t9KnKRbwn1BP0KDs/FUDpKOv23okvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqKvdzZeFphi7raV6f84jn/uE10tBENYSwT/nAO8CjSzLY+kKK6MLHf2e4IDkoamn
         jmt3i2YdlOeELxXiKbcp/TtWlOzFj5N4KXqU6zbTdVSBA0mAFs9aOvViLSxmqgcCd2
         uF2p1rCh7GnGjDO2kNexGXQQtRVabS1PIxiUoRyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 4.4 14/18] [media] exynos4-is: fix a format string bug
Date:   Mon,  4 May 2020 19:57:12 +0200
Message-Id: <20200504165444.460789674@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 76a563675485849f6f9ad5b30df220438b3628c1 upstream.

Ironically, 7d4020c3c400 ("[media] exynos4-is: fix some warnings when
compiling on arm64") fixed some format string bugs but introduced a
new one. buf_index is a simple int, so it should be printed with %d,
not %pad (which is correctly used for dma_addr_t).

Fixes: 7d4020c3c400 ("[media] exynos4-is: fix some warnings when compiling on arm64")

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -221,8 +221,8 @@ static void isp_video_capture_buffer_que
 							ivb->dma_addr[i];
 
 			isp_dbg(2, &video->ve.vdev,
-				"dma_buf %pad (%d/%d/%d) addr: %pad\n",
-				&buf_index, ivb->index, i, vb->index,
+				"dma_buf %d (%d/%d/%d) addr: %pad\n",
+				buf_index, ivb->index, i, vb->index,
 				&ivb->dma_addr[i]);
 		}
 


