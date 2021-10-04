Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CE1420F01
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhJDNaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237366AbhJDN2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1744761B2B;
        Mon,  4 Oct 2021 13:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353161;
        bh=XrX7Czu3Yi/FGL1dPnOOl4+W1NlA+UJMrEJpHqP1tQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJWF3t6NiCiMNg8nKFAcjxO5MEBpzzfgYFGyTUzzf3rk5ky4OhHF2JDBNIbVtzC2t
         d/WTzeFMw6JZOllIqt/ihDS8maedM5EfLUYhuNsQGEA5JDtkvo4Fvq9jaAwyzMjKvR
         +TKRlVb8KRRYgo1jkKN7ooN+24zQFf0RsAPVVZmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 002/172] media: cedrus: Fix SUNXI tile size calculation
Date:   Mon,  4 Oct 2021 14:50:52 +0200
Message-Id: <20211004125045.029869309@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 132c88614f2b3548cd3c8979a434609019db4151 ]

Tiled formats requires full rows being allocated (even for Chroma
planes). When the number of Luma tiles is odd, we need to round up
to twice the tile width in order to roundup the number of Chroma
tiles.

This was notice with a crash running BA1_FT_C compliance test using
sunxi tiles using GStreamer. Cedrus driver would allocate 9 rows for
Luma, but only 4.5 rows for Chroma, causing userspace to crash.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Fixes: 50e761516f2b8 ("media: platform: Add Cedrus VPU decoder driver")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 32c13ecb22d8..a8168ac2fbd0 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -135,7 +135,7 @@ void cedrus_prepare_format(struct v4l2_pix_format *pix_fmt)
 		sizeimage = bytesperline * height;
 
 		/* Chroma plane size. */
-		sizeimage += bytesperline * height / 2;
+		sizeimage += bytesperline * ALIGN(height, 64) / 2;
 
 		break;
 
-- 
2.33.0



