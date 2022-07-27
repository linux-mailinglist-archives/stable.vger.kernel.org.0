Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AC7582E7E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiG0RNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbiG0RMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:12:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF87B7539E;
        Wed, 27 Jul 2022 09:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 928EEB821DB;
        Wed, 27 Jul 2022 16:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B619BC433D7;
        Wed, 27 Jul 2022 16:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940113;
        bh=scrNFbmgOZf8SLm+fKyCrg0Y7HaLGnqW0jwrPYjZklk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWxE5rsi440CrrcFtB3v6khL0uXN52UtCTywtF2esDXa3vp1vhW1z1CjiGU41cv0s
         t9bbkPsVegM67o2hUO7bZ56CBMLFmXHQcgQ8kt3killfSu3At8PKKvu3RizntFVpDE
         EMEtlfFakTSxkqFTpwve6T4wgB7Tt448E4WIaARY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/201] net: skb_drop_reason: add document for drop reasons
Date:   Wed, 27 Jul 2022 18:09:42 +0200
Message-Id: <20220727161030.183977949@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit 88590b369354092183bcba04e2368010c462557f ]

Add document for following existing drop reasons:

SKB_DROP_REASON_NOT_SPECIFIED
SKB_DROP_REASON_NO_SOCKET
SKB_DROP_REASON_PKT_TOO_SMALL
SKB_DROP_REASON_TCP_CSUM
SKB_DROP_REASON_SOCKET_FILTER
SKB_DROP_REASON_UDP_CSUM

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f92f05c9d72d..f329c617eb96 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -311,12 +311,12 @@ struct sk_buff;
  * used to translate the reason to string.
  */
 enum skb_drop_reason {
-	SKB_DROP_REASON_NOT_SPECIFIED,
-	SKB_DROP_REASON_NO_SOCKET,
-	SKB_DROP_REASON_PKT_TOO_SMALL,
-	SKB_DROP_REASON_TCP_CSUM,
-	SKB_DROP_REASON_SOCKET_FILTER,
-	SKB_DROP_REASON_UDP_CSUM,
+	SKB_DROP_REASON_NOT_SPECIFIED,	/* drop reason is not specified */
+	SKB_DROP_REASON_NO_SOCKET,	/* socket not found */
+	SKB_DROP_REASON_PKT_TOO_SMALL,	/* packet size is too small */
+	SKB_DROP_REASON_TCP_CSUM,	/* TCP checksum error */
+	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
+	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
 	SKB_DROP_REASON_MAX,
 };
 
-- 
2.35.1



