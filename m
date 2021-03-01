Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC1C328C78
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbhCASwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:52:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240185AbhCASmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:42:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8B4464DA3;
        Mon,  1 Mar 2021 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620792;
        bh=XQnAJbcKoe9KTUO3XhMJJoVlbMZBjmlecvReRl3DMBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItOBicpTvGe/wdNei6C2Kt/mU6rhpyjfrnszsviD6ttKe0iMGVRdhrjX07/Txvg+0
         zsC8nUpYYREvo/MHnO0FltwALeqh+QYMpxAdzzCg/mO1nXvnAznBc+qCPuJggGqJzH
         5M6dxLvAOrpCBOyPouiOkJX6+zp5b1DOF+MXsD+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 282/775] hwrng: timeriomem - Fix cooldown period calculation
Date:   Mon,  1 Mar 2021 17:07:30 +0100
Message-Id: <20210301161215.564965922@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>

[ Upstream commit e145f5565dc48ccaf4cb50b7cfc48777bed8c100 ]

Ensure cooldown period tolerance of 1% is actually accounted for.

Fixes: ca3bff70ab32 ("hwrng: timeriomem - Improve performance...")
Signed-off-by: Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/timeriomem-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index e262445fed5f5..f35f0f31f52ad 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -69,7 +69,7 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 		 */
 		if (retval > 0)
 			usleep_range(period_us,
-					period_us + min(1, period_us / 100));
+					period_us + max(1, period_us / 100));
 
 		*(u32 *)data = readl(priv->io_base);
 		retval += sizeof(u32);
-- 
2.27.0



