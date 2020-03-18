Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6812418A6BF
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgCRVKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 17:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgCRUxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CFFF208DB;
        Wed, 18 Mar 2020 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564810;
        bh=41DXBGjIFS78mwqNahQaRX/x1oKwlEdRCUA3qcHJC94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiZev5ek7AU3hD4ac/Qlup6sqkhDzFstTqPVdt8f8xdKIp+49QiRqWXzepmXAchMY
         IzxPzv9wp3+dRCi6DuNt5WsNPOh5BGutW3N+7A/ke1qHCZzVUNNcTqwhzLtx1lENjp
         lOQOjQfND2Qvi7ZPL06erg2+g7wSq2hT8ZuUVTCM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 07/84] pinctrl: imx: scu: Align imx sc msg structs to 4
Date:   Wed, 18 Mar 2020 16:52:04 -0400
Message-Id: <20200318205321.16066-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205321.16066-1-sashal@kernel.org>
References: <20200318205321.16066-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit 4c48e549f39f8ed10cf8a0b6cb96f5eddf0391ce ]

The imx SC api strongly assumes that messages are composed out of
4-bytes words but some of our message structs have odd sizeofs.

This produces many oopses with CONFIG_KASAN=y.

Fix by marking with __aligned(4).

Fixes: b96eea718bf6 ("pinctrl: fsl: add scu based pinctrl support")
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Link: https://lore.kernel.org/r/bd7ad5fd755739a6d8d5f4f65e03b3ca4f457bd2.1582216144.git.leonard.crestez@nxp.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-scu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-scu.c b/drivers/pinctrl/freescale/pinctrl-scu.c
index 73bf1d9f9cc6f..23cf04bdfc55d 100644
--- a/drivers/pinctrl/freescale/pinctrl-scu.c
+++ b/drivers/pinctrl/freescale/pinctrl-scu.c
@@ -23,12 +23,12 @@ struct imx_sc_msg_req_pad_set {
 	struct imx_sc_rpc_msg hdr;
 	u32 val;
 	u16 pad;
-} __packed;
+} __packed __aligned(4);
 
 struct imx_sc_msg_req_pad_get {
 	struct imx_sc_rpc_msg hdr;
 	u16 pad;
-} __packed;
+} __packed __aligned(4);
 
 struct imx_sc_msg_resp_pad_get {
 	struct imx_sc_rpc_msg hdr;
-- 
2.20.1

