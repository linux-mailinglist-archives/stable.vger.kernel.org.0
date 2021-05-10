Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC02A3782F9
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhEJKlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhEJKjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:39:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39CBC6157F;
        Mon, 10 May 2021 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642619;
        bh=pB5xUl2ACb/xL8k+gSq6LI8vsPtG7gjD/jG+ov0tEF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSnaH+tF21JKwQLMuYI+X176qjHcXVSiRYK4XRRGVpwVkG3UW5h9foW0/hgwwQcCY
         OC7PopI42fk8aRk/ZAhqRYYOenaoxGEIVlh1ZZO7QNa6fbwkEdBe5eIF6XWKaR0yG6
         Bj+sj3C8th81WRiExTu6KKhA2BYfw07aPRIh3EMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 169/184] media: staging/intel-ipu3: Fix memory leak in imu_fmt
Date:   Mon, 10 May 2021 12:21:03 +0200
Message-Id: <20210510101955.656761618@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

commit 3630901933afba1d16c462b04d569b7576339223 upstream.

We are losing the reference to an allocated memory if try. Change the
order of the check to avoid that.

Cc: stable@vger.kernel.org
Fixes: 6d5f26f2e045 ("media: staging/intel-ipu3-v4l: reduce kernel stack usage")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -692,6 +692,13 @@ static int imgu_fmt(struct imgu_device *
 		if (inode == IMGU_NODE_STAT_3A || inode == IMGU_NODE_PARAMS)
 			continue;
 
+		/* CSS expects some format on OUT queue */
+		if (i != IPU3_CSS_QUEUE_OUT &&
+		    !imgu_pipe->nodes[inode].enabled) {
+			fmts[i] = NULL;
+			continue;
+		}
+
 		if (try) {
 			fmts[i] = kmemdup(&imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp,
 					  sizeof(struct v4l2_pix_format_mplane),
@@ -704,10 +711,6 @@ static int imgu_fmt(struct imgu_device *
 			fmts[i] = &imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
 		}
 
-		/* CSS expects some format on OUT queue */
-		if (i != IPU3_CSS_QUEUE_OUT &&
-		    !imgu_pipe->nodes[inode].enabled)
-			fmts[i] = NULL;
 	}
 
 	if (!try) {


