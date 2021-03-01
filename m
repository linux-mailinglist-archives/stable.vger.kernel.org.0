Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D53328539
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhCAQuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:50:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235289AbhCAQnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:43:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81AF264F49;
        Mon,  1 Mar 2021 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616199;
        bh=V98/L0EUBzr8yuMeYy+AoqlN0kVFPbDwNWNec0azZcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJ+1kmBgx5bvy4/Pw1b8IJPxR6xKNtTfd/m0lpF7ZTmly+5UccbhrK2m3tAvTy36v
         mBWMRJcPGKZCTQ/DGAPZexVt79FIMqPHVwxngU2RhTMv0YKzMHOSQ4C4M+/5Wef4jl
         BrvvGIQIuKABU7K7p9ftMMC4bHLOlIwHOczBUtFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 061/176] hwrng: timeriomem - Fix cooldown period calculation
Date:   Mon,  1 Mar 2021 17:12:14 +0100
Message-Id: <20210301161023.979323086@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 03ff5483d8654..1aa7e0b0ae0fe 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -79,7 +79,7 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 		 */
 		if (retval > 0)
 			usleep_range(period_us,
-					period_us + min(1, period_us / 100));
+					period_us + max(1, period_us / 100));
 
 		*(u32 *)data = readl(priv->io_base);
 		retval += sizeof(u32);
-- 
2.27.0



