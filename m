Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B594A35BE6F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbhDLI6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238655AbhDLI4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:56:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB7F261350;
        Mon, 12 Apr 2021 08:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217780;
        bh=kyNMQWNUVWzlRPfJeM+O0r4v4xNKRyFd/vCsPJf4Lz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ/4DejPjy7kmytp3Xz7UcbIwF4cnpizeytOulIW6dIUAJa5HM0wL8xKOtI1b8EcE
         lwQTC8OB7G0WsKFfA13bGjeTTSw/vIIKxDh9CxFNibaixDMcwFNd8qxakJICVHilIv
         F2wyRMT00K/SB5JcdkLDs2uqXBUmWhNT/l3Q6R8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/188] regulator: bd9571mwv: Fix AVS and DVFS voltage range
Date:   Mon, 12 Apr 2021 10:40:11 +0200
Message-Id: <20210412084016.870760186@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 3b6e7088afc919f5b52e4d2de8501ad34d35b09b ]

According to Table 30 ("DVFS_MoniVDAC [6:0] Setting Table") in the
BD9571MWV-M Datasheet Rev. 002, the valid voltage range is 600..1100 mV
(settings 0x3c..0x6e).  While the lower limit is taken into account (by
setting regulator_desc.linear_min_sel to 0x3c), the upper limit is not.

Fix this by reducing regulator_desc.n_voltages from 0x80 to 0x6f.

Fixes: e85c5a153fe237f2 ("regulator: Add ROHM BD9571MWV-M PMIC regulator driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210312130242.3390038-2-geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/bd9571mwv-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/bd9571mwv-regulator.c b/drivers/regulator/bd9571mwv-regulator.c
index e690c2ce5b3c..25e33028871c 100644
--- a/drivers/regulator/bd9571mwv-regulator.c
+++ b/drivers/regulator/bd9571mwv-regulator.c
@@ -124,7 +124,7 @@ static const struct regulator_ops vid_ops = {
 
 static const struct regulator_desc regulators[] = {
 	BD9571MWV_REG("VD09", "vd09", VD09, avs_ops, 0, 0x7f,
-		      0x80, 600000, 10000, 0x3c),
+		      0x6f, 600000, 10000, 0x3c),
 	BD9571MWV_REG("VD18", "vd18", VD18, vid_ops, BD9571MWV_VD18_VID, 0xf,
 		      16, 1625000, 25000, 0),
 	BD9571MWV_REG("VD25", "vd25", VD25, vid_ops, BD9571MWV_VD25_VID, 0xf,
@@ -133,7 +133,7 @@ static const struct regulator_desc regulators[] = {
 		      11, 2800000, 100000, 0),
 	BD9571MWV_REG("DVFS", "dvfs", DVFS, reg_ops,
 		      BD9571MWV_DVFS_MONIVDAC, 0x7f,
-		      0x80, 600000, 10000, 0x3c),
+		      0x6f, 600000, 10000, 0x3c),
 };
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.30.2



