Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725EB4CF95F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238744AbiCGKEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbiCGKBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2329FEB;
        Mon,  7 Mar 2022 01:48:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D801F60919;
        Mon,  7 Mar 2022 09:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F17C340E9;
        Mon,  7 Mar 2022 09:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646534;
        bh=+oaw10vcsziuPG1r4+KJScrE4s0dXjQd4Jd7dTVsJvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4ZdqJOWMwIWaZ796ObWx387URZ/a4jKYjIm5fPwzcm1XEcw1zYzqGZUQwQ+7qqWA
         jHCretO/3rEiSCJB+JoCxy8Oer5pd6kC3mx/opkxrFFXcnqRLhb+WwyPfr2SuIp1nd
         bdjWmJ7EAZ2yHlkBbtKpx7AU6Wcy0VJS0D3IKeoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 012/186] tipc: fix a bit overflow in tipc_crypto_key_rcv()
Date:   Mon,  7 Mar 2022 10:17:30 +0100
Message-Id: <20220307091654.440538716@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 143de8d97d79316590475dc2a84513c63c863ddf ]

msg_data_sz return a 32bit value, but size is 16bit. This may lead to a
bit overflow.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index d293614d5fc65..b5074957e8812 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2287,7 +2287,7 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	struct tipc_crypto *tx = tipc_net(rx->net)->crypto_tx;
 	struct tipc_aead_key *skey = NULL;
 	u16 key_gen = msg_key_gen(hdr);
-	u16 size = msg_data_sz(hdr);
+	u32 size = msg_data_sz(hdr);
 	u8 *data = msg_data(hdr);
 	unsigned int keylen;
 
-- 
2.34.1



