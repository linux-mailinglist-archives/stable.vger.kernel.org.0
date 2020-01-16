Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D9113E7D2
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404124AbgAPR2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:28:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404119AbgAPR2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BF6C246D3;
        Thu, 16 Jan 2020 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195689;
        bh=fVD59v4HzKA+nw+3PFTJ1B5tJBeyzcJqeHA3osuaqjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyQkacn1SWcYZ59ziKvNm8hYPDeUWLEqH4k7CM/Zcbx3eHbnzA1/MQh2bp0yTtF5i
         n3G3ML1xwe3HJEsOOnTQHb1aX9xbiSxSCeh3yp51lKnzSV9J+lcW1a0V7h9V3YgPGw
         Kv8ZxnsEC72YrmKNSYOreh+DCjmLc2dh0Kq6ckfM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bryan O'Donoghue <pure.logic@nexus-software.ie>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 240/371] nvmem: imx-ocotp: Ensure WAIT bits are preserved when setting timing
Date:   Thu, 16 Jan 2020 12:21:52 -0500
Message-Id: <20200116172403.18149-183-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

[ Upstream commit 0493c4792b4eb260441e57f52cc11a9ded48b5a7 ]

The i.MX6 and i.MX8 both have a bit-field spanning bits 27:22 called the
WAIT field.

The WAIT field according to the documentation for both parts "specifies
time interval between auto read and write access in one time program. It is
given in number of ipg_clk periods."

This patch ensures that the relevant field is read and written back to the
timing register.

Fixes: 0642bac7da42 ("nvmem: imx-ocotp: add write support")

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/imx-ocotp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/imx-ocotp.c b/drivers/nvmem/imx-ocotp.c
index 193ca8fd350a..0c8c3b9bb6a7 100644
--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -199,7 +199,8 @@ static int imx_ocotp_write(void *context, unsigned int offset, void *val,
 	strobe_prog = clk_rate / (1000000000 / 10000) + 2 * (DEF_RELAX + 1) - 1;
 	strobe_read = clk_rate / (1000000000 / 40) + 2 * (DEF_RELAX + 1) - 1;
 
-	timing = strobe_prog & 0x00000FFF;
+	timing = readl(priv->base + IMX_OCOTP_ADDR_TIMING) & 0x0FC00000;
+	timing |= strobe_prog & 0x00000FFF;
 	timing |= (relax       << 12) & 0x0000F000;
 	timing |= (strobe_read << 16) & 0x003F0000;
 
-- 
2.20.1

