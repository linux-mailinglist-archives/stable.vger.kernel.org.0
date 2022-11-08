Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C886213DB
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiKHNym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbiKHNyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:54:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E18EA1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:54:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AC13B81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853F9C433D7;
        Tue,  8 Nov 2022 13:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915678;
        bh=7PwGxb7r347LjxhB4O5/10fNOWAkErVJVpC0gzC3rw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gk7OD/sIy15eVKP7rd+XLRJtvfYH44xe5jHtQwRmsHADaSXH1fOpqubOPafcX9LV6
         NoOhe6Wms0c/FYvYre4J1CJJvHP4AiF6QjpClmvu/iBWQzy36Rn5s3kn1vrjXaQp0G
         e73w5E/oP4pz2kzCbEFwRLXlIhWyEoUz7++N6GHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/118] media: s5p_cec: limit msg.len to CEC_MAX_MSG_SIZE
Date:   Tue,  8 Nov 2022 14:38:58 +0100
Message-Id: <20221108133343.325441732@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



