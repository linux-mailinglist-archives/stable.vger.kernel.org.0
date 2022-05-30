Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E8E53830E
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240650AbiE3O3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241594AbiE3O0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:26:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3632AB0DB;
        Mon, 30 May 2022 06:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79B6ECE106B;
        Mon, 30 May 2022 13:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B58C3411E;
        Mon, 30 May 2022 13:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918596;
        bh=mfzOGPGDFMwBe8JQHvgneMIcB+OQk61Uas1dXZKCVjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lrgl0Z/XybRsHS/zZ5jcjund71qMAZ9GTi5JQBTM18sv/Q/OwENwrvdYfSGvRIBgY
         FQRLkGwVD5r3wjVB8Z4LL8W/RJJuiKDm1ylhuAhFgnZglGpfYyDT0I+02fkuFatDq2
         U5/rCdskx+0VnlMbtiWjqQA9y90hAzdJ+OqjSQv9RIxVSJMAcTwhtOLxbe17tk8vK2
         y3h40Dk3YzItxoHVh8DISxHvgrLHOCiPsvBJWYWIlwmC7I4214grPn/LmC9ioWe6/a
         dkTFuDAxJEORxAIJh/HwW3nTmVhRMD96fgfvrChxwKrsvzYrVljrp27aXczeAHoF5q
         Zo51L8s4PNQUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Weiss <luca.weiss@fairphone.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/38] media: venus: hfi: avoid null dereference in deinit
Date:   Mon, 30 May 2022 09:48:58 -0400
Message-Id: <20220530134924.1936816-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134924.1936816-1-sashal@kernel.org>
References: <20220530134924.1936816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 86594f6af867b5165d2ba7b5a71fae3a5961e56c ]

If venus_probe fails at pm_runtime_put_sync the error handling first
calls hfi_destroy and afterwards hfi_core_deinit. As hfi_destroy sets
core->ops to NULL, hfi_core_deinit cannot call the core_deinit function
anymore.

Avoid this null pointer derefence by skipping the call when necessary.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 24207829982f..8a99e2d8274a 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -113,6 +113,9 @@ int hfi_core_deinit(struct venus_core *core, bool blocking)
 		mutex_lock(&core->lock);
 	}
 
+	if (!core->ops)
+		goto unlock;
+
 	ret = core->ops->core_deinit(core);
 
 	if (!ret)
-- 
2.35.1

