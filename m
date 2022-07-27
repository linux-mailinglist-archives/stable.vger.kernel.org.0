Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE715830AC
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242752AbiG0RkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242889AbiG0Rj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:39:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA2661D7A;
        Wed, 27 Jul 2022 09:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DCD9B821BE;
        Wed, 27 Jul 2022 16:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0ECC433D6;
        Wed, 27 Jul 2022 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940670;
        bh=wQ4x2T2sHA5A7GZsTF5GyIl9+xpUVMCBVkOEG3kfipU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJEj0IDMr6eWkFotdAkLz71SIj50BdsqlCBGvfmKMPp/HQAKoyjwyhU4DZeUtkRTy
         UWOGmb40h/Wb/cWsFSA6Ey43ZoAErrSNrpOZxhIMtsQ5AK03Zu0Q1BnxbkVGF30DXW
         206EGl424Fi1Q/CuZk+Mz+N9JzSgnAEfjRdNwOdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 107/158] amt: drop unexpected multicast data
Date:   Wed, 27 Jul 2022 18:12:51 +0200
Message-Id: <20220727161025.765824123@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit e882827d5b8942a27b4d28548aa27562a3a7e94c ]

AMT gateway interface should not receive unexpected multicast data.
Multicast data message type should be received after sending an update
message, which means all establishment between gateway and relay is
finished.
So, amt_multicast_data_handler() checks amt->status.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 5c65908abd5a..4277924ab3b9 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2282,6 +2282,9 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	struct ethhdr *eth;
 	struct iphdr *iph;
 
+	if (READ_ONCE(amt->status) != AMT_STATUS_SENT_UPDATE)
+		return true;
+
 	hdr_size = sizeof(*amtmd) + sizeof(struct udphdr);
 	if (!pskb_may_pull(skb, hdr_size))
 		return true;
-- 
2.35.1



