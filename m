Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970E222AA23
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 09:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGWH5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 03:57:00 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34688 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgGWH5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 03:57:00 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jyW5n-0005uU-C4; Thu, 23 Jul 2020 17:56:40 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Jul 2020 17:56:39 +1000
Date:   Thu, 23 Jul 2020 17:56:39 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     trix@redhat.com
Cc:     giovanni.cabiddu@intel.com, davem@davemloft.net,
        wojciech.ziemba@intel.com, karen.xiang@intel.com,
        bruce.w.allan@intel.com, bo.cui@intel.com,
        pingchaox.yang@intel.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat: fix double free in
 qat_uclo_create_batch_init_list
Message-ID: <20200723075639.GB14246@gondor.apana.org.au>
References: <20200713140634.14730-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713140634.14730-1-trix@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 13, 2020 at 07:06:34AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis flags this error
> 
> qat_uclo.c:297:3: warning: Attempt to free released memory
>   [unix.Malloc]
>                 kfree(*init_tab_base);
>                 ^~~~~~~~~~~~~~~~~~~~~
> 
> When input *init_tab_base is null, the function allocates memory for
> the head of the list.  When there is problem allocating other list
> elements the list is unwound and freed.  Then a check is made if the
> list head was allocated and is also freed.
> 
> Keeping track of the what may need to be freed is the variable 'tail_old'.
> The unwinding/freeing block is
> 
> 	while (tail_old) {
> 		mem_init = tail_old->next;
> 		kfree(tail_old);
> 		tail_old = mem_init;
> 	}
> 
> The problem is that the first element of tail_old is also what was
> allocated for the list head
> 
> 		init_header = kzalloc(sizeof(*init_header), GFP_KERNEL);
> 		...
> 		*init_tab_base = init_header;
> 		flag = 1;
> 	}
> 	tail_old = init_header;
> 
> So *init_tab_base/init_header are freed twice.
> 
> There is another problem.
> When the input *init_tab_base is non null the tail_old is calculated by
> traveling down the list to first non null entry.
> 
> 	tail_old = init_header;
> 	while (tail_old->next)
> 		tail_old = tail_old->next;
> 
> When the unwinding free happens, the last entry of the input list will
> be freed.
> 
> So the freeing needs a general changed.
> If locally allocated the first element of tail_old is freed, else it
> is skipped.  As a bit of cleanup, reset *init_tab_base if it came in
> as null.
> 
> Fixes: b4b7e67c917f ("crypto: qat - Intel(R) QAT ucode part of fw loader")
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/crypto/qat/qat_common/qat_uclo.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
