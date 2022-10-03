Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99B15F3194
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJCN7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJCN7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:59:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F941EC72
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 06:59:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06FFF61046
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 13:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F82C433C1;
        Mon,  3 Oct 2022 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664805551;
        bh=i054JibtTomPS4cp8s/RuEKcT+vwKd1my5ze2l6ZkUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ez9LnqkpBOKhxh2Qp8vUDXM49w6XdQR/Wgiido3wCAWIYPz6WYJ0fHs18amKCm6ZV
         3qWp1wDufsYfS7Q/voOp6BpJ0tjW7eaCCNCt2N8QqAf40B6NUrtgfRZxMaasANYJqY
         QPtontInf4vNUNZT3QqFUbvo4AiiSaU28y9Egp8Y=
Date:   Mon, 3 Oct 2022 15:59:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Kosyh <pkosyh@yandex.ru>
Cc:     stable@vger.kernel.org, Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 1/1] eth: ena: Check return value of
 xdp_convert_buff_to_frame
Message-ID: <YzrqrC2soSLjxfLD@kroah.com>
References: <20221003114819.349535-1-pkosyh@yandex.ru>
 <20221003114819.349535-2-pkosyh@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003114819.349535-2-pkosyh@yandex.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 02:48:19PM +0300, Peter Kosyh wrote:
> Return value of a function 'xdp_convert_buff_to_frame' is dereferenced
> without checking for null, but it is usually checked for this function.
> 
> This fixed in upstream commit <e8223eeff02> while refactoring.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 52414ac2c901..9e6b2bd73dac 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -237,6 +237,8 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
>  	u32 size;
>  
>  	tx_info->xdpf = xdp_convert_buff_to_frame(xdp);
> +	if (unlikely(!tx_info->xdpf))
> +		goto error_report_dma_error;
>  	size = tx_info->xdpf->len;
>  	ena_buf = tx_info->bufs;
>  
> -- 
> 2.37.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
