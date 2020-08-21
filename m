Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE8D24D043
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 10:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgHUIFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 04:05:15 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50100 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgHUIFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 04:05:14 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k922s-0004Cr-5y; Fri, 21 Aug 2020 18:05:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 18:05:06 +1000
Date:   Fri, 21 Aug 2020 18:05:06 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 012/168] crypto: ccree - fix resource leak on error
 path
Message-ID: <20200821080506.GA25449@gondor.apana.org.au>
References: <20200817143733.692105228@linuxfoundation.org>
 <20200817143734.336080170@linuxfoundation.org>
 <20200818092231.GA10974@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818092231.GA10974@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 11:22:31AM +0200, Pavel Machek wrote:
>
> But it is freed unconditionally, and free_shash() is not robust
> against NULL pointer due to undefined behaviour in crypto_shash_tfm.

crypto_free_shash calls crypto_destroy_tfm with both the original
pointer as well as the crypto_shash_tfm pointer so it does the
right thing for NULL pointers.  Please check again.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
