Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FE4328697
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhCARMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237038AbhCARGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:06:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6E164FFE;
        Mon,  1 Mar 2021 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616801;
        bh=o8CLskPD1LDP/xRiRYWR+6METXCll3RqbXoDtbfYEE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPhwu+CBcw+jIggQ8fB8kpUflvDWWtprxmpNNy4p4Xi0oEzDS/2rp/Ktw1sXh8OLX
         tzwy03oTLQNjHStahZth/SpwU8m5NbbGy0jCs4vujsvgTLc8DT/2xi4j4FOxm+VPTa
         gJlnIfR+YPlk+yTYWMdhCC0z0b0+3g5+xAt+XE5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/247] hwrng: timeriomem - Fix cooldown period calculation
Date:   Mon,  1 Mar 2021 17:12:01 +0100
Message-Id: <20210301161036.624360386@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index f615684028af7..ba01f24db6db0 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -72,7 +72,7 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 		 */
 		if (retval > 0)
 			usleep_range(period_us,
-					period_us + min(1, period_us / 100));
+					period_us + max(1, period_us / 100));
 
 		*(u32 *)data = readl(priv->io_base);
 		retval += sizeof(u32);
-- 
2.27.0



