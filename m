Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3386433AF
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiLETim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbiLETiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:38:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A557B65A0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:35:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CDA5B811E3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0E0C433C1;
        Mon,  5 Dec 2022 19:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268916;
        bh=nYxaMz/dhDEP2WkEiYUY/5yXD7vBj78uKEjWJ9+IS8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geAZxcfCqYUaKw8DUgYBUOMTw9m7OpvYumK21QhPknY6yS8e8shu/4aPGIH/3TJQX
         1NZZh/AvN8wmTF+nclypCJbURUAZEit5MwXHQlbmmM0KLKaBS0kXQ8WxpRetn2Rc7h
         p4vceyY8rfGW7ZqnX7zb1B4/bVgBWwVj68ezqLso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/120] afs: Fix fileserver probe RTT handling
Date:   Mon,  5 Dec 2022 20:09:59 +0100
Message-Id: <20221205190808.396179319@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

[ Upstream commit ca57f02295f188d6c65ec02202402979880fa6d8 ]

The fileserver probing code attempts to work out the best fileserver to
use for a volume by retrieving the RTT calculated by AF_RXRPC for the
probe call sent to each server and comparing them.  Sometimes, however,
no RTT estimate is available and rxrpc_kernel_get_srtt() returns false,
leading good fileservers to be given an RTT of UINT_MAX and thus causing
the rotation algorithm to ignore them.

Fix afs_select_fileserver() to ignore rxrpc_kernel_get_srtt()'s return
value and just take the estimated RTT it provides - which will be capped
at 1 second.

Fixes: 1d4adfaf6574 ("rxrpc: Make rxrpc_kernel_get_srtt() indicate validity")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/166965503999.3392585.13954054113218099395.stgit@warthog.procyon.org.uk/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_probe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index c0031a3ab42f..3ac5fcf98d0d 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -167,8 +167,8 @@ void afs_fileserver_probe_result(struct afs_call *call)
 			clear_bit(AFS_SERVER_FL_HAS_FS64, &server->flags);
 	}
 
-	if (rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us) &&
-	    rtt_us < server->probe.rtt) {
+	rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us);
+	if (rtt_us < server->probe.rtt) {
 		server->probe.rtt = rtt_us;
 		server->rtt = rtt_us;
 		alist->preferred = index;
-- 
2.35.1



