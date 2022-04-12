Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA4D4FD25B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348499AbiDLHJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353103AbiDLHHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:07:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F76DF50;
        Mon, 11 Apr 2022 23:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB59661045;
        Tue, 12 Apr 2022 06:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1619C385A6;
        Tue, 12 Apr 2022 06:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746157;
        bh=RJjn3tcoxr5M4Sp8qwu6YBWZMc7sAaScNhEJPC1mWFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MG7jxhI1yYrWGsD/wbsvn0sMGJMVMLzzOyIAjm13vroGZClTuxKI3QkiSNYnNBaaH
         Q/EH/uD8V2rlsxoC0r8y6MKf3Z5Yk277mniU72zlF7EpU8l/MhSPAa55Whyf9Iae0o
         WApnb9LRAMLRNdI0Au8Nlk/1qvIQMZd2/HuXKW60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/277] sctp: count singleton chunks in assoc user stats
Date:   Tue, 12 Apr 2022 08:29:42 +0200
Message-Id: <20220412062947.217008030@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jamie Bainbridge <jamie.bainbridge@gmail.com>

[ Upstream commit e3d37210df5c41c51147a2d5d465de1a4d77be7a ]

Singleton chunks (INIT, HEARTBEAT PMTU probes, and SHUTDOWN-
COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
counter available to the assoc owner.

These are all control chunks so they should be counted as such.

Add counting of singleton chunks so they are properly accounted for.

Fixes: 196d67593439 ("sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STATS call")
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://lore.kernel.org/r/c9ba8785789880cf07923b8a5051e174442ea9ee.1649029663.git.jamie.bainbridge@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/outqueue.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index ff47091c385e..b3950963fc8f 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -911,6 +911,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 				ctx->asoc->base.sk->sk_err = -error;
 				return;
 			}
+			ctx->asoc->stats.octrlchunks++;
 			break;
 
 		case SCTP_CID_ABORT:
@@ -935,7 +936,10 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 
 		case SCTP_CID_HEARTBEAT:
 			if (chunk->pmtu_probe) {
-				sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
+				error = sctp_packet_singleton(ctx->transport,
+							      chunk, ctx->gfp);
+				if (!error)
+					ctx->asoc->stats.octrlchunks++;
 				break;
 			}
 			fallthrough;
-- 
2.35.1



