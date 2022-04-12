Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246604FD464
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377262AbiDLHt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358261AbiDLHlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9FA424A3;
        Tue, 12 Apr 2022 00:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C6FB6153F;
        Tue, 12 Apr 2022 07:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4408CC385A6;
        Tue, 12 Apr 2022 07:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747860;
        bh=sB3ctKJpeWozzwijECZo6jSzehzrqz0vt3jr47udbag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfE+22lkoNrx8NTnyYffPW/G754CCwj7Ku1jjwx4TiJps231SLYkZ6S91V2y2523k
         danR6VqCweqDOagS8OsvIFLkomlRAnww8ptxmZRGrBMrZXqZXm6oy97HBhMifSjHeU
         jbg/N61RHocOixFli35vCw2662PRnW8dg8Satb54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 231/343] sctp: count singleton chunks in assoc user stats
Date:   Tue, 12 Apr 2022 08:30:49 +0200
Message-Id: <20220412062958.004460356@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index a18609f608fb..e213aaf45d67 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -914,6 +914,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 				ctx->asoc->base.sk->sk_err = -error;
 				return;
 			}
+			ctx->asoc->stats.octrlchunks++;
 			break;
 
 		case SCTP_CID_ABORT:
@@ -938,7 +939,10 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 
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



