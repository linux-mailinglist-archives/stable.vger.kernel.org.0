Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925232E425D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436709AbgL1OB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436703AbgL1OB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D77C3207A9;
        Mon, 28 Dec 2020 14:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164102;
        bh=uKGek1V1AUMjwNKvp+zpfADHkjF89Gvoezw9yrt/WsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6xc8QmQfnYEEbbPrYsSMWkP2BSuZl60cK3rC4FAKhCLvOmFBK+lynnuQBEHBIJ7Z
         OcFGVL4b8N0i25mxgoNxrrLV6aJOMwEhoJ9AJI0wkNBDjjScF8zhmScBRUwHcycl+t
         46c9nw6cXpgcQ6h5v3TO4DsDaXyO2md+7vbji61Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/717] spi: stm32: fix reference leak in stm32_spi_resume
Date:   Mon, 28 Dec 2020 13:40:59 +0100
Message-Id: <20201228125023.920595242@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 900ccdcb79bb61471df1566a70b2b39687a628d5 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in stm32_spi_resume, so we should fix it.

Fixes: db96bf976a4fc ("spi: stm32: fixes suspend/resume management")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Alain Volmat <alain.volmat@st.com>
Link: https://lore.kernel.org/r/20201106015217.140476-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 2cc850eb8922d..471dedf3d3392 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -2062,6 +2062,7 @@ static int stm32_spi_resume(struct device *dev)
 
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
 		dev_err(dev, "Unable to power device:%d\n", ret);
 		return ret;
 	}
-- 
2.27.0



