Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D5551A933
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiEDRLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357090AbiEDRJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D34448E76;
        Wed,  4 May 2022 09:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 221C7B827A3;
        Wed,  4 May 2022 16:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFECC385A4;
        Wed,  4 May 2022 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683421;
        bh=8jV2h+eNgYTlk2g9f/ePE55tVvCnKBAeJ8Q1/2X9DBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFzO/+Vr3KGYhD/izHbCtSZqcbSq4IrfwBZ8kowAmxqYudpc7FiAON41wKygpztl3
         PxCK106Mnxr+YxYISMndcxUNyvhs+TShS1aNeSEkTXKjiCPFffBa7Tu00VTGOEAkTJ
         ClUWYqzpwkc8F7L3LufDythPXIJgPbmp++dFRA8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 105/225] tcp: md5: incorrect tcp_header_len for incoming connections
Date:   Wed,  4 May 2022 18:45:43 +0200
Message-Id: <20220504153120.037017876@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Ruggeri <fruggeri@arista.com>

[ Upstream commit 5b0b9e4c2c895227c8852488b3f09839233bba54 ]

In tcp_create_openreq_child we adjust tcp_header_len for md5 using the
remote address in newsk. But that address is still 0 in newsk at this
point, and it is only set later by the callers (tcp_v[46]_syn_recv_sock).
Use the address from the request socket instead.

Fixes: cfb6eeb4c860 ("[TCP]: MD5 Signature Option (RFC2385) support.")
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220421005026.686A45EC01F2@us226.sjc.aristanetworks.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_minisocks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 7c2d3ac2363a..492737d2b7d3 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -531,7 +531,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->tsoffset = treq->ts_off;
 #ifdef CONFIG_TCP_MD5SIG
 	newtp->md5sig_info = NULL;	/*XXX*/
-	if (newtp->af_specific->md5_lookup(sk, newsk))
+	if (treq->af_specific->req_md5_lookup(sk, req_to_sk(req)))
 		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
-- 
2.35.1



