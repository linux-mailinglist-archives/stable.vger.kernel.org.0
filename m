Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0DF2E4140
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439677AbgL1OLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:11:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439512AbgL1OL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B642207A9;
        Mon, 28 Dec 2020 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164648;
        bh=J12to/b1ZegGF+C7OgBY73xF6OEWxa02Es72ZyGg+x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7DXPCQQeQrNoeOU9A17PFRB5HIatFjfDQnRQA+beIsOki3y5nvYW6EcF2F53ATQx
         j5quq61pAj+kpKHf8x2NjkJ05pQh0u8MiaFpEAlRfaQPCMFHOUFDuhOqV/IG/0gepA
         hIVD4CofpOBDC1Gdu4tPMdeTIsBITUDmUzkdBj3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.10 208/717] soundwire: qcom: Fix build failure when slimbus is module
Date:   Mon, 28 Dec 2020 13:43:26 +0100
Message-Id: <20201228125030.945804613@linuxfoundation.org>
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

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 47edc0104c61d609b0898a302267b7269d87a6af ]

Commit 5bd773242f75 ("soundwire: qcom: avoid dependency on
CONFIG_SLIMBUS") removed hard dependency on Slimbus for qcom driver but
it results in build failure when: CONFIG_SOUNDWIRE_QCOM=y
CONFIG_SLIMBUS=m

drivers/soundwire/qcom.o: In function `qcom_swrm_probe':
qcom.c:(.text+0xf44): undefined reference to `slimbus_bus'

Fix this by using IS_REACHABLE() in driver which is recommended to be
used with imply.

Fixes: 5bd773242f75 ("soundwire: qcom: avoid dependency on CONFIG_SLIMBUS")
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Link: https://lore.kernel.org/r/20201125055155.GD8403@vkoul-mobl
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index fbca4ebf63e92..6d22df01f3547 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -799,7 +799,7 @@ static int qcom_swrm_probe(struct platform_device *pdev)
 	data = of_device_get_match_data(dev);
 	ctrl->rows_index = sdw_find_row_index(data->default_rows);
 	ctrl->cols_index = sdw_find_col_index(data->default_cols);
-#if IS_ENABLED(CONFIG_SLIMBUS)
+#if IS_REACHABLE(CONFIG_SLIMBUS)
 	if (dev->parent->bus == &slimbus_bus) {
 #else
 	if (false) {
-- 
2.27.0



