Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0A34823B3
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 12:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhLaLev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Dec 2021 06:34:51 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58788 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhLaLev (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Dec 2021 06:34:51 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n3GBG-0004se-P3; Fri, 31 Dec 2021 22:34:43 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Dec 2021 22:34:42 +1100
Date:   Fri, 31 Dec 2021 22:34:42 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Lionel Debieve <lionel.debieve@st.com>,
        Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH] crypto: stm32/crc32 - Fix kernel BUG triggered in probe()
Message-ID: <Yc7q0o1HL2THW2Kc@gondor.apana.org.au>
References: <20211220195022.1387104-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220195022.1387104-1-marex@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 08:50:22PM +0100, Marek Vasut wrote:
> The include/linux/crypto.h struct crypto_alg field cra_driver_name description
> states "Unique name of the transformation provider. " ... " this contains the
> name of the chip or provider and the name of the transformation algorithm."
> 
> In case of the stm32-crc driver, field cra_driver_name is identical for all
> registered transformation providers and set to the name of the driver itself,
> which is incorrect. This patch fixes it by assigning a unique cra_driver_name
> to each registered transformation provider.
> 
> The kernel crash is triggered when the driver calls crypto_register_shashes()
> which calls crypto_register_shash(), which calls crypto_register_alg(), which
> calls __crypto_register_alg(), which returns -EEXIST, which is propagated
> back through this call chain. Upon -EEXIST from crypto_register_shash(), the
> crypto_register_shashes() starts unregistering the providers back, and calls
> crypto_unregister_shash(), which calls crypto_unregister_alg(), and this is
> where the BUG() triggers due to incorrect cra_refcnt.
> 
> Fixes: b51dbe90912a ("crypto: stm32 - Support for STM32 CRC32 crypto module")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: <stable@vger.kernel.org> # 4.12+
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Fabien Dessenne <fabien.dessenne@st.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Lionel Debieve <lionel.debieve@st.com>
> Cc: Nicolas Toromanoff <nicolas.toromanoff@st.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> To: linux-crypto@vger.kernel.org
> ---
>  drivers/crypto/stm32/stm32-crc32.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
