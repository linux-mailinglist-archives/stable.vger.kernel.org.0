Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E7E30054E
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbhAVOZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:25:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbhAVOY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A30BC23B03;
        Fri, 22 Jan 2021 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325129;
        bh=EObke+J1RsHKcbk4dvp1s8i82tHpd7T+q7jt78/dGoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3geysE8Ib4kwFBefYwrmo4ShpwLwZtU9L4gxNu7CiwKKa3XIA4uJKWKTAA97OYCG
         hFgKeMe9lRrCwZS9ouXV0hBtTM8zz5ZnOog0KPTnItcy1rG0ArjfspE3MPZg3s3tBd
         o75eQsjehCXoy/KIctCoSMY60fJNuDbTuVk89PxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 18/43] mlxsw: core: Increase critical threshold for ASIC thermal zone
Date:   Fri, 22 Jan 2021 15:12:34 +0100
Message-Id: <20210122135736.392242069@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit b06ca3d5a43ca2dd806f7688a17e8e7e0619a80a ]

Increase critical threshold for ASIC thermal zone from 110C to 140C
according to the system hardware requirements. All the supported ASICs
(Spectrum-1, Spectrum-2, Spectrum-3) could be still operational with ASIC
temperature below 140C. With the old critical threshold value system
can perform unjustified shutdown.

All the systems equipped with the above ASICs implement thermal
protection mechanism at firmware level and firmware could decide to
perform system thermal shutdown in case the temperature is below 140C.
So with the new threshold system will not meltdown, while thermal
operating range will be aligned with hardware abilities.

Fixes: 41e760841d26 ("mlxsw: core: Replace thermal temperature trips with defines")
Fixes: a50c1e35650b ("mlxsw: core: Implement thermal zone")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -19,7 +19,7 @@
 #define MLXSW_THERMAL_ASIC_TEMP_NORM	75000	/* 75C */
 #define MLXSW_THERMAL_ASIC_TEMP_HIGH	85000	/* 85C */
 #define MLXSW_THERMAL_ASIC_TEMP_HOT	105000	/* 105C */
-#define MLXSW_THERMAL_ASIC_TEMP_CRIT	110000	/* 110C */
+#define MLXSW_THERMAL_ASIC_TEMP_CRIT	140000	/* 140C */
 #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
 #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
 #define MLXSW_THERMAL_ZONE_MAX_NAME	16


