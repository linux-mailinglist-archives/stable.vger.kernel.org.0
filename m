Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A217354027
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240677AbhDEJQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240645AbhDEJQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D5AD61399;
        Mon,  5 Apr 2021 09:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614157;
        bh=1fuiurojnUPQsjxxcxSuO+G0KIY/p02YA7hhZUTF0nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUi8kmVrcVDk3NI2jXPDHamdXydmZwIuPqpv/HbgGMCFzc8qSFYGQqwJre8GCbbta
         7xhvfSfVcOg+OlE9bTxtsYse1hWAICYGCIro8QfgKZjaJQsiHtdq5+pz4qdDy/tcvk
         SfuLBbQWbmzfx2mKtVNwMooGQOjj7mtBpLdM+1qE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Marek <jonathan@marek.ca>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.11 103/152] pinctrl: qcom: lpass lpi: use default pullup/strength values
Date:   Mon,  5 Apr 2021 10:54:12 +0200
Message-Id: <20210405085037.587810700@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

commit 2a9be38099e338f597c14d3cb851849b01db05f6 upstream.

If these fields are not set in dts, the driver will use these variables
uninitialized to set the fields. Not only will it set garbage values for
these fields, but it can overflow into other fields and break those.

In the current sm8250 dts, the dmic01 entries do not have a pullup setting,
and might not work without this change.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 6e261d1090d6 ("pinctrl: qcom: Add sm8250 lpass lpi pinctrl driver")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210304194816.3843-1-jonathan@marek.ca
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
+++ b/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
@@ -392,7 +392,7 @@ static int lpi_config_set(struct pinctrl
 			  unsigned long *configs, unsigned int nconfs)
 {
 	struct lpi_pinctrl *pctrl = dev_get_drvdata(pctldev->dev);
-	unsigned int param, arg, pullup, strength;
+	unsigned int param, arg, pullup = LPI_GPIO_BIAS_DISABLE, strength = 2;
 	bool value, output_enabled = false;
 	const struct lpi_pingroup *g;
 	unsigned long sval;


