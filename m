Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9F23A7E5
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731536AbfFIQy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732720AbfFIQy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:54:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D093E206BB;
        Sun,  9 Jun 2019 16:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099295;
        bh=4FML/o2EtP3soLK1Ab0p0Ho+ha22Df+p/94QuNrxILI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2Ru52nmAMsl1IkCn/PxR2PjogHA6KjZZL+JaTc9vCaQQTzGTv5FjtGFIXBLflRBc
         JWYQFlstMTk5KWRtY2NOsc3XQIxvz2opzXWy9qWimrkJfJYoRFoeLxvfrXPX3qjy7W
         iKyJZWQPsVmskw4UdYGUnInHzihAl/+SGQXDXcQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Dufresne <dufresnep@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.9 79/83] drm/radeon: prefer lower reference dividers
Date:   Sun,  9 Jun 2019 18:42:49 +0200
Message-Id: <20190609164134.682755401@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 2e26ccb119bde03584be53406bbd22e711b0d6e6 upstream.

Instead of the closest reference divider prefer the lowest,
this fixes flickering issues on HP Compaq nx9420.

Bugs: https://bugs.freedesktop.org/show_bug.cgi?id=108514
Suggested-by: Paul Dufresne <dufresnep@gmail.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_display.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -935,12 +935,12 @@ static void avivo_get_fb_ref_div(unsigne
 	ref_div_max = max(min(100 / post_div, ref_div_max), 1u);
 
 	/* get matching reference and feedback divider */
-	*ref_div = min(max(DIV_ROUND_CLOSEST(den, post_div), 1u), ref_div_max);
+	*ref_div = min(max(den/post_div, 1u), ref_div_max);
 	*fb_div = DIV_ROUND_CLOSEST(nom * *ref_div * post_div, den);
 
 	/* limit fb divider to its maximum */
 	if (*fb_div > fb_div_max) {
-		*ref_div = DIV_ROUND_CLOSEST(*ref_div * fb_div_max, *fb_div);
+		*ref_div = (*ref_div * fb_div_max)/(*fb_div);
 		*fb_div = fb_div_max;
 	}
 }


