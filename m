Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12B14FD4F9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352193AbiDLHhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353885AbiDLHZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F677101DF;
        Tue, 12 Apr 2022 00:05:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43377B81B4E;
        Tue, 12 Apr 2022 07:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD26C385A6;
        Tue, 12 Apr 2022 07:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747106;
        bh=9vXVE7hBRTZaQD7r+RaOOhVUqQdP69FtVpG2CWo9kbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jewLxgZI/kOuNuSZCw8Sy//Y5fnbCGgGHLtNEcBBYr8R3ecPZ9GhSqsknffUyFwXX
         aIQsrdxE1f7QJYyPaWPC9qUViWppCQB/i1UiHyx0TEkcY4lMVmEpSevDkfkN4zN4BZ
         dInpNn8s0duSfLbFL/FTtBIOYCEHWwLOXCa1YStw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 205/285] SUNRPC: Handle ENOMEM in call_transmit_status()
Date:   Tue, 12 Apr 2022 08:31:02 +0200
Message-Id: <20220412062949.576620725@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d3c15033b240767d0287f1c4a529cbbe2d5ded8a ]

Both call_transmit() and call_bc_transmit() can now return ENOMEM, so
let's make sure that we handle the errors gracefully.

Fixes: 0472e4766049 ("SUNRPC: Convert socket page send code to use iov_iter()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index b36d235d2d6d..bf1fd6caaf92 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2197,6 +2197,7 @@ call_transmit_status(struct rpc_task *task)
 		 * socket just returned a connection error,
 		 * then hold onto the transport lock.
 		 */
+	case -ENOMEM:
 	case -ENOBUFS:
 		rpc_delay(task, HZ>>2);
 		fallthrough;
@@ -2280,6 +2281,7 @@ call_bc_transmit_status(struct rpc_task *task)
 	case -ENOTCONN:
 	case -EPIPE:
 		break;
+	case -ENOMEM:
 	case -ENOBUFS:
 		rpc_delay(task, HZ>>2);
 		fallthrough;
-- 
2.35.1



