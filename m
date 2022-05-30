Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7DA537F33
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbiE3OKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238227AbiE3OER (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:04:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111A3994CC;
        Mon, 30 May 2022 06:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB5BFB80DB3;
        Mon, 30 May 2022 13:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7446DC3411C;
        Mon, 30 May 2022 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918013;
        bh=84kLkUFrITbye63UGnUau2HQC5kDYnmHprBb0Z2XKPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaVLbqwz+ih3thOKVyFlQvBKiMNYDx8oiRNrTQQ1IeVc1NLOu35P12Bx1E0jDfSPa
         y8VAaJ1QpKyG/OQ45aqxN4+eTvS7WN+jHwaZw+AHYDLwnIiYp2KVRIIry5wbWa+Yt1
         Knens3ZrGWmdBxTwXgwVkJbZb8vdbZarQ0JkGQ6Ta8vSYaEwMwa6ByGZd6LaV6jQmQ
         WDCWVnI8ImAH9AyI++WO6rLinQRRW7oNsjvW+ZT5YjIruB9j5ZMU5H+9rAAizO0mFD
         Y9/3Il8nefEl3W+7ZiHFHLlawEEA0OedNp4gXYdG0s9vcUZtY5OMxeQv5kC/SCUcIn
         LL9WB+QvNAtYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Weiss <luca.weiss@fairphone.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 032/109] media: venus: hfi: avoid null dereference in deinit
Date:   Mon, 30 May 2022 09:37:08 -0400
Message-Id: <20220530133825.1933431-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
index 0f2482367e06..9bc4becdf638 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -104,6 +104,9 @@ int hfi_core_deinit(struct venus_core *core, bool blocking)
 		mutex_lock(&core->lock);
 	}
 
+	if (!core->ops)
+		goto unlock;
+
 	ret = core->ops->core_deinit(core);
 
 	if (!ret)
-- 
2.35.1

