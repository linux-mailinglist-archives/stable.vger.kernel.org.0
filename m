Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3E81E499A
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgE0QQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:16:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35201 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730338AbgE0QQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 12:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590596217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iSxlOlLsNfvawgHjz+GwbWY19wvXwwDxrSiwdIvpXGc=;
        b=BeWpYBVarXLRqiwwk40xmWHyBykNRa30BM0wJrUUTYKJGrQJbYdhYuMGd+dIQNVjlSFDMm
        lAsrtQWMc7ihmu3AtFJwcGYrkNl+jtO9IXKzJ/OfkA+F57jeErXMk8bdWw9ZwpHSxfc7lf
        Hw0rCAtQGKGmNqDNIcWb1F17Wpr/680=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-hNJO7bdqMl2p2tjcXbtB9w-1; Wed, 27 May 2020 12:16:55 -0400
X-MC-Unique: hNJO7bdqMl2p2tjcXbtB9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48B8C80183C;
        Wed, 27 May 2020 16:16:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F2621A913;
        Wed, 27 May 2020 16:16:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200525205457.GC33628@sasha-vm>
References: <20200525205457.GC33628@sasha-vm> <15904174535561@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     dhowells@redhat.com, gregkh@linuxfoundation.org,
        botsch@cnf.cornell.edu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] rxrpc: Fix ack discard" failed to apply to 5.6-stable tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3874436.1590596212.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 27 May 2020 17:16:52 +0100
Message-ID: <3874437.1590596212@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> wrote:

> I've also grabbed d1f129470e6c ("rxrpc: Trace discarded ACKs") to add a
> tracepoint and queued both for 5.6, 5.4, and 4.19.

You can just drop the tracepoint bits if that helps.

<gregkh@linuxfoundation.org> wrote:

> @@ -865,8 +889,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call,=
 struct sk_buff *skb)
>  	}
>  =

>  	/* Discard any out-of-order or duplicate ACKs (outside lock). */
> -	if (before(first_soft_ack, call->ackr_first_seq) ||
> -	    before(prev_pkt, call->ackr_prev_seq)) {
> +	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
>  		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
>  					   first_soft_ack, call->ackr_first_seq,
>  					   prev_pkt, call->ackr_prev_seq);

This trace_rxrpc_rx_discard_ack() statement.

> @@ -882,8 +905,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call,=
 struct sk_buff *skb)
>  	spin_lock(&call->input_lock);
>  =

>  	/* Discard any out-of-order or duplicate ACKs (inside lock). */
> -	if (before(first_soft_ack, call->ackr_first_seq) ||
> -	    before(prev_pkt, call->ackr_prev_seq)) {
> +	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
>  		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
>  					   first_soft_ack, call->ackr_first_seq,
>  					   prev_pkt, call->ackr_prev_seq);
> =


And this one.

David

