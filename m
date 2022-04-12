Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC37E4FD48B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355678AbiDLH26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351455AbiDLHL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:11:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA6D4AE1D;
        Mon, 11 Apr 2022 23:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C58F9B81B49;
        Tue, 12 Apr 2022 06:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F509C385B4;
        Tue, 12 Apr 2022 06:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746204;
        bh=PsayhSUI0r6qRAA9FthWV1Nd/j1tkkpYnIXQ3HaXNkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ApPXLIwK6A79O8C7UfXQ7/g4+niX4i+JkMm84ZZb9UYdFSf5lwW8v9JNtgg1Y41hi
         kXZ9Z//W9cma/7btZvv4TZ06fHsfoB28nTY+YQ9fUStsuTTkUi1VrTR5iE4b2Xn0Pl
         95mLSiit4WlCx/kDEah30LebZRcFkkkLRSi6GOik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/277] SUNRPC: Handle ENOMEM in call_transmit_status()
Date:   Tue, 12 Apr 2022 08:30:02 +0200
Message-Id: <20220412062947.797543619@linuxfoundation.org>
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
index 5d5627bf3b18..9a183c254c84 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2202,6 +2202,7 @@ call_transmit_status(struct rpc_task *task)
 		 * socket just returned a connection error,
 		 * then hold onto the transport lock.
 		 */
+	case -ENOMEM:
 	case -ENOBUFS:
 		rpc_delay(task, HZ>>2);
 		fallthrough;
@@ -2285,6 +2286,7 @@ call_bc_transmit_status(struct rpc_task *task)
 	case -ENOTCONN:
 	case -EPIPE:
 		break;
+	case -ENOMEM:
 	case -ENOBUFS:
 		rpc_delay(task, HZ>>2);
 		fallthrough;
-- 
2.35.1



