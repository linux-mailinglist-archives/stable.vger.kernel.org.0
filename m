Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF05111E71
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfLCXCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730329AbfLCWzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:55:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E2832053B;
        Tue,  3 Dec 2019 22:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413711;
        bh=Dr+mkal+all/8Kg0o0xztS3V2Jzy2TMLnQjSnpZ74/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEl4fbZCkiy41lDaNIzzNdNibP++ghMHtWf2J3XVpJ2zs34o0pL4iNO4G8A8icoEG
         1MBChJO0Sen+p5J6ubddqOgUitsfjX+2gHaB5tprJsJsKGT0X2og3j6+60D4Geohk5
         8Bfa5M++eJjn7CeJ0bBIoHbcWJlEjbRiwT57yAVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bert Kenward <bkenward@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/321] sfc: initialise found bitmap in efx_ef10_mtd_probe
Date:   Tue,  3 Dec 2019 23:34:59 +0100
Message-Id: <20191203223439.251448936@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
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
index a497aace7e4f4..1f971d31ec302 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -6108,7 +6108,7 @@ static int efx_ef10_mtd_probe_partition(struct efx_nic *efx,
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



