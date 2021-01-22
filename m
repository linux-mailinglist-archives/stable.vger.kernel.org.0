Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB01300B90
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbhAVSlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:41:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbhAVOVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5007A23A9F;
        Fri, 22 Jan 2021 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324886;
        bh=JUbV4WDWYeuFOG5RUQMedKAYuLqR5xDajD+MGa6Gdsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLkV0r+SRH4ZdhBxzbDKpSKmTwEvnGS/do83XVKgzLN0WPFg9YRE+vi3u83pR2Qfv
         6WfCTvxl3wt52f52UDHmy6RzJc7MRUebBxhf5kBi9n4/JsWr9hCffD1S5ihTPopGKc
         SK1euS/Yoh/wgXWYqVNkx5imI0/eMfVYejm2tV10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 44/50] rxrpc: Fix handling of an unsupported token type in rxrpc_read()
Date:   Fri, 22 Jan 2021 15:12:25 +0100
Message-Id: <20210122135736.979280475@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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
 net/rxrpc/key.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -1112,7 +1112,7 @@ static long rxrpc_read(const struct key
 		default: /* we have a ticket we can't encode */
 			pr_err("Unsupported key token type (%u)\n",
 			       token->security_index);
-			continue;
+			return -ENOPKG;
 		}
 
 		_debug("token[%u]: toksize=%u", ntoks, toksize);
@@ -1227,7 +1227,9 @@ static long rxrpc_read(const struct key
 			break;
 
 		default:
-			break;
+			pr_err("Unsupported key token type (%u)\n",
+			       token->security_index);
+			return -ENOPKG;
 		}
 
 		ASSERTCMP((unsigned long)xdr - (unsigned long)oldxdr, ==,


