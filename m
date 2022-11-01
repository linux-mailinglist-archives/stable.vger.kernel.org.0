Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B484D6148F6
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKALbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiKALbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:31:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4F819026;
        Tue,  1 Nov 2022 04:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AFBBECE1B32;
        Tue,  1 Nov 2022 11:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3D6C433C1;
        Tue,  1 Nov 2022 11:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302168;
        bh=7PwGxb7r347LjxhB4O5/10fNOWAkErVJVpC0gzC3rw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRaGlmNt81K5CjqDJX04w5soeTpVrPheIvf3ehoJcA1FNCJ1hHaJwGhV8mnGe46EW
         N4DByIxJB3Ey98ub8NBy5SfBBG+th3tSfyFWpN/Iz0dyzL2+uVE7+ai3ISSPAQKw6H
         Yxyo0E00dCWLhT8U+DrMPAIxsGLcQgMmggDC0U/+B4K1fSvcxmhOkX1J3nTRrj3pYt
         49IZWb9nktnWHFtnfp5a0eFRPxKm4jgqqYqGVCbl83lsPldwQ4NlKroFhPrOjOyhoe
         gT44m3ejH5jrh9qIitZC15tr/ATMXYJ1zJOaX6Xp5xWSCbwX9w60P60ja/mkSUQGE4
         ycNYA3cAgYPqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, m.szyprowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/19] media: s5p_cec: limit msg.len to CEC_MAX_MSG_SIZE
Date:   Tue,  1 Nov 2022 07:29:05 -0400
Message-Id: <20221101112919.799868-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112919.799868-1-sashal@kernel.org>
References: <20221101112919.799868-1-sashal@kernel.org>
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

[ Upstream commit 93f65ce036863893c164ca410938e0968964b26c ]

I expect that the hardware will have limited this to 16, but just in
case it hasn't, check for this corner case.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/s5p/s5p_cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/cec/platform/s5p/s5p_cec.c b/drivers/media/cec/platform/s5p/s5p_cec.c
index 028a09a7531e..102f1af01000 100644
--- a/drivers/media/cec/platform/s5p/s5p_cec.c
+++ b/drivers/media/cec/platform/s5p/s5p_cec.c
@@ -115,6 +115,8 @@ static irqreturn_t s5p_cec_irq_handler(int irq, void *priv)
 				dev_dbg(cec->dev, "Buffer overrun (worker did not process previous message)\n");
 			cec->rx = STATE_BUSY;
 			cec->msg.len = status >> 24;
+			if (cec->msg.len > CEC_MAX_MSG_SIZE)
+				cec->msg.len = CEC_MAX_MSG_SIZE;
 			cec->msg.rx_status = CEC_RX_STATUS_OK;
 			s5p_cec_get_rx_buf(cec, cec->msg.len,
 					cec->msg.msg);
-- 
2.35.1

