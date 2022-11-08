Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18619621320
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbiKHNrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbiKHNq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:46:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFEB5F846
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:46:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BD5FB81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C78C433D6;
        Tue,  8 Nov 2022 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915213;
        bh=UCC8lyDEoZajJOcyBilNX3fzGYsshdVzFMcs3OEstNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQaMiBTag2EZ+C+56Hx6e2Ma7v5fFqv8uZafYxqvTiFHWltt4GNfNMaaigEel6Qny
         uj6DhiWoPFV7aW3hIvmsPqhhzaxsjbW2gXnmDR1qIlL11BAe4LVKJ9stva2mw55v/f
         ZkOlYWE4HVMV5xMrzAns7aj4lQOUesiToUT+EilY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/48] media: cros-ec-cec: limit msg.len to CEC_MAX_MSG_SIZE
Date:   Tue,  8 Nov 2022 14:39:11 +0100
Message-Id: <20221108133330.444367239@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
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

[ Upstream commit 2dc73b48665411a08c4e5f0f823dea8510761603 ]

I expect that the hardware will have limited this to 16, but just in
case it hasn't, check for this corner case.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/cros-ec-cec/cros-ec-cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/cros-ec-cec/cros-ec-cec.c b/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
index 7bc4d8a9af28..1f35770245d1 100644
--- a/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
+++ b/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
@@ -44,6 +44,8 @@ static void handle_cec_message(struct cros_ec_cec *cros_ec_cec)
 	uint8_t *cec_message = cros_ec->event_data.data.cec_message;
 	unsigned int len = cros_ec->event_size;
 
+	if (len > CEC_MAX_MSG_SIZE)
+		len = CEC_MAX_MSG_SIZE;
 	cros_ec_cec->rx_msg.len = len;
 	memcpy(cros_ec_cec->rx_msg.msg, cec_message, len);
 
-- 
2.35.1



