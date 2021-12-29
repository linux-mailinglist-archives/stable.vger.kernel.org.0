Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACDF480EA4
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 02:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhL2Biz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 20:38:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59258 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhL2Biy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 20:38:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E14E60BBF;
        Wed, 29 Dec 2021 01:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C0CC36AE7;
        Wed, 29 Dec 2021 01:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640741933;
        bh=jeZlngD5pvLcEKLRpXuz0gQozCoRB0jq0E50boipzgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lqUZQ6pcnBnIYofjpQh5NUgGxUufs1b4e5yrMEl6iziHfU5Uv1Y6QXv/La8Mtes1Y
         3VoGUsDzTfCqDjS7KwrdgSLLz6PPBV0NhNLF1rLg5UXWch8KMu+YVPdpOIcAraZ+Bk
         mPD5qtLs6J1VdeMbT2ajhb/q4u1u2nXac2JHOKqbLkHWnXEbLV7AbIneXhZUPEB3X2
         +ke3qgjJvUpbODcbV76aMG+bAhoBv3K1H+Hsih1lfR07+hBUcqjWBHzCoh2HAy8Nvw
         vpMbyeoXstz8TGdmU+TjtDTcY7rRg2WHxRp7ZQ0mS8Cp9mpIYUzrW9TyvTNi5xXnpc
         uRBJOZZ+R6nXg==
Date:   Wed, 29 Dec 2021 03:38:51 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Patrick Williams <patrick@stwcx.xyz>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Hao Wu <hao.wu@rubrik.com>, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm: fix NPE on probe for missing device
Message-ID: <Ycu8KxrunNXvOobG@iki.fi>
References: <20211223154932.678424-1-patrick@stwcx.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223154932.678424-1-patrick@stwcx.xyz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 09:49:31AM -0600, Patrick Williams wrote:
> When using the tpm_tis-spi driver on a system missing the physical TPM,
> a null pointer exception was observed.
> 
>     [    0.938677] Unable to handle kernel NULL pointer dereference at virtual address 00000004
>     [    0.939020] pgd = 10c753cb
>     [    0.939237] [00000004] *pgd=00000000
>     [    0.939808] Internal error: Oops: 5 [#1] SMP ARM
>     [    0.940157] CPU: 0 PID: 48 Comm: kworker/u4:1 Not tainted 5.15.10-dd1e40c #1
>     [    0.940364] Hardware name: Generic DT based system
>     [    0.940601] Workqueue: events_unbound async_run_entry_fn
>     [    0.941048] PC is at tpm_tis_remove+0x28/0xb4
>     [    0.941196] LR is at tpm_tis_core_init+0x170/0x6ac
> 
> This is due to an attempt in 'tpm_tis_remove' to use the drvdata, which
> was not initialized in 'tpm_tis_core_init' prior to the first error.
> 
> Move the initialization of drvdata earlier so 'tpm_tis_remove' has
> access to it.
> 
> Signed-off-by: Patrick Williams <patrick@stwcx.xyz>
> Fixes: 79ca6f74dae0 ("tpm: fix Atmel TPM crash caused by too frequent queries")
> Cc: stable@vger.kernel.org

Thank you.
 
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
