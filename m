Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEBF447AA3
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 07:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhKHHAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 02:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236168AbhKHHAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 02:00:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21CA060041;
        Mon,  8 Nov 2021 06:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636354682;
        bh=b2fFSboOM6vWOlcYYowMTIvz/bRMu1W2OvDJwY9x72s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WCQxvTPG6zbsWvOhGTIaX45i7RgR2OGkL9bRC6zfUcYsKkyKRbqYztbcofRtRXEl+
         n4ba+37SoABBCVZg+B0R5h3RAFnFclgt+j35rDI+dKUdUeO69lEO1rWBS92wHvpfVD
         UvdKfKMnxEe/uToKzGstjJSk7Rp49sd6jbRGsSA8=
Date:   Mon, 8 Nov 2021 07:57:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 68/77] sctp: add vtag check in sctp_sf_violation
Message-ID: <YYjKd/UwdwrbnrNd@kroah.com>
References: <20211101082511.254155853@linuxfoundation.org>
 <20211101082525.833757923@linuxfoundation.org>
 <a3059f52-54c6-6ab3-0f1d-a9b1566ff118@ispras.ru>
 <YYFevClqyJbASQXH@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYFevClqyJbASQXH@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 02, 2021 at 04:52:28PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 02, 2021 at 05:12:16PM +0300, Alexey Khoroshilov wrote:
> > Hello!
> > 
> > It seems the patch may lead to NULL pointer dereference.
> > 
> > 
> > 1. sctp_sf_violation_chunk() calls sctp_sf_violation() with asoc arg
> > equal to NULL.
> > 
> > static enum sctp_disposition sctp_sf_violation_chunk(
> > ...
> > {
> > ...
> >     if (!asoc)
> >         return sctp_sf_violation(net, ep, asoc, type, arg, commands);
> > ...
> > 
> > 2. Newly added code of sctp_sf_violation() calls to sctp_vtag_verify()
> > with asoc arg equal to NULL.
> > 
> > enum sctp_disposition sctp_sf_violation(struct net *net,
> > ...
> > {
> >     struct sctp_chunk *chunk = arg;
> > 
> >     if (!sctp_vtag_verify(chunk, asoc))
> >         return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> > ...
> > 
> > 3. sctp_vtag_verify() dereferences asoc without any check.
> > 
> > /* Check VTAG of the packet matches the sender's own tag. */
> > static inline int
> > sctp_vtag_verify(const struct sctp_chunk *chunk,
> > 		 const struct sctp_association *asoc)
> > {
> > 	/* RFC 2960 Sec 8.5 When receiving an SCTP packet, the endpoint
> > 	 * MUST ensure that the value in the Verification Tag field of
> > 	 * the received SCTP packet matches its own Tag. If the received
> > 	 * Verification Tag value does not match the receiver's own
> > 	 * tag value, the receiver shall silently discard the packet...
> > 	 */
> > 	if (ntohl(chunk->sctp_hdr->vtag) != asoc->c.my_vtag)
> > 		return 0;
> > 
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE tool.
> 
> These issues should all be the same with Linus's tree, so can you please
> submit patches to the normal netdev developers and mailing list to
> resolve the above issues?

Given a lack of response, I am going to assume that these are not real
issues.  If you think they are, please submit patches to the network
developers to resolve them.

thanks,

greg k-h
