Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CB51E155D
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 22:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390670AbgEYUy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 16:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388714AbgEYUy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 16:54:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98421206D5;
        Mon, 25 May 2020 20:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590440098;
        bh=7Tkacnqn9PjpF06bVCXcMyU+PUSo9YI0zpP99EDGzuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tNisye9MI/29g7wnDOaAmLKge3M1pfLOBcIMIKyFwdZRW3vBgwCb2R/GL7WEHKfqH
         xDD3Ji1ECx83scCdgAYYK/x40mLS1qSwQ7FJFo5Bd1u6EHCdjkp3CGBu6v2W0Xdomu
         u6tylVuH2v4DYq6qTpJV8GKR08BQz80REZaB+SpE=
Date:   Mon, 25 May 2020 16:54:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     dhowells@redhat.com, botsch@cnf.cornell.edu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] rxrpc: Fix ack discard" failed to apply
 to 5.6-stable tree
Message-ID: <20200525205457.GC33628@sasha-vm>
References: <15904174535561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15904174535561@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 04:37:33PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 441fdee1eaf050ef0040bde0d7af075c1c6a6d8b Mon Sep 17 00:00:00 2001
>From: David Howells <dhowells@redhat.com>
>Date: Wed, 29 Apr 2020 23:48:43 +0100
>Subject: [PATCH] rxrpc: Fix ack discard
>
>The Rx protocol has a "previousPacket" field in it that is not handled in
>the same way by all protocol implementations.  Sometimes it contains the
>serial number of the last DATA packet received, sometimes the sequence
>number of the last DATA packet received and sometimes the highest sequence
>number so far received.
>
>AF_RXRPC is using this to weed out ACKs that are out of date (it's possible
>for ACK packets to get reordered on the wire), but this does not work with
>OpenAFS which will just stick the sequence number of the last packet seen
>into previousPacket.
>
>The issue being seen is that big AFS FS.StoreData RPC (eg. of ~256MiB) are
>timing out when partly sent.  A trace was captured, with an additional
>tracepoint to show ACKs being discarded in rxrpc_input_ack().  Here's an
>excerpt showing the problem.
>
> 52873.203230: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 0002449c q=00024499 fl=09
>
>A DATA packet with sequence number 00024499 has been transmitted (the "q="
>field).
>
> ...
> 52873.243296: rxrpc_rx_ack: c=000004ae 00012a2b DLY r=00024499 f=00024497 p=00024496 n=0
> 52873.243376: rxrpc_rx_ack: c=000004ae 00012a2c IDL r=0002449b f=00024499 p=00024498 n=0
> 52873.243383: rxrpc_rx_ack: c=000004ae 00012a2d OOS r=0002449d f=00024499 p=0002449a n=2
>
>The Out-Of-Sequence ACK indicates that the server didn't see DATA sequence
>number 00024499, but did see seq 0002449a (previousPacket, shown as "p=",
>skipped the number, but firstPacket, "f=", which shows the bottom of the
>window is set at that point).
>
> 52873.252663: rxrpc_retransmit: c=000004ae q=24499 a=02 xp=14581537
> 52873.252664: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 000244bc q=00024499 fl=0b *RETRANS*
>
>The packet has been retransmitted.  Retransmission recurs until the peer
>says it got the packet.
>
> 52873.271013: rxrpc_rx_ack: c=000004ae 00012a31 OOS r=000244a1 f=00024499 p=0002449e n=6
>
>More OOS ACKs indicate that the other packets that are already in the
>transmission pipeline are being received.  The specific-ACK list is up to 6
>ACKs and NAKs.
>
> ...
> 52873.284792: rxrpc_rx_ack: c=000004ae 00012a49 OOS r=000244b9 f=00024499 p=000244b6 n=30
> 52873.284802: rxrpc_retransmit: c=000004ae q=24499 a=0a xp=63505500
> 52873.284804: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 000244c2 q=00024499 fl=0b *RETRANS*
> 52873.287468: rxrpc_rx_ack: c=000004ae 00012a4a OOS r=000244ba f=00024499 p=000244b7 n=31
> 52873.287478: rxrpc_rx_ack: c=000004ae 00012a4b OOS r=000244bb f=00024499 p=000244b8 n=32
>
>At this point, the server's receive window is full (n=32) with presumably 1
>NAK'd packet and 31 ACK'd packets.  We can't transmit any more packets.
>
> 52873.287488: rxrpc_retransmit: c=000004ae q=24499 a=0a xp=61327980
> 52873.287489: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 000244c3 q=00024499 fl=0b *RETRANS*
> 52873.293850: rxrpc_rx_ack: c=000004ae 00012a4c DLY r=000244bc f=000244a0 p=00024499 n=25
>
>And now we've received an ACK indicating that a DATA retransmission was
>received.  7 packets have been processed (the occupied part of the window
>moved, as indicated by f= and n=).
>
> 52873.293853: rxrpc_rx_discard_ack: c=000004ae r=00012a4c 000244a0<00024499 00024499<000244b8
>
>However, the DLY ACK gets discarded because its previousPacket has gone
>backwards (from p=000244b8, in the ACK at 52873.287478 to p=00024499 in the
>ACK at 52873.293850).
>
>We then end up in a continuous cycle of retransmit/discard.  kafs fails to
>update its window because it's discarding the ACKs and can't transmit an
>extra packet that would clear the issue because the window is full.
>OpenAFS doesn't change the previousPacket value in the ACKs because no new
>DATA packets are received with a different previousPacket number.
>
>Fix this by altering the discard check to only discard an ACK based on
>previousPacket if there was no advance in the firstPacket.  This allows us
>to transmit a new packet which will cause previousPacket to advance in the
>next ACK.
>
>The check, however, needs to allow for the possibility that previousPacket
>may actually have had the serial number placed in it instead - in which
>case it will go outside the window and we should ignore it.
>
>Fixes: 1a2391c30c0b ("rxrpc: Fix detection of out of order acks")
>Reported-by: Dave Botsch <botsch@cnf.cornell.edu>
>Signed-off-by: David Howells <dhowells@redhat.com>

I've also grabbed d1f129470e6c ("rxrpc: Trace discarded ACKs") to add a
tracepoint and queued both for 5.6, 5.4, and 4.19.

-- 
Thanks,
Sasha
