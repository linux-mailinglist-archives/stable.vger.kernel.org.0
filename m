Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE15450CBA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbhKORm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237952AbhKORjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:39:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E0B4632E9;
        Mon, 15 Nov 2021 17:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997201;
        bh=fgW7IZ0V+TaDrxPJYsD4H4Awxt+nUIrh1fRJjTlfW18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdthC8bmz3dYtw7m2BlOfczrXxryco751/9yGmMDiVO28feL0YraXek/vxEjI/ha2
         nZbPD5OXmuQT2m2aRe9je9UYT5Iml24ReGRpgKM7at7I5hN6+gCTMvesWNSnwRmNu3
         HxMvV+Nqc69t5IpNGPwcMo+0lkA0WHYsT/SRffkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/575] reset: tegra-bpmp: Handle errors in BPMP response
Date:   Mon, 15 Nov 2021 17:56:26 +0100
Message-Id: <20211115165345.753087760@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit c045ceb5a145d2a9a4bf33cbc55185ddf99f60ab ]

The return value from tegra_bpmp_transfer indicates the success or
failure of the IPC transaction with BPMP. If the transaction
succeeded, we also need to check the actual command's result code.
Add code to do this.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Link: https://lore.kernel.org/r/20210915085517.1669675-2-mperttunen@nvidia.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/tegra/reset-bpmp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/tegra/reset-bpmp.c b/drivers/reset/tegra/reset-bpmp.c
index 24d3395964cc4..4c5bba52b1059 100644
--- a/drivers/reset/tegra/reset-bpmp.c
+++ b/drivers/reset/tegra/reset-bpmp.c
@@ -20,6 +20,7 @@ static int tegra_bpmp_reset_common(struct reset_controller_dev *rstc,
 	struct tegra_bpmp *bpmp = to_tegra_bpmp(rstc);
 	struct mrq_reset_request request;
 	struct tegra_bpmp_message msg;
+	int err;
 
 	memset(&request, 0, sizeof(request));
 	request.cmd = command;
@@ -30,7 +31,13 @@ static int tegra_bpmp_reset_common(struct reset_controller_dev *rstc,
 	msg.tx.data = &request;
 	msg.tx.size = sizeof(request);
 
-	return tegra_bpmp_transfer(bpmp, &msg);
+	err = tegra_bpmp_transfer(bpmp, &msg);
+	if (err)
+		return err;
+	if (msg.rx.ret)
+		return -EINVAL;
+
+	return 0;
 }
 
 static int tegra_bpmp_reset_module(struct reset_controller_dev *rstc,
-- 
2.33.0



