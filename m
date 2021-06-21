Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19903AEF4A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbhFUQhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233234AbhFUQfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 008E9613F3;
        Mon, 21 Jun 2021 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292872;
        bh=HRf0ZSrkfyHe0/IFB/b5mWNvsTHojAK2d/XMRjYddBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTm/osjkPTZriWL+PtF+KBTnMdsiVAn2qFSswwbBqHh+qmn8+rRpl3UykJs6V0+45
         h/jYCABh/aX1kKx9BQ+o9nnZPvuGRRjjMSkUBJ88SqSjc+5bAgCphTg5RZqixvY33N
         VNKEUi9eBJDCEgpz2sVAdHJ2+DAo7nWfkfgjZ6oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maksym Yaremchuk <maksymy@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 016/178] mlxsw: reg: Spectrum-3: Enforce lowest max-shaper burst size of 11
Date:   Mon, 21 Jun 2021 18:13:50 +0200
Message-Id: <20210621154922.191932331@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 306b9228c097b4101c150ccd262372ded8348644 ]

A max-shaper is the HW component responsible for delaying egress traffic
above a configured transmission rate. Burst size is the amount of traffic
that is allowed to pass without accounting. The burst size value needs to
be such that it can be expressed as 2^BS * 512 bits, where BS lies in a
certain ASIC-dependent range. mlxsw enforces that this holds before
attempting to configure the shaper.

The assumption for Spectrum-3 was that the lower limit of BS would be 5,
like for Spectrum-1. But as of now, the limit is still 11. Therefore fix
the driver accordingly, so that incorrect values are rejected early with a
proper message.

Fixes: 23effa2479ba ("mlxsw: reg: Add max_shaper_bs to QoS ETS Element Configuration")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c4adc7f740d3..769386971ac3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3863,7 +3863,7 @@ MLXSW_ITEM32(reg, qeec, max_shaper_bs, 0x1C, 0, 6);
 #define MLXSW_REG_QEEC_HIGHEST_SHAPER_BS	25
 #define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1	5
 #define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2	11
-#define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3	5
+#define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3	11
 
 static inline void mlxsw_reg_qeec_pack(char *payload, u8 local_port,
 				       enum mlxsw_reg_qeec_hr hr, u8 index,
-- 
2.30.2



