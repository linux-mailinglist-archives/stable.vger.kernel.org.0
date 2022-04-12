Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B434FD584
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353459AbiDLHdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353626AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8303343AF3;
        Tue, 12 Apr 2022 00:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35E22B81B4E;
        Tue, 12 Apr 2022 07:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81ABC385A1;
        Tue, 12 Apr 2022 07:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746935;
        bh=RJjn3tcoxr5M4Sp8qwu6YBWZMc7sAaScNhEJPC1mWFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1o18ZuRSoqH+o2zNa38wL/Mocj9aG+ByGQ2/E4PaMI/KLwUGep+hy1aAhc5LVqWAu
         mohrsm95K4zucW5ty76rXbYD0pzdJIgtCw4zBnlU6ONJVYuS6zONvI1TmTIOVNzyF6
         f55ytlVMMUQnYDRFHaTp8Q51QW8exRDl9m2bWsck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 183/285] sctp: count singleton chunks in assoc user stats
Date:   Tue, 12 Apr 2022 08:30:40 +0200
Message-Id: <20220412062948.946719395@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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



