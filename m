Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E586B538316
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbiE3O35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241940AbiE3O1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:27:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE794B0A7F;
        Mon, 30 May 2022 06:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92862B80D86;
        Mon, 30 May 2022 13:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41839C3411C;
        Mon, 30 May 2022 13:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918682;
        bh=kvByzdNQK2btTZ+fpFAvasfh10IP/7TU2FF2HCwqQdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2O8JS2qvQldnXAO4rDY6AkIYQsN+NJo/itJW58Dpxo6BXrpkTI5086tT8VfGmGwi
         ui85z6urqaTgFjWSYlAe8kEiBM9gBntGYz6h8GOKu4DheazAGZSZavkn/ULz4SuI07
         94jU9FKkggMmRZcF3q00arKRsqe5hLHwJToD2u2v85AnkEfq94NNdB7AcONhJqeyt8
         xNq+AVHLpMvxoR0Ymw02F1X3kElo87rg5QPLn9/4dYgjQPpEHvA/t19ElFeJNZ0nQl
         HSvlK9BkRwSWKK8qmtbhctKca9yCm2vgBwH/LXzgczYmi4kGUtsgXzCJSK79X25k4P
         7x8Ctx6Flycew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Weiss <luca.weiss@fairphone.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/29] media: venus: hfi: avoid null dereference in deinit
Date:   Mon, 30 May 2022 09:50:37 -0400
Message-Id: <20220530135057.1937286-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530135057.1937286-1-sashal@kernel.org>
References: <20220530135057.1937286-1-sashal@kernel.org>
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
index ba29fd4d4984..7d1d3e64007c 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -117,6 +117,9 @@ int hfi_core_deinit(struct venus_core *core, bool blocking)
 		mutex_lock(&core->lock);
 	}
 
+	if (!core->ops)
+		goto unlock;
+
 	ret = core->ops->core_deinit(core);
 
 	if (!ret)
-- 
2.35.1

