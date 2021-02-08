Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFE5313C03
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhBHSAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235140AbhBHR7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:59:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B64364EBA;
        Mon,  8 Feb 2021 17:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807107;
        bh=x0WINOM8wqLpK+VRogvrxA6ZgYuqhW5zPtLG29kuWMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMN/fwBa9tPaQqN0X1QjiTo7PHMOfB+2gF2vxmTICkA7/SkwoAYyPAhGDBQ13xyM/
         4PlhcGlKncVXLR7XkW1KIXXTI9T/dCWCd+vmfW64tkkgiH12GOmOt6C8rhwVch6QPI
         dGxKsbmdQm+hy0z089oGw6pgECapsY3cPWojQspKCKwuCW5YrH8MCbVCruj+OFotts
         DyuJsIWKnYa6CDejpBXrERPfFNYruDVCpkbbkeRFRchNX8MOxwyTWUqSTv1L+FzTVQ
         BURXXlKdCWHaDZkjIukdcjjLqHx6Sy4KxGxVrPqfqpfV5FyPQo7SMGNVP9xDtKIdEp
         L1i4fOJsQui5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 15/36] media: rkisp1: stats: remove a wrong cast to u8
Date:   Mon,  8 Feb 2021 12:57:45 -0500
Message-Id: <20210208175806.2091668-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit a76f8dc8be471028540df24749e99a3ec0ac7c94 ]

hist_bins is an array of type __u32. Each entry represent
a 20 bit fixed point value as documented inline.
The cast to u8 when setting the values is wrong. Remove it.

Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkisp1/rkisp1-stats.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/rkisp1/rkisp1-stats.c b/drivers/staging/media/rkisp1/rkisp1-stats.c
index 51c64f75fe29a..8fdf646c4b75b 100644
--- a/drivers/staging/media/rkisp1/rkisp1-stats.c
+++ b/drivers/staging/media/rkisp1/rkisp1-stats.c
@@ -253,8 +253,7 @@ static void rkisp1_stats_get_hst_meas(struct rkisp1_stats *stats,
 	pbuf->meas_type |= RKISP1_CIF_ISP_STAT_HIST;
 	for (i = 0; i < RKISP1_CIF_ISP_HIST_BIN_N_MAX; i++)
 		pbuf->params.hist.hist_bins[i] =
-			(u8)rkisp1_read(rkisp1,
-					RKISP1_CIF_ISP_HIST_BIN_0 + i * 4);
+			rkisp1_read(rkisp1, RKISP1_CIF_ISP_HIST_BIN_0 + i * 4);
 }
 
 static void rkisp1_stats_get_bls_meas(struct rkisp1_stats *stats,
-- 
2.27.0

