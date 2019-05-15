Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A5D1F16A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbfEOLxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbfEOLTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:19:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EBD9206BF;
        Wed, 15 May 2019 11:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919159;
        bh=qcAqRpsQJmOGALkMxdl4SNnMFnXFK/gP7NxFjDri3/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3Ldq3uqERKGwNBQDn6XEgDjVdvkhnObZP0oRN3t4BVO2yTGTaVRuFPB5cTX3eWHn
         YM4dnoSHi3cFar6vt88Ct2R40ywAF7deOmWIKVeDZZmZaG7ksytLSt9T/kJ09t7g3Y
         U7zReTbbsZJLT1TW/c1x3V0ObFNZX0ZSK5tHGVQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 088/115] mlxsw: core: Do not use WQ_MEM_RECLAIM for EMAD workqueue
Date:   Wed, 15 May 2019 12:56:08 +0200
Message-Id: <20190515090705.707226275@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a8c133b06183c529c51cd0d54eb57d6b7078370c ]

The EMAD workqueue is used to handle retransmission of EMAD packets that
contain configuration data for the device's firmware.

Given the workers need to allocate these packets and that the code is
not called as part of memory reclaim path, remove the WQ_MEM_RECLAIM
flag.

Fixes: d965465b60ba ("mlxsw: core: Fix possible deadlock")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index cced009da8699..070fd3f7fadf9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -600,7 +600,7 @@ static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_TXRX))
 		return 0;
 
-	emad_wq = alloc_workqueue("mlxsw_core_emad", WQ_MEM_RECLAIM, 0);
+	emad_wq = alloc_workqueue("mlxsw_core_emad", 0, 0);
 	if (!emad_wq)
 		return -ENOMEM;
 	mlxsw_core->emad_wq = emad_wq;
-- 
2.20.1



