Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A4E15C5C0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgBMPYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:24:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728769AbgBMPYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:46 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3F092469C;
        Thu, 13 Feb 2020 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607486;
        bh=UpPXFoui4hyYvPiNR7vUK0jLSs31YFIdBM+fE9REzvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TD08ojSRn2Qv6O2A1J+J9gSqy7AoGdsO0xb9AHTHtrR3Rpy4x12Vg4VP4qAucaIa/
         yWtbLhnaV7vv/+dlAImHhC+PFpXNbdKk0/6cDS8EPjlVbMPISBBJvZ74Wx+gis3R8b
         EfAEw2KZ1uGOm0O8DFlUDUUG+vdJo6aMxRyoGcDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 4.14 016/173] rxrpc: Fix insufficient receive notification generation
Date:   Thu, 13 Feb 2020 07:18:39 -0800
Message-Id: <20200213151937.020629081@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit f71dbf2fb28489a79bde0dca1c8adfb9cdb20a6b ]

In rxrpc_input_data(), rxrpc_notify_socket() is called if the base sequence
number of the packet is immediately following the hard-ack point at the end
of the function.  However, this isn't sufficient, since the recvmsg side
may have been advancing the window and then overrun the position in which
we're adding - at which point rx_hard_ack >= seq0 and no notification is
generated.

Fix this by always generating a notification at the end of the input
function.

Without this, a long call may stall, possibly indefinitely.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -585,8 +585,7 @@ ack:
 				  immediate_ack, true,
 				  rxrpc_propose_ack_input_data);
 
-	if (sp->hdr.seq == READ_ONCE(call->rx_hard_ack) + 1)
-		rxrpc_notify_socket(call);
+	rxrpc_notify_socket(call);
 	_leave(" [queued]");
 }
 


