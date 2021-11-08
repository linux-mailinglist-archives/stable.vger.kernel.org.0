Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCF9447B45
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 08:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbhKHHqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 02:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234348AbhKHHqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 02:46:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7144561179;
        Mon,  8 Nov 2021 07:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636357407;
        bh=fJNkYy2VfWxWOmdLqyNzL495wn67Xy7+DIMPMdlQ5sM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n16fUCLJPnqKnmqvR1U6WUsVeKbYd0wT1AkaZxkIzivQRITTlMG1RT35OkoSNVvlY
         w/fmog3tLnVYV52mZ15FDosrID2YjKqii6s5AmhswP6F/d90sq6RAFnQpUK2polsfA
         mwKe6ddMy4/7FGUN9zbt2wAXSzpJvsIMp4IT+lKE=
Date:   Mon, 8 Nov 2021 08:43:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 68/77] sctp: add vtag check in sctp_sf_violation
Message-ID: <YYjVHMpu7lfYYHOR@kroah.com>
References: <20211101082511.254155853@linuxfoundation.org>
 <20211101082525.833757923@linuxfoundation.org>
 <a3059f52-54c6-6ab3-0f1d-a9b1566ff118@ispras.ru>
 <YYFevClqyJbASQXH@kroah.com>
 <YYjKd/UwdwrbnrNd@kroah.com>
 <06ea9fcf-12ab-29af-1621-6b1bb38a2265@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06ea9fcf-12ab-29af-1621-6b1bb38a2265@ispras.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 08, 2021 at 10:23:11AM +0300, Alexey Khoroshilov wrote:
> On 08.11.2021 09:57, Greg Kroah-Hartman wrote:
> > On Tue, Nov 02, 2021 at 04:52:28PM +0100, Greg Kroah-Hartman wrote:
> >> On Tue, Nov 02, 2021 at 05:12:16PM +0300, Alexey Khoroshilov wrote:
> >>> Hello!
> >>>
> >>> It seems the patch may lead to NULL pointer dereference.
> >>>
> >>>
> >>> 1. sctp_sf_violation_chunk() calls sctp_sf_violation() with asoc arg
> >>> equal to NULL.
> >>>
> >>> static enum sctp_disposition sctp_sf_violation_chunk(
> >>> ...
> >>> {
> >>> ...
> >>>     if (!asoc)
> >>>         return sctp_sf_violation(net, ep, asoc, type, arg, commands);
> >>> ...
> >>>
> >>> 2. Newly added code of sctp_sf_violation() calls to sctp_vtag_verify()
> >>> with asoc arg equal to NULL.
> >>>
> >>> enum sctp_disposition sctp_sf_violation(struct net *net,
> >>> ...
> >>> {
> >>>     struct sctp_chunk *chunk = arg;
> >>>
> >>>     if (!sctp_vtag_verify(chunk, asoc))
> >>>         return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> >>> ...
> >>>
> >>> 3. sctp_vtag_verify() dereferences asoc without any check.
> >>>
> >>> /* Check VTAG of the packet matches the sender's own tag. */
> >>> static inline int
> >>> sctp_vtag_verify(const struct sctp_chunk *chunk,
> >>> 		 const struct sctp_association *asoc)
> >>> {
> >>> 	/* RFC 2960 Sec 8.5 When receiving an SCTP packet, the endpoint
> >>> 	 * MUST ensure that the value in the Verification Tag field of
> >>> 	 * the received SCTP packet matches its own Tag. If the received
> >>> 	 * Verification Tag value does not match the receiver's own
> >>> 	 * tag value, the receiver shall silently discard the packet...
> >>> 	 */
> >>> 	if (ntohl(chunk->sctp_hdr->vtag) != asoc->c.my_vtag)
> >>> 		return 0;
> >>>
> >>>
> >>> Found by Linux Verification Center (linuxtesting.org) with SVACE tool.
> >>
> >> These issues should all be the same with Linus's tree, so can you please
> >> submit patches to the normal netdev developers and mailing list to
> >> resolve the above issues?
> > 
> > Given a lack of response, I am going to assume that these are not real
> > issues.  If you think they are, please submit patches to the network
> > developers to resolve them.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
> During discussion with the network developers it was defined that the
> code is unreachable and should be removed. The corresponding patch is
> already in network tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=e7ea51cd879c

Great, thanks for letting me know.

greg k-h
