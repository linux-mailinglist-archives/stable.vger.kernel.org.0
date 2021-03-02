Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D061232AF1A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhCCAPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244730AbhCBMC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:02:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 838BE64F2D;
        Tue,  2 Mar 2021 11:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686169;
        bh=vopivRZMCYdSGdIVT75/EUSZHcJpdNCmqrcBNRYkY2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIZKPjatggsaG/yk39phWy6xovpvJX0BF/BDuN2v3CYi7uD09ytnTcI/o7CZICNVK
         JTDuxuaVXrBcH7GuZ+PwgqCtGutcQlPrBygn6c6HcKQJHozz9euxIstwaAyjrT2WzX
         3YYPqmVI5qJjYsnzkUAhoAS6l0fj/TUwiT2ctxOT6fBypVIlG8wdb2XlVpe832jHiA
         tiy/uSvjVKYe3BLxS8hqcbcKlNfEAipBKTCzRVxbCeMqhO9MhrTxhTQIe8URaH23KG
         4ZY26dC1/R104p98pA/caypZEO31qBZGzZxasWfVcntLkBqh6ug5ln8TQqOBK2uDUV
         AD3W7kAARi7xA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 26/52] clk: qcom: gdsc: Implement NO_RET_PERIPH flag
Date:   Tue,  2 Mar 2021 06:55:07 -0500
Message-Id: <20210302115534.61800-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit 785c02eb35009a4be6dbc68f4f7d916e90b7177d ]

In some rare occasions, we want to only set the RETAIN_MEM bit, but
not the RETAIN_PERIPH one: this is seen on at least SDM630/636/660's
GPU-GX GDSC, where unsetting and setting back the RETAIN_PERIPH bit
will generate chaos and panics during GPU suspend time (mainly, the
chaos is unaligned access).

For this reason, introduce a new NO_RET_PERIPH flag to the GDSC
driver to address this corner case.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210113183817.447866-8-angelogioacchino.delregno@somainline.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 10 ++++++++--
 drivers/clk/qcom/gdsc.h |  3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index af26e0695b86..51ed640e527b 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -183,7 +183,10 @@ static inline int gdsc_assert_reset(struct gdsc *sc)
 static inline void gdsc_force_mem_on(struct gdsc *sc)
 {
 	int i;
-	u32 mask = RETAIN_MEM | RETAIN_PERIPH;
+	u32 mask = RETAIN_MEM;
+
+	if (!(sc->flags & NO_RET_PERIPH))
+		mask |= RETAIN_PERIPH;
 
 	for (i = 0; i < sc->cxc_count; i++)
 		regmap_update_bits(sc->regmap, sc->cxcs[i], mask, mask);
@@ -192,7 +195,10 @@ static inline void gdsc_force_mem_on(struct gdsc *sc)
 static inline void gdsc_clear_mem_on(struct gdsc *sc)
 {
 	int i;
-	u32 mask = RETAIN_MEM | RETAIN_PERIPH;
+	u32 mask = RETAIN_MEM;
+
+	if (!(sc->flags & NO_RET_PERIPH))
+		mask |= RETAIN_PERIPH;
 
 	for (i = 0; i < sc->cxc_count; i++)
 		regmap_update_bits(sc->regmap, sc->cxcs[i], mask, 0);
diff --git a/drivers/clk/qcom/gdsc.h b/drivers/clk/qcom/gdsc.h
index bd537438c793..5bb396b344d1 100644
--- a/drivers/clk/qcom/gdsc.h
+++ b/drivers/clk/qcom/gdsc.h
@@ -42,7 +42,7 @@ struct gdsc {
 #define PWRSTS_ON		BIT(2)
 #define PWRSTS_OFF_ON		(PWRSTS_OFF | PWRSTS_ON)
 #define PWRSTS_RET_ON		(PWRSTS_RET | PWRSTS_ON)
-	const u8			flags;
+	const u16			flags;
 #define VOTABLE		BIT(0)
 #define CLAMP_IO	BIT(1)
 #define HW_CTRL		BIT(2)
@@ -51,6 +51,7 @@ struct gdsc {
 #define POLL_CFG_GDSCR	BIT(5)
 #define ALWAYS_ON	BIT(6)
 #define RETAIN_FF_ENABLE	BIT(7)
+#define NO_RET_PERIPH	BIT(8)
 	struct reset_controller_dev	*rcdev;
 	unsigned int			*resets;
 	unsigned int			reset_count;
-- 
2.30.1

