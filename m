Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6673C1F9BFC
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbgFOPbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:31:16 -0400
Received: from baldur.buserror.net ([165.227.176.147]:51010 "EHLO
        baldur.buserror.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730439AbgFOPbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:31:15 -0400
X-Greylist: delayed 1949 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2020 11:31:14 EDT
Received: from [2601:449:8480:af0:12bf:48ff:fe84:c9a0]
        by baldur.buserror.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <oss@buserror.net>)
        id 1jkqUp-0004Ge-Sr; Mon, 15 Jun 2020 09:54:05 -0500
Message-ID: <b1aea45c882859def80d77229f36598c5fb3cd0a.camel@buserror.net>
From:   Scott Wood <oss@buserror.net>
To:     Arseny Solokha <asolokha@kb.kras.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jason Yan <yanaijie@huawei.com>, linuxppc-dev@lists.ozlabs.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Mon, 15 Jun 2020 09:53:58 -0500
In-Reply-To: <20200613162801.1946619-1-asolokha@kb.kras.ru>
References: <20200613162801.1946619-1-asolokha@kb.kras.ru>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: asolokha@kb.kras.ru, mpe@ellerman.id.au, yanaijie@huawei.com, linuxppc-dev@lists.ozlabs.org, christophe.leroy@c-s.fr, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: oss@buserror.net
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on baldur.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  -15 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
Subject: Re: [PATCH] powerpc/fsl_booke/32: fix build with
 CONFIG_RANDOMIZE_BASE
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2020-06-13 at 23:28 +0700, Arseny Solokha wrote:
> Building the current 5.8 kernel for a e500 machine with
> CONFIG_RANDOMIZE_BASE set yields the following failure:
> 
>   arch/powerpc/mm/nohash/kaslr_booke.c: In function 'kaslr_early_init':
>   arch/powerpc/mm/nohash/kaslr_booke.c:387:2: error: implicit declaration
> of function 'flush_icache_range'; did you mean 'flush_tlb_range'?
> [-Werror=implicit-function-declaration]
> 
> Indeed, including asm/cacheflush.h into kaslr_booke.c fixes the build.
> 
> The issue dates back to the introduction of that file and probably went
> unnoticed because there's no in-tree defconfig with CONFIG_RANDOMIZE_BASE
> set.
> 
> Fixes: 2b0e86cc5de6 ("powerpc/fsl_booke/32: implement KASLR infrastructure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
> ---
>  arch/powerpc/mm/nohash/kaslr_booke.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Scott Wood <oss@buserror.net>

-Scott


