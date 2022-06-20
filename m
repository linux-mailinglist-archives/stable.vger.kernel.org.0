Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B3C5517B1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 13:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241513AbiFTLqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 07:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241589AbiFTLqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 07:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55263186CE
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 04:45:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45DCC6129E
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 11:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E34EC3411B;
        Mon, 20 Jun 2022 11:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655725543;
        bh=eO58lzoa9bVmzb+ZeYSJF8ak/J/1Id4yJFt0KAGT3RU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cN0ftu6YlxDBpMvd1urX0/JaDap58Jfq4geI/ktx9qzmYpRhnCQVvFPo5V9JiNacS
         AQ/7I3rKv/gEEa7hS8cNL18+RMvshZiS9rYIUY2msB39uPK/sjq0j0ntN/BTxlotjm
         WFy9jeIpP6fDItsDCxCjlYtoTWV3pRLZ/aKlYfJw=
Date:   Mon, 20 Jun 2022 13:45:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.10] dma-direct: don't over-decrypt memory
Message-ID: <YrBd5F7bakWPbz7M@kroah.com>
References: <5de33f5cb5e1f80497b898e4690d36ed85ad396a.1655468052.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5de33f5cb5e1f80497b898e4690d36ed85ad396a.1655468052.git.robin.murphy@arm.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 01:46:49PM +0100, Robin Murphy wrote:
> [ Upstream commit 4a37f3dd9a83186cb88d44808ab35b78375082c9 ]
> 
> The original x86 sev_alloc() only called set_memory_decrypted() on
> memory returned by alloc_pages_node(), so the page order calculation
> fell out of that logic. However, the common dma-direct code has several
> potential allocators, not all of which are guaranteed to round up the
> underlying allocation to a power-of-two size, so carrying over that
> calculation for the encryption/decryption size was a mistake. Fix it by
> rounding to a *number* of pages, rather than an order.
> 
> Until recently there was an even worse interaction with DMA_DIRECT_REMAP
> where we could have ended up decrypting part of the next adjacent
> vmalloc area, only averted by no architecture actually supporting both
> configs at once. Don't ask how I found that one out...
> 
> Fixes: c10f07aa27da ("dma/direct: Handle force decryption for DMA coherent buffers in common code")
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: David Rientjes <rientjes@google.com>
> [ backport the functional change without all the prior refactoring ]
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
> 
> Hi Greg, Sasha,
> 
> I see you managed to resolve this back as far as 5.15 already, so please
> consider this backport to complete the set. This may need to end up in
> the Android 5.10 kernel in future for unpleasant reasons, but as an
> upstream fix I figure it may as well take the upstream stable route too.

Now queued up, thanks.

greg k-h
