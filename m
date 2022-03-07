Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20424CF6D1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbiCGJmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240992AbiCGJlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892926582B;
        Mon,  7 Mar 2022 01:39:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9EBBB810CC;
        Mon,  7 Mar 2022 09:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E7BC340E9;
        Mon,  7 Mar 2022 09:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645938;
        bh=i57U6srCUY6x6p72vBcDx7z8RlmPz/tzafs1rL/YY9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+WpiIcW57nBgieETTuRAzzyUNcUStMCBTb7EIjC+rMsQsVVAiuw9Vfn1OM5yeltg
         EAa20eX8oAEZSNnEarurhu55d/5fTch/jZWc0xwVFFNMQNbBxPunVB7AOyn1RU8h7+
         Yvacny5bKFRAW3Y9kMuYa5+SjVliuSISrMyIctBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/262] SUNRPC: Fix sockaddr handling in svcsock_accept_class trace points
Date:   Mon,  7 Mar 2022 10:17:05 +0100
Message-Id: <20220307091704.773768226@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 16720861675393a35974532b3c837d9fd7bfe08c ]

Avoid potentially hazardous memory copying and the needless use of
"%pIS" -- in the kernel, an RPC service listener is always bound to
ANYADDR. Having the network namespace is helpful when recording
errors, though.

Fixes: a0469f46faab ("SUNRPC: Replace dprintk call sites in TCP state change callouts")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 1213c078dcca5..7c48613c18304 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -2112,17 +2112,17 @@ DECLARE_EVENT_CLASS(svcsock_accept_class,
 	TP_STRUCT__entry(
 		__field(long, status)
 		__string(service, service)
-		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+		__field(unsigned int, netns_ino)
 	),
 
 	TP_fast_assign(
 		__entry->status = status;
 		__assign_str(service, service);
-		memcpy(__entry->addr, &xprt->xpt_local, sizeof(__entry->addr));
+		__entry->netns_ino = xprt->xpt_net->ns.inum;
 	),
 
-	TP_printk("listener=%pISpc service=%s status=%ld",
-		__entry->addr, __get_str(service), __entry->status
+	TP_printk("addr=listener service=%s status=%ld",
+		__get_str(service), __entry->status
 	)
 );
 
-- 
2.34.1



