Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371E65A4B5F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiH2MRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiH2MRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:17:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FAF5C375;
        Mon, 29 Aug 2022 05:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25E5CB80EE6;
        Mon, 29 Aug 2022 11:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9179CC433D6;
        Mon, 29 Aug 2022 11:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771784;
        bh=OVfiCIC+cE2nB3VzGWdBCd9pK7dLD8IL+nIk9aRbV4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFD9JjDUofDIEoRxzA8EHSQsmDAOdacIKCA1+2mzvxq7/pP+wTwGK+pm3e85KAfKA
         tZVk1oUTjklvoOOuGSPvIkq3b26OUcZMkun1ZIS4jjX1xZQ3FFHM2/9FEaEMsHmr8J
         r88ArUBFNmkOornH0B78YqnX07yu+xbF/6KqnNhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 079/158] net: Fix a data-race around gro_normal_batch.
Date:   Mon, 29 Aug 2022 12:58:49 +0200
Message-Id: <20220829105812.358908232@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 8db24af3f02ebdbf302196006ebb270c4c3a2706 ]

While reading gro_normal_batch, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/gro.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index 867656b0739c0..24003dea8fa4d 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -439,7 +439,7 @@ static inline void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb,
 {
 	list_add_tail(&skb->list, &napi->rx_list);
 	napi->rx_count += segs;
-	if (napi->rx_count >= gro_normal_batch)
+	if (napi->rx_count >= READ_ONCE(gro_normal_batch))
 		gro_normal_list(napi);
 }
 
-- 
2.35.1



