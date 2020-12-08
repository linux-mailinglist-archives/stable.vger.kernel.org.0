Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E802D1F5A
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 01:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgLHAtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 19:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgLHAto (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 19:49:44 -0500
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF46C061793
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 16:49:04 -0800 (PST)
Received: by mail-qv1-xf42.google.com with SMTP id n9so7547187qvp.5
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 16:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lt1Fm9+tAxicQ8gVonKBaJW6G2HnCPxFeAoxndgf4W4=;
        b=J9lCxE/AIvfwNlr6b+PTJK3bpnBQ+ibe8zIWlFNBH66DYi3rICpDqojjMJGXhVCP6c
         cIEmfrVaZui1RGcfosI03/83/KLj6wz66v3MZovGqRVYhoZ111yMK5ilexOOlgoKJNtB
         X3HILMED2ZuW1nJ9v7GLR3kila553xt75m/1s4IBqtQdXM5xJoUjDS7ly5PsmKvoD6oq
         vAVS5/2Pzk5155+4F3swrR00h0NEmMsVIMcV8WOnAYEfMQijynDjeWQz2HE8lfzPgxEt
         fIzBC5Y1+YqBoCpEc4RND0TBbqETRSss1bMln/r0hmdiS6l+Tm2TSFSQqXYxHdRTWanM
         z8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lt1Fm9+tAxicQ8gVonKBaJW6G2HnCPxFeAoxndgf4W4=;
        b=HWZnL5Y6ABrFT/FPamSKxeWCwuxzb7hDfIiKq7WD7neiNFdNi8VQ8FMy2P6zFH6pzV
         JLhkMGYliR+3l2j515iCdwNrB8SbqvU3ta1sfUInVvwiCOfnvjciY8JsYkX02zFKfS+Q
         Jp4oSg80rEaQg/I9T6aXB8+nIXq+mBP4G+hodtHrATWQ/ic/2h3sIGAz+fzhsSlHAB2I
         NWGYgY+Dx8R9cjZ22bf4NKHGfXnvGUL4JIw2fN0/0uKMLB/eEESCSGkzM5amR+N+aAFh
         cESSVAjc2Mf505e9ebrUAme79SH/dyFbfJXfjBPzeVhnInCLACNu4Fj3/6XeUO/Rqi7h
         HI7Q==
X-Gm-Message-State: AOAM532WIe5MUFOtVAqW6nCWjvryhhYSFZX9QAyDD83n9lir+VGxQg+/
        darDLttTqLMrZRdqnoXzab4=
X-Google-Smtp-Source: ABdhPJyMIFMjTiqY9RAbnO84OgxpyUmbbJbLUGjnXIVa4eW6yVpRwecvuKDklF0hvXGplA5MWf2yTQ==
X-Received: by 2002:a05:6214:602:: with SMTP id z2mr10806186qvw.40.1607388543856;
        Mon, 07 Dec 2020 16:49:03 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id y192sm14013936qkb.12.2020.12.07.16.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:49:03 -0800 (PST)
Date:   Mon, 7 Dec 2020 17:49:01 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <20201208004901.GB587492@ubuntu-m3-large-x86>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 06, 2020 at 01:31:03PM +0100, Lukas Wunner wrote:
> [ Upstream commit e13ee6cc4781edaf8c7321bee19217e3702ed481 ]
> 
> bcm2835aux_spi_remove() accesses the driver's private data after calling
> spi_unregister_master() even though that function releases the last
> reference on the spi_master and thereby frees the private data.
> 
> Fix by switching over to the new devm_spi_alloc_master() helper which
> keeps the private data accessible until the driver has unbound.
> 
> Fixes: b9dd3f6d4172 ("spi: bcm2835aux: Fix controller unregister order")
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: <stable@vger.kernel.org> # v4.4+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
> Cc: <stable@vger.kernel.org> # v4.4+: b9dd3f6d4172: spi: bcm2835aux: Fix controller unregister order
> Cc: <stable@vger.kernel.org> # v4.4+
> Link: https://lore.kernel.org/r/b290b06357d0c0bdee9cecc539b840a90630f101.1605121038.git.lukas@wunner.de
> Signed-off-by: Mark Brown <broonie@kernel.org>

Please ensure that commit d853b3406903 ("spi: bcm2835aux: Restore err
assignment in bcm2835aux_spi_probe") is picked up with this patch in all
of the stable trees that it is applied to.

Cheers,
Nathan
