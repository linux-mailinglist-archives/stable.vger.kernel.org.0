Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DFB300BA9
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbhAVSnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbhAVOWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB8223B42;
        Fri, 22 Jan 2021 14:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324941;
        bh=XpBnyEUptyfE2ExswyYaLSI3gqyrWtLEBZ9yTV9nTWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJZecCBn9LTUTL54TWArqjk5+HDiKjRxpqCerVNXsjQmLnemppZQix5IjojWSqkW/
         W/O4mNhnoPE//6LyIN4RqG+OuF6XWtpbSi1S5+qjgDj+J1M/72cVKho5VSckCnYIqZ
         ZfzUKt7uXuVcAL8NaSuYm0NUj00kdLtwcsWn+mL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 13/22] rxrpc: Call state should be read with READ_ONCE() under some circumstances
Date:   Fri, 22 Jan 2021 15:12:31 +0100
Message-Id: <20210122135732.441893605@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baptiste Lepers <baptiste.lepers@gmail.com>

[ Upstream commit a95d25dd7b94a5ba18246da09b4218f132fed60e ]

The call state may be changed at any time by the data-ready routine in
response to received packets, so if the call state is to be read and acted
upon several times in a function, READ_ONCE() must be used unless the call
state lock is held.

As it happens, we used READ_ONCE() to read the state a few lines above the
unmarked read in rxrpc_input_data(), so use that value rather than
re-reading it.

Fixes: a158bdd3247b ("rxrpc: Fix call timeouts")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/161046715522.2450566.488819910256264150.stgit@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -446,7 +446,7 @@ static void rxrpc_input_data(struct rxrp
 	if (state >= RXRPC_CALL_COMPLETE)
 		return;
 
-	if (call->state == RXRPC_CALL_SERVER_RECV_REQUEST) {
+	if (state == RXRPC_CALL_SERVER_RECV_REQUEST) {
 		unsigned long timo = READ_ONCE(call->next_req_timo);
 		unsigned long now, expect_req_by;
 


