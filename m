Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5537BD9F42
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437603AbfJPVxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437596AbfJPVxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:50 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D22421928;
        Wed, 16 Oct 2019 21:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262830;
        bh=CYWQcaOnuAPi9weszhjgAytV677F058MhvBumK6Bu0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiMdLHC2eDiZ9ay2nlLdjOnAq4BX7SV74KGZPJvOPQyXwmXrmWivm6+9r8LArv+5F
         fOD1YrsOBStajfolZTXxGDycQTUhQCGbSilYNtMcy9/4oCsxnqTg+OLk2AGPkI6hdz
         JOHhgmZmNJkdBtYJl0486Kg5ZEvDGv8465taByd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Dan Carpenter <dan.carpenter@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 73/79] Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc
Date:   Wed, 16 Oct 2019 14:50:48 -0700
Message-Id: <20191016214832.422128156@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 5bdea6060618cfcf1459dca137e89aee038ac8b9 ]

In fbtft_framebuffer_alloc the error handling path should take care of
releasing frame buffer after it is allocated via framebuffer_alloc, too.
Therefore, in two failure cases the goto destination is changed to
address this issue.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190930030949.28615-1-navid.emamdoost@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 18c2b6daf5885..15937e0ef4d96 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -813,7 +813,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	if (par->gamma.curves && gamma) {
 		if (fbtft_gamma_parse_str(par,
 			par->gamma.curves, gamma, strlen(gamma)))
-			goto alloc_fail;
+			goto release_framebuf;
 	}
 
 	/* Transmit buffer */
@@ -836,7 +836,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 			txbuf = devm_kzalloc(par->info->device, txbuflen, GFP_KERNEL);
 		}
 		if (!txbuf)
-			goto alloc_fail;
+			goto release_framebuf;
 		par->txbuf.buf = txbuf;
 		par->txbuf.len = txbuflen;
 	}
@@ -872,6 +872,9 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 
 	return info;
 
+release_framebuf:
+	framebuffer_release(info);
+
 alloc_fail:
 	vfree(vmem);
 
-- 
2.20.1



