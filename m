Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90037517AC0
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 01:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiEBX1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 19:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiEBX0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 19:26:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678351A801
        for <stable@vger.kernel.org>; Mon,  2 May 2022 16:23:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CAF8B81AD0
        for <stable@vger.kernel.org>; Mon,  2 May 2022 23:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6C0C385C1;
        Mon,  2 May 2022 23:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651533783;
        bh=qcdVGaGQwLjPNDlveLGHd/109418nNtd4kZzbJKKhdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oTONoFIda8w2SMsLEUXnuasAM/wCuxSsB25vvg5YNtDgPGSVmL9vR6RnUIhblzEfs
         PPYbLhUscNoO+8lnUGZG5y3s+wUFmpVINxviqw4XzZnA26CvFg/o2HL9AcUy3EhvdP
         dMIa9DZFOcnVdHfxSNpkz9Y8bpNIvMYPvdHSXJ0s=
Date:   Tue, 3 May 2022 01:23:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, Topi Miettinen <toiwoton@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5.17.y] netfilter: nft_socket: only do sk lookups when
 indev is available
Message-ID: <YnBn1lQ2o3AfgdV5@kroah.com>
References: <20220502205029.7355-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502205029.7355-1-fw@strlen.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 02, 2022 at 10:50:29PM +0200, Florian Westphal wrote:
> commit 743b83f15d4069ea57c3e40996bf4a1077e0cdc1 upstream.
> 
> Check if the incoming interface is available and NFT_BREAK
> in case neither skb->sk nor input device are set.
> 
> Because nf_sk_lookup_slow*() assume packet headers are in the
> 'in' direction, use in postrouting is not going to yield a meaningful
> result.  Same is true for the forward chain, so restrict the use
> to prerouting, input and output.
> 
> Use in output work if a socket is already attached to the skb.
> 
> Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
> Reported-and-tested-by: Topi Miettinen <toiwoton@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_socket.c | 52 ++++++++++++++++++++++++++++----------
>  1 file changed, 38 insertions(+), 14 deletions(-)
> 

Now queued up, thanks for the backport.

greg k-h
