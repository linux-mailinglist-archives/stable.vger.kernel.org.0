Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CEF23A5A0
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgHCMd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729435AbgHCMd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:33:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D7A204EC;
        Mon,  3 Aug 2020 12:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458007;
        bh=jWGFztSlPZ2Ee/FF2hv8UCt06rAB2GbADoQoBX0DGEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qy7jgukRHLVI1QPdzOGsTSZjep42qJuRDBAslHO60gN1aoeeigx6Wx5lNVfiaiefU
         aZxAKUp9kJnEhbOIuhG+cmEQoaJydBu+zD9/ocNRN0ceyi+f8y8YjoEuSx0wqaeGjH
         bDyzc5M9lezLKnvyDwQH+p5l80urdSyyMrpmd8hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/56] net/mlx5: Verify Hardware supports requested ptp function on a given pin
Date:   Mon,  3 Aug 2020 14:19:46 +0200
Message-Id: <20200803121851.847496622@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit 071995c877a8646209d55ff8edddd2b054e7424c ]

Fix a bug where driver did not verify Hardware pin capabilities for
PTP functions.

Fixes: ee7f12205abc ("net/mlx5e: Implement 1PPS support")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 23 ++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 54f1a40a68edd..d359e850dbf07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -366,10 +366,31 @@ static int mlx5_ptp_enable(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+enum {
+	MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_IN = BIT(0),
+	MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_OUT = BIT(1),
+};
+
 static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 			   enum ptp_pin_function func, unsigned int chan)
 {
-	return (func == PTP_PF_PHYSYNC) ? -EOPNOTSUPP : 0;
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock,
+						ptp_info);
+
+	switch (func) {
+	case PTP_PF_NONE:
+		return 0;
+	case PTP_PF_EXTTS:
+		return !(clock->pps_info.pin_caps[pin] &
+			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_IN);
+	case PTP_PF_PEROUT:
+		return !(clock->pps_info.pin_caps[pin] &
+			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_OUT);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
 }
 
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
-- 
2.25.1



