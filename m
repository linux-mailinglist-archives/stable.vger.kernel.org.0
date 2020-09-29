Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD8427D29D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 17:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgI2PYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 11:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgI2PYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 11:24:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0FB208B8;
        Tue, 29 Sep 2020 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601393045;
        bh=zVoo+i6EjZKg22J2H+YMigI9PUutDKs4vw/94Lgowm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qqOMnqwKdywTPUDJdHYarFHALcfx/Ktxi5IIDNLPyHc8eQ5+WMTpqmC8JkDQ0T7nQ
         YDwNFZvYlbNurGvPzcR/hS+2sG4Z2WOQORQWGWT3Hzk0hrDA+0p43+749GakkUkmMu
         SKVufEx16EQ6ZHv8yXTpB0Hlqq5FelL0ji01A+SQ=
Date:   Tue, 29 Sep 2020 17:24:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ion Badulescu <ionut@badula.org>
Cc:     stable@vger.kernel.org
Subject: Re: Network packet reordering with the 5.4 stable tree
Message-ID: <20200929152410.GA1318999@kroah.com>
References: <d3066d86-b63a-4a96-0537-e3e40c3826aa@badula.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3066d86-b63a-4a96-0537-e3e40c3826aa@badula.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 10:52:48AM -0400, Ion Badulescu wrote:
> Hello,
> 
> I ran into some packet reordering using a plain vanilla 5.4.49 kernel and
> the Amazon AWS ena driver. The external symptom was that every now and
> again, one or more larger packets would be delivered to the UDP socket after
> some smaller packets, even though the smaller packets were sent after the
> larger packets. They were also delivered late to a packet socket sniffer,
> which initially made me suspect an RSS bug in the ena hardware. Eventually,
> I modified the ena driver to stamp each packet (by overwriting its ethernet
> source mac field) with the id of the RSS queue that delivered it, and with
> the value of a per-RSS-queue counter that incremented for each packet
> received in that queue. That hack showed RSS functioning properly, and also
> showed packets received earlier (with a smaller counter value) being
> delivered after packets with a larger counter value. It established that the
> reordering was in fact happening inside the kernel network core.
> 
> The breakthrough came from realizing that the ena driver defaults its
> rx_copybreak to 256, which matched perfectly the boundary between the
> delayed large packets and the smaller packets being delivered first. After
> changing ena's rx_copybreak to zero, the reordering issue disappeared.
> 
> After a lot of hair pulling, I think I figured out what the issue is -- and
> it's confined to the 5.4 stable tree. Commit 323ebb61e32b4 (present in 5.4)
> introduced queueing for GRO_NORMAL packets received via napi_gro_frags() ->
> napi_frags_finish(). Commit 6570bc79c0df (NOT present in 5.4) extended the
> same GRO_NORMAL queueing to packets received via napi_gro_receive() ->
> napi_skb_finish(). Without 6570bc79c0df, packets received via
> napi_gro_receive() can get delivered ahead of the earlier, queued up packets
> received via napi_gro_frags(). And this is precisely what happens in the ena
> driver with packets smaller than rx_copybreak vs packets larger than
> rx_copybreak.
> 
> Interestingly, the 5.4 stable tree does contain a backport of the upstream
> c80794323e commit, which purports to fix issues introduced by 323ebb61e32b4
> and 6570bc79c0df. But 6570bc79c0df itself is missing...
> 
> I don't yet have a 5.4-stable patch, since I wanted to first raise the issue
> publicly and confirm I'm not missing something obvious. The patch would
> probably involve massaging 6570bc79c0df quite a bit, to avoid colliding with
> the already-present c80794323e fix.

You might want to also cc: the networking mailing list for this type of
stuff :)

thanks,

greg k-h
