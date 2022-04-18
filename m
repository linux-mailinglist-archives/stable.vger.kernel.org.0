Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E58505049
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiDRMXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239025AbiDRMXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:23:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAFF1FA5E;
        Mon, 18 Apr 2022 05:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6853760F01;
        Mon, 18 Apr 2022 12:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EE9C385A1;
        Mon, 18 Apr 2022 12:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284327;
        bh=CsCTfSsNjHS16QQ1DIkCgSALfrwY92Y131KIND27RZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGN8+KmQolXWpXwlROHJiGI7Y4bofTsZyB6OQgcZcnL1J/UwImWtIPs6kRo0pxR67
         xYhhUng9U9wRMyen+8Zd/GUaO3EOn68fFbHemwJjI16Uuy2EC7EhbaRiaMLjookbjU
         moMQFi7fsto7WjLT4GInjoRz77TRNWqPsc2cT+hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Chen <yiche@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 076/219] sctp: use the correct skb for security_sctp_assoc_request
Date:   Mon, 18 Apr 2022 14:10:45 +0200
Message-Id: <20220418121208.176976872@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit e2d88f9ce678cd33763826ae2f0412f181251314 ]

Yi Chen reported an unexpected sctp connection abort, and it occurred when
COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
is included in chunk->head_skb instead of chunk->skb, it failed to check
IP header version in security_sctp_assoc_request().

According to Ondrej, SELinux only looks at IP header (address and IPsec
options) and XFRM state data, and these are all included in head_skb for
SCTP HW GSO packets. So fix it by using head_skb when calling
security_sctp_assoc_request() in processing COOKIE_ECHO.

v1->v2:
  - As Ondrej noticed, chunk->head_skb should also be used for
    security_sctp_assoc_established() in sctp_sf_do_5_1E_ca().

Fixes: e215dab1c490 ("security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://lore.kernel.org/r/71becb489e51284edf0c11fc15246f4ed4cef5b6.1649337862.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7f342bc12735..52edee1322fc 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -781,7 +781,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		}
 	}
 
-	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
+	if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
 		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
@@ -932,7 +932,7 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 
 	/* Set peer label for connection. */
 	if (security_sctp_assoc_established((struct sctp_association *)asoc,
-					    chunk->skb))
+					    chunk->head_skb ?: chunk->skb))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	/* Verify that the chunk length for the COOKIE-ACK is OK.
@@ -2262,7 +2262,7 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	}
 
 	/* Update socket peer label if first association. */
-	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
+	if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
 		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
-- 
2.35.1



