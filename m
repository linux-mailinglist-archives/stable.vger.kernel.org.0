Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EA5658426
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbiL1QzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbiL1Qyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:54:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ADD1EACB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:49:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6EEDB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DE7C433EF;
        Wed, 28 Dec 2022 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246159;
        bh=+2w6wsYm1BRXB2I+p+whmvk5bYN+HVXCCZCWA0xuGv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kxncbcm+Z+eCqShUuUKHVlDbkKAhDHh2jPy0uj0EYzBtbwMzEmd/KzgWCdkUHeFRc
         pOttfZMDeZwiujZ+nw7/IUJcmMDbDt7shC3htGid4NsN18+wL811v239PlbQsouNLN
         3jMKyCaR0ydpVxWWARUE1/4nno1+9+h297r6J+W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1022/1073] Input: iqs7222 - avoid sending empty SYN_REPORT events
Date:   Wed, 28 Dec 2022 15:43:30 +0100
Message-Id: <20221228144355.949709076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 514c13b1faed74e9bc19061b6d7c78d53a3402ba ]

Add a check to prevent sending undefined events, which ultimately
map to SYN_REPORT.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220908131548.48120-7-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs7222.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index 8fd665874a24..0b2bf471b3a0 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -2314,6 +2314,9 @@ static int iqs7222_report(struct iqs7222_private *iqs7222)
 			int k = 2 + j * (num_chan > 16 ? 2 : 1);
 			u16 state = le16_to_cpu(status[k + i / 16]);
 
+			if (!iqs7222->kp_type[i][j])
+				continue;
+
 			input_event(iqs7222->keypad,
 				    iqs7222->kp_type[i][j],
 				    iqs7222->kp_code[i][j],
-- 
2.35.1



