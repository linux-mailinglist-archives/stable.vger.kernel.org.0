Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0563300D0B
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbhAVT54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbhAVOMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:12:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AB9F23A53;
        Fri, 22 Jan 2021 14:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324587;
        bh=dnS1PoJNoDjlKvpuWMlBgsg+ck+sqNVwl/Cl//i1vJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjrBXdq8uuzdotPEMNiicvQ05v0cGpZGuR2OCi8upqrMPPDOEJN8dYceQUhSR58NT
         y1nnHbGfKa9AvRwC/LRIEPtOwHTrWDq/Y6TrkniTqdcuVdYEIVj162thybsXM5tOUF
         DU9A3ZSCol+9lgx59wkAiANSM/Og0EvZgKKanM4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 29/31] rxrpc: Fix handling of an unsupported token type in rxrpc_read()
Date:   Fri, 22 Jan 2021 15:08:43 +0100
Message-Id: <20210122135733.036622184@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit d52e419ac8b50c8bef41b398ed13528e75d7ad48 ]

Clang static analysis reports the following:

net/rxrpc/key.c:657:11: warning: Assigned value is garbage or undefined
                toksize = toksizes[tok++];
                        ^ ~~~~~~~~~~~~~~~

rxrpc_read() contains two consecutive loops.  The first loop calculates the
token sizes and stores the results in toksizes[] and the second one uses
the array.  When there is an error in identifying the token in the first
loop, the token is skipped, no change is made to the toksizes[] array.
When the same error happens in the second loop, the token is not skipped.
This will cause the toksizes[] array to be out of step and will overrun
past the calculated sizes.

Fix this by making both loops log a message and return an error in this
case.  This should only happen if a new token type is incompletely
implemented, so it should normally be impossible to trigger this.

Fixes: 9a059cd5ca7d ("rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()")
Reported-by: Tom Rix <trix@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/161046503122.2445787.16714129930607546635.stgit@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/ar-key.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -1116,7 +1116,7 @@ static long rxrpc_read(const struct key
 		default: /* we have a ticket we can't encode */
 			pr_err("Unsupported key token type (%u)\n",
 			       token->security_index);
-			continue;
+			return -ENOPKG;
 		}
 
 		_debug("token[%u]: toksize=%u", ntoks, toksize);
@@ -1236,7 +1236,9 @@ static long rxrpc_read(const struct key
 			break;
 
 		default:
-			break;
+			pr_err("Unsupported key token type (%u)\n",
+			       token->security_index);
+			return -ENOPKG;
 		}
 
 		ASSERTCMP((unsigned long)xdr - (unsigned long)oldxdr, ==,


