Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F15B4F2274
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 07:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiDEFNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 01:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiDEFNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 01:13:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9649DE1C;
        Mon,  4 Apr 2022 22:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FD9B6136D;
        Tue,  5 Apr 2022 05:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38105C340F0;
        Tue,  5 Apr 2022 05:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649135476;
        bh=FwdQnecF1aUwDkxCflkmlNq8mPh5NIO1M7OMS9elTLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TwuV0gFrsUzPim8GWMAXA+vRFR3ERN1xvEkyI7C7rifZj5bpt4WzrmlH6x3+ZADnS
         FPw1ZxV0nWECFKEYrS751lke2gIor/ktm/IW/NEA4ZV6qO9T5CcvCk4umUJrBSTlY3
         hQuX5kC7n3qrEtA6PCCRNsEi6GXXHG2hBlE0m9jM=
Date:   Tue, 5 Apr 2022 07:11:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, stable@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: Re: [PATCH] can: usb_8dev: usb_8dev_start_xmit(): fix double
 dev_kfree_skb() in error path
Message-ID: <YkvPcRuSxbeXZn9I@kroah.com>
References: <20220404192536.1243729-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404192536.1243729-1-mkl@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 09:25:36PM +0200, Marc Kleine-Budde wrote:
> From: Hangyu Hua <hbh25y@gmail.com>
> 
> commit 3d3925ff6433f98992685a9679613a2cc97f3ce2 upstream.
> 
> There is no need to call dev_kfree_skb() when usb_submit_urb() fails
> because can_put_echo_skb() deletes original skb and
> can_free_echo_skb() deletes the cloned skb.
> 
> Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
> Link: https://lore.kernel.org/all/20220311080614.45229-1-hbh25y@gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Hello Greg, hello Sasha,
> 
> This is
> 
> | 3d3925ff6433 can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path
> 
> ported to v5.10.109.

This, and the other backport, now queued up, thanks!

greg k-h
