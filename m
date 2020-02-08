Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886A91565D5
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgBHS3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33524 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727584AbgBHS3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:34 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrE-0003b0-0k; Sat, 08 Feb 2020 18:29:32 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrD-000CJu-0j; Sat, 08 Feb 2020 18:29:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Chris Wilson" <chris@chris-wilson.co.uk>
Date:   Sat, 08 Feb 2020 18:19:18 +0000
Message-ID: <lsq.1581185940.740550818@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 019/148] drm/i810: Prevent underflow in ioctl
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4f69851fbaa26b155330be35ce8ac393e93e7442 upstream.

The "used" variables here come from the user in the ioctl and it can be
negative.  It could result in an out of bounds write.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20191004102251.GC823@mwanda
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i810/i810_dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -724,7 +724,7 @@ static void i810_dma_dispatch_vertex(str
 	if (nbox > I810_NR_SAREA_CLIPRECTS)
 		nbox = I810_NR_SAREA_CLIPRECTS;
 
-	if (used > 4 * 1024)
+	if (used < 0 || used > 4 * 1024)
 		used = 0;
 
 	if (sarea_priv->dirty)
@@ -1044,7 +1044,7 @@ static void i810_dma_dispatch_mc(struct
 	if (u != I810_BUF_CLIENT)
 		DRM_DEBUG("MC found buffer that isn't mine!\n");
 
-	if (used > 4 * 1024)
+	if (used < 0 || used > 4 * 1024)
 		used = 0;
 
 	sarea_priv->dirty = 0x7f;

