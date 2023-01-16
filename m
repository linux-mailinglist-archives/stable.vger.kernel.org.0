Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59DD66CB24
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbjAPRLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbjAPRKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:10:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95AC2B295
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:50:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5540F61050
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690F7C433D2;
        Mon, 16 Jan 2023 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887852;
        bh=yABKi0f5dDfM0CZGDAx9wL8heeI6qgjxf9Iu0GzQMBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luxPpZHub0Y9VbjMi3CdFpfG1S4xYqW6BeqTDod6Ikoy1iCEJRGA0mKIVgpV8kkYC
         +dEAQtbH322QyTI6D66YmrgHNOSbDP/taQxcbXP9t89WrrHf/nRD5PVBrm0xIc5K9W
         OheYTyYowyoeUgy6Y+/QCgSg38GaHs9QOzAlyM4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 307/521] rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
Date:   Mon, 16 Jan 2023 16:49:29 +0100
Message-Id: <20230116154900.851876888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4feb2c44629e6f9b459b41a5a60491069d346a95 ]

One of the error paths in rxrpc_do_sendmsg() doesn't unlock the call mutex
before returning.  Fix it to do this.

Note that this still doesn't get rid of the checker warning:

   ../net/rxrpc/sendmsg.c:617:5: warning: context imbalance in 'rxrpc_do_sendmsg' - wrong count at exit

I think the interplay between the socket lock and the call's user_mutex may
be too complicated for checker to analyse, especially as
rxrpc_new_client_call_for_sendmsg(), which it calls, returns with the
call's user_mutex if successful but unconditionally drops the socket lock.

Fixes: e754eba685aa ("rxrpc: Provide a cmsg to specify the amount of Tx data for a call")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 0220a2935002..a7a09eb04d93 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -689,7 +689,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 			if (call->tx_total_len != -1 ||
 			    call->tx_pending ||
 			    call->tx_top != 0)
-				goto error_put;
+				goto out_put_unlock;
 			call->tx_total_len = p.call.tx_total_len;
 		}
 	}
-- 
2.35.1



