Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3EBEEC53
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388266AbfKDV4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:56:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387794AbfKDVz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:55:56 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FCA0217F4;
        Mon,  4 Nov 2019 21:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904556;
        bh=SywRDDhnNd4t2iydPehiDA1ExUDmgRVwIdgfgRq7/7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1OsZQajZwbmMz4k9QO3SdNnaPjFJy9u4Mp16lURmbcqmpv9apptjhufvUortEtld
         pehI8VbuS76gzB9yUSSDpVFpNKQhOAMPTNszkE8ah+x5HeB7dlpemnFcV55W5Ee0xc
         Czr2lZ36YIGVWKoWimzSnstlOMNs0+FAOn5ALDoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 4.14 86/95] rxrpc: Fix call ref leak
Date:   Mon,  4 Nov 2019 22:45:24 +0100
Message-Id: <20191104212123.283049638@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit c48fc11b69e95007109206311b0187a3090591f3 upstream.

When sendmsg() finds a call to continue on with, if the call is in an
inappropriate state, it doesn't release the ref it just got on that call
before returning an error.

This causes the following symptom to show up with kasan:

	BUG: KASAN: use-after-free in rxrpc_send_keepalive+0x8a2/0x940
	net/rxrpc/output.c:635
	Read of size 8 at addr ffff888064219698 by task kworker/0:3/11077

where line 635 is:

	whdr.epoch	= htonl(peer->local->rxnet->epoch);

The local endpoint (which cannot be pinned by the call) has been released,
but not the peer (which is pinned by the call).

Fix this by releasing the call in the error path.

Fixes: 37411cad633f ("rxrpc: Fix potential NULL-pointer exception")
Reported-by: syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rxrpc/sendmsg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -586,6 +586,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *
 		case RXRPC_CALL_SERVER_PREALLOC:
 		case RXRPC_CALL_SERVER_SECURING:
 		case RXRPC_CALL_SERVER_ACCEPTING:
+			rxrpc_put_call(call, rxrpc_call_put);
 			ret = -EBUSY;
 			goto error_release_sock;
 		default:


