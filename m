Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C715D5C02F6
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiIUP5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbiIUP4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:56:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1A89F8DC;
        Wed, 21 Sep 2022 08:51:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 555A9B830BE;
        Wed, 21 Sep 2022 15:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97098C433B5;
        Wed, 21 Sep 2022 15:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775426;
        bh=VFkvvxFCc18O/kmq1Jd3OItHZjzJyz5jqz9K3qY0pVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnYaTL4Eplhn3BBhykdATptGi4DHYkGOvDm3xiJSX7O7g6Xa3JcrG07xNSyor3wQG
         t8nkxisOgFSJzQJ2PlIXNAc0xZlvGOhBzHckjmypk3oK99RaJTiaG+Xm6N6Dzts3IJ
         IpLGlxHBfqSSoXJCcVkRYkheeeCRKScq1pzGzlgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/45] rxrpc: Fix local destruction being repeated
Date:   Wed, 21 Sep 2022 17:46:21 +0200
Message-Id: <20220921153647.920686447@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
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

[ Upstream commit d3d863036d688313f8d566b87acd7d99daf82749 ]

If the local processor work item for the rxrpc local endpoint gets requeued
by an event (such as an incoming packet) between it getting scheduled for
destruction and the UDP socket being closed, the rxrpc_local_destroyer()
function can get run twice.  The second time it can hang because it can end
up waiting for cleanup events that will never happen.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/local_object.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index ef43fe8bdd2f..1d15940f61d7 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -406,6 +406,9 @@ static void rxrpc_local_processor(struct work_struct *work)
 		container_of(work, struct rxrpc_local, processor);
 	bool again;
 
+	if (local->dead)
+		return;
+
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
 			  atomic_read(&local->usage), NULL);
 
-- 
2.35.1



