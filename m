Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372A361488B
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiKAL15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiKAL1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:27:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D19118B0A;
        Tue,  1 Nov 2022 04:27:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFD8CB81CA2;
        Tue,  1 Nov 2022 11:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD559C4347C;
        Tue,  1 Nov 2022 11:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302057;
        bh=ZGKCWIJtIoTc/0D3wapeparC4CIoSlk/PVPHoM3wg8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwKfcDa4OUvKS8HWbYQvolvXAgY6i49hNq34t644iMdPlMVoctCNGrf8dm+cNnpUF
         s6RPchHPaTZ3+zS/pzPtP0QNSr1fsVjan8HwxZxjdcO3q9zMKYEwqMfbhW4pYGHj+5
         XholcDoEOqr8OUb+FnApJ85HnDVFtKC3gCP96q4GV93tiAdL1zifphl0+JnsH0ibQ0
         3EQDSb2c7LRqUpEq9DHBdHDaA/CslqaqATseXZ8aS/p4T/d6zlrsVh1emkzPrvaNRY
         boSZsTmaTT1LC3PC5lQWJSbymw/T6h0dM5QpVaSi14nluI2T8HjZhs2/2CPkCv0iyU
         3FPFsc19guzlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, m.szyprowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 06/34] media: s5p_cec: limit msg.len to CEC_MAX_MSG_SIZE
Date:   Tue,  1 Nov 2022 07:26:58 -0400
Message-Id: <20221101112726.799368-6-sashal@kernel.org>
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
index ce9a9d922f11..0a30e7acdc10 100644
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

