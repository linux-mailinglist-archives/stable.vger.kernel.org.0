Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9284BA89C
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 19:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiBQSmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 13:42:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbiBQSmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 13:42:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10557DFBE
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 10:42:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F042B8236E
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 18:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE10C340E8;
        Thu, 17 Feb 2022 18:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645123345;
        bh=J6sqOUqBaZKuLAwWVEyBpdJCe+1zIyXLyLeVUdK1a5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zXEurY+UdXWFi0WDpEPrw7pMGg59mLccofY/oQdNsCKDhEdeoVAz2mh+bW/21toHq
         m66PoBTzOTkuUacs/aBSmh0WhfIHIuvr7HHjEsyMCDiWtWxk4VyW6uv4ytlubnViXr
         eaG4+UugwR/9wOjXnU375br+ZhXdGf4/YoPQLB2A=
Date:   Thu, 17 Feb 2022 19:42:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH stable 4.9,4.14,4.19] net: usb: ax88179_178a: Fix
 out-of-bounds accesses in RX fixup
Message-ID: <Yg6XDRFQno7YiHQ4@kroah.com>
References: <20220214113242.686953-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214113242.686953-1-jannh@google.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 12:32:42PM +0100, Jann Horn wrote:
> commit 57bc3d3ae8c14df3ceb4e17d26ddf9eeab304581 upstream.
> 
> ax88179_rx_fixup() contains several out-of-bounds accesses that can be
> triggered by a malicious (or defective) USB device, in particular:
> 
>  - The metadata array (hdr_off..hdr_off+2*pkt_cnt) can be out of bounds,
>    causing OOB reads and (on big-endian systems) OOB endianness flips.
>  - A packet can overlap the metadata array, causing a later OOB
>    endianness flip to corrupt data used by a cloned SKB that has already
>    been handed off into the network stack.
>  - A packet SKB can be constructed whose tail is far beyond its end,
>    causing out-of-bounds heap data to be considered part of the SKB's
>    data.
> 
> I have tested that this can be used by a malicious USB device to send a
> bogus ICMPv6 Echo Request and receive an ICMPv6 Echo Reply in response
> that contains random kernel heap data.
> It's probably also possible to get OOB writes from this on a
> little-endian system somehow - maybe by triggering skb_cow() via IP
> options processing -, but I haven't tested that.
> 
> Fixes: e2ca90c276e1 ("ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver")
> Cc: stable@kernel.org
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  drivers/net/usb/ax88179_178a.c | 68 +++++++++++++++++++---------------
>  1 file changed, 39 insertions(+), 29 deletions(-)

Now queued up, thanks.

greg k-h
