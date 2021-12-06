Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562F0469616
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 13:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243433AbhLFNBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 08:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243421AbhLFNBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 08:01:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BF4C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 04:58:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 890396126E
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 12:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3EEC341C1;
        Mon,  6 Dec 2021 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638795504;
        bh=caeDQ7P2Y9CTY9WpVl3B+g8dDnHxyDUR51IqIn/nCsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=abQ5uBqXgJrh3/A+n50lQZQ+vsJKXOqFYGEwnGICKaum5YOSQAhmRE3ETQQXk4RVp
         6hHRc6kdnum712HJctDAxKdUV2AmYFjURUrPjXrzjXpI4RzorU9KBDOoBaU03Z+he9
         kMOsKileQgu7ikQI9VkASB/3Dq+0mztxq9B/UOWM=
Date:   Mon, 6 Dec 2021 13:58:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vakul Garg <vakul.garg@nxp.com>, stable@vger.kernel.org
Subject: Re: [PATCH stable 5.10] net/tls: Fix authentication failure in CCM
 mode
Message-ID: <Ya4I7XTQyqiqwoVZ@kroah.com>
References: <163861363511932@kroah.com>
 <20211206093536.129211-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206093536.129211-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 05:35:36PM +0800, Tianjia Zhang wrote:
> commit 5961060692f8b17cd2080620a3d27b95d2ae05ca upstream.
> 
> When the TLS cipher suite uses CCM mode, including AES CCM and
> SM4 CCM, the first byte of the B0 block is flags, and the real
> IV starts from the second byte. The XOR operation of the IV and
> rec_seq should be skip this byte, that is, add the iv_offset.
> 
> Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Cc: Vakul Garg <vakul.garg@nxp.com>
> Cc: stable@vger.kernel.org # v5.2+
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/tls/tls_sw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 122d5daed8b6..8cd011ea9fbb 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -515,7 +515,7 @@ static int tls_do_encryption(struct sock *sk,
>  	memcpy(&rec->iv_data[iv_offset], tls_ctx->tx.iv,
>  	       prot->iv_size + prot->salt_size);
>  
> -	xor_iv_with_seq(prot->version, rec->iv_data, tls_ctx->tx.rec_seq);
> +	xor_iv_with_seq(prot->version, rec->iv_data + iv_offset, tls_ctx->tx.rec_seq);
>  
>  	sge->offset += prot->prepend_size;
>  	sge->length -= prot->prepend_size;
> @@ -1487,7 +1487,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
>  	else
>  		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
>  
> -	xor_iv_with_seq(prot->version, iv, tls_ctx->rx.rec_seq);
> +	xor_iv_with_seq(prot->version, iv + iv_offset, tls_ctx->rx.rec_seq);
>  
>  	/* Prepare AAD */
>  	tls_make_aad(aad, rxm->full_len - prot->overhead_size +
> -- 
> 2.19.1.3.ge56e4f7
> 

Both backports now queued up, thanks.

greg k-h
