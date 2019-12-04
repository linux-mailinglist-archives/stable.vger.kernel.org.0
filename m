Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAFE21134CA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfLDR74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbfLDR7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:59:52 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A424820675;
        Wed,  4 Dec 2019 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482392;
        bh=64j4seBtU2BgtBMuT/TmYWkYcog1hhKB+5Xq/rBFpZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKZbg5yqCnqQhks1VMkJM4pC3N3zmCZPKpuTgE915yq2JTz59vRRwHESJLonIInRx
         upeQ8TVcHO4UAt7VoFuA6FcIB+hCCkHK817E6zyA40OyjENzjPh/IIccTSmQOg9zdy
         OEXLlBunWRrTPsrpOVc6zX6rs+Qob542Y4RM7iSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bert Kenward <bkenward@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 69/92] sfc: initialise found bitmap in efx_ef10_mtd_probe
Date:   Wed,  4 Dec 2019 18:50:09 +0100
Message-Id: <20191204174334.466362087@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bert Kenward <bkenward@solarflare.com>

[ Upstream commit c65285428b6e7797f1bb063f33b0ae7e93397b7b ]

The bitmap of found partitions in efx_ef10_mtd_probe was not
initialised, causing partitions to be suppressed based off whatever
value was in the bitmap at the start.

Fixes: 3366463513f5 ("sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe")
Signed-off-by: Bert Kenward <bkenward@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 79a1031c3ef77..6dcd436e6e323 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -4499,7 +4499,7 @@ static int efx_ef10_mtd_probe_partition(struct efx_nic *efx,
 static int efx_ef10_mtd_probe(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX);
-	DECLARE_BITMAP(found, EF10_NVRAM_PARTITION_COUNT);
+	DECLARE_BITMAP(found, EF10_NVRAM_PARTITION_COUNT) = { 0 };
 	struct efx_mcdi_mtd_partition *parts;
 	size_t outlen, n_parts_total, i, n_parts;
 	unsigned int type;
-- 
2.20.1



