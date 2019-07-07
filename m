Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE20361736
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfGGTqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:46:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57006 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727500AbfGGTiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:04 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0006f5-6E; Sun, 07 Jul 2019 20:38:01 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0005YQ-Aa; Sun, 07 Jul 2019 20:37:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jacek Anaszewski" <jacek.anaszewski@gmail.com>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Pawe? Chmiel" <pawel.mikolaj.chmiel@gmail.com>,
        "Hans Verkuil" <hverkuil-cisco@xs4all.nl>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.887968802@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 027/129] media: s5p-jpeg: Correct step and max values
 for V4L2_CID_JPEG_RESTART_INTERVAL
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pawe? Chmiel <pawel.mikolaj.chmiel@gmail.com>

commit 19c624c6b29e244c418f8b44a711cbf5e82e3cd4 upstream.

This commit corrects max and step values for v4l2 control for
V4L2_CID_JPEG_RESTART_INTERVAL. Max should be 0xffff and step should be 1.
It was found by using v4l2-compliance tool and checking result of
VIDIOC_QUERY_EXT_CTRL/QUERYMENU test.
Previously it was complaining that step was bigger than difference
between max and min.

Fixes: 15f4bc3b1f42 ("[media] s5p-jpeg: Add JPEG controls support")

Signed-off-by: Pawe? Chmiel <pawel.mikolaj.chmiel@gmail.com>
Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1363,7 +1363,7 @@ static int s5p_jpeg_controls_create(stru
 
 		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
 				  V4L2_CID_JPEG_RESTART_INTERVAL,
-				  0, 3, 0xffff, 0);
+				  0, 0xffff, 1, 0);
 		if (ctx->jpeg->variant->version == SJPEG_S5P)
 			mask = ~0x06; /* 422, 420 */
 	}

