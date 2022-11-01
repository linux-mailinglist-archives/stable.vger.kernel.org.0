Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5279F61488E
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiKAL2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiKAL15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:27:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B943192A9;
        Tue,  1 Nov 2022 04:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 191FDB81C9C;
        Tue,  1 Nov 2022 11:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933BAC433C1;
        Tue,  1 Nov 2022 11:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302061;
        bh=0EKF43HEq8O5ijotbSuBiQhZ8XlCp3GAnSXEbb9WZ0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mk1oxr1jvoArgL+qtJqK5pPn1ipHPWdEKvOCsJkQ/fRYVtnM947I8A0/up3EY8i+l
         eTyle6apXx70p13gGMbrcRQgWD2ZZ2iGPdcf8SBO4w3FjHBhg/bUEaTDbHNqJ97w5P
         JAt//WHdzxgawCY27YwA66+5/Sdg73NbkOLMUkDcooii/mOg8vSLhnjU3RbixygIah
         99oRdIAL2HdhzjGTTTnqjuZsTrYqxF8n0rTDy41wiT76ezgZesRBzN7ueNTjkqGTLJ
         BCpnCUxfyoGaXkh8jvfBphlwcTSKNbbOWaT5EuU0XZRSqepvKOh0M/z/RUaJW80abK
         ytY3hG4Mh1NNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bleung@chromium.org,
        groeck@chromium.org, ajye_huang@compal.corp-partner.google.com,
        zhuohao@chromium.org, hellojacky0226@hotmail.com,
        scott_chao@wistron.corp-partner.google.com,
        linux-media@vger.kernel.org, chrome-platform@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 07/34] media: cros-ec-cec: limit msg.len to CEC_MAX_MSG_SIZE
Date:   Tue,  1 Nov 2022 07:26:59 -0400
Message-Id: <20221101112726.799368-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 2dc73b48665411a08c4e5f0f823dea8510761603 ]

I expect that the hardware will have limited this to 16, but just in
case it hasn't, check for this corner case.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/cros-ec/cros-ec-cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
index 3b583ed4da9d..e5ebaa58be45 100644
--- a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
+++ b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
@@ -44,6 +44,8 @@ static void handle_cec_message(struct cros_ec_cec *cros_ec_cec)
 	uint8_t *cec_message = cros_ec->event_data.data.cec_message;
 	unsigned int len = cros_ec->event_size;
 
+	if (len > CEC_MAX_MSG_SIZE)
+		len = CEC_MAX_MSG_SIZE;
 	cros_ec_cec->rx_msg.len = len;
 	memcpy(cros_ec_cec->rx_msg.msg, cec_message, len);
 
-- 
2.35.1

