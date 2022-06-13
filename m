Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EC5548741
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352953AbiFMMZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357306AbiFMMYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:24:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A315431DE2;
        Mon, 13 Jun 2022 04:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F2E4CE1179;
        Mon, 13 Jun 2022 11:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1418DC3411C;
        Mon, 13 Jun 2022 11:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118328;
        bh=1okDpxG+2HAeH3YlR9vj5KO6UWz/SMYp93/ULZFDgus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPIa7Mp9KUUAF3mHen2tY7J9Ko6nQe6JcL9vNxvYQbj5agAPl3Zzg13epyxMUiu/x
         woC6/mNAwiWCeFwZIOGSJUZNJsoRbeJvhzzYQx5EzkzRn/BMqo08ilgQr7ja7LIKqi
         Ta87Eb+RC8UHbT7PTwXeEqVo4Wmn8xozbWUxWQHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Li Jun <jun.li@nxp.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/172] extcon: ptn5150: Add queue work sync before driver release
Date:   Mon, 13 Jun 2022 12:09:48 +0200
Message-Id: <20220613094857.166749117@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

[ Upstream commit 782cd939cbe0f569197cd1c9b0477ee213167f04 ]

Add device managed action to sync pending queue work, otherwise
the queued work may run after the work is destroyed.

Fixes: 4ed754de2d66 ("extcon: Add support for ptn5150 extcon driver")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-ptn5150.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/extcon/extcon-ptn5150.c b/drivers/extcon/extcon-ptn5150.c
index 5b9a3cf8df26..2a7874108df8 100644
--- a/drivers/extcon/extcon-ptn5150.c
+++ b/drivers/extcon/extcon-ptn5150.c
@@ -194,6 +194,13 @@ static int ptn5150_init_dev_type(struct ptn5150_info *info)
 	return 0;
 }
 
+static void ptn5150_work_sync_and_put(void *data)
+{
+	struct ptn5150_info *info = data;
+
+	cancel_work_sync(&info->irq_work);
+}
+
 static int ptn5150_i2c_probe(struct i2c_client *i2c)
 {
 	struct device *dev = &i2c->dev;
@@ -284,6 +291,10 @@ static int ptn5150_i2c_probe(struct i2c_client *i2c)
 	if (ret)
 		return -EINVAL;
 
+	ret = devm_add_action_or_reset(dev, ptn5150_work_sync_and_put, info);
+	if (ret)
+		return ret;
+
 	/*
 	 * Update current extcon state if for example OTG connection was there
 	 * before the probe
-- 
2.35.1



