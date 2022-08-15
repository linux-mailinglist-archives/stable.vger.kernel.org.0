Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F309594D94
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344870AbiHPBEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348546AbiHPBCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 21:02:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEAEB9FA7;
        Mon, 15 Aug 2022 13:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26A31B811AB;
        Mon, 15 Aug 2022 20:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FC4C433C1;
        Mon, 15 Aug 2022 20:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596650;
        bh=HPQ3uqaqAfVf4S6PuzQ/p3Xy42uW6oBrQE6d2Cc8B6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbShbruym06Wk/ce8Td1N2yLBewE+rD5hhY5IAff2thIaIPh/Jbi9OQAYJzJUeFlU
         XL+7ZXR2SdaevIiyu5qPYZascLN+1Tpcr8mVM4lRvRQI9FUvfg/Bdf6kqOIHmzIy8Y
         iaZFszlHUqCNHdO7q4Lz6SX0fT8x9nNcNNYT+CUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 1146/1157] mptcp: refine memory scheduling
Date:   Mon, 15 Aug 2022 20:08:22 +0200
Message-Id: <20220815180526.349759462@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 69d93daec026cdda98e29e8edb12534bfa5b1a9b upstream.

Similar to commit 7c80b038d23e ("net: fix sk_wmem_schedule() and
sk_rmem_schedule() errors"), let the MPTCP receive path schedule
exactly the required amount of memory.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -323,9 +323,10 @@ static bool mptcp_rmem_schedule(struct s
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	int amt, amount;
 
-	if (size < msk->rmem_fwd_alloc)
+	if (size <= msk->rmem_fwd_alloc)
 		return true;
 
+	size -= msk->rmem_fwd_alloc;
 	amt = sk_mem_pages(size);
 	amount = amt << SK_MEM_QUANTUM_SHIFT;
 	msk->rmem_fwd_alloc += amount;


