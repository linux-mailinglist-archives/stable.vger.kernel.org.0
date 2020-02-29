Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07009174A21
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 00:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgB2X3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 18:29:04 -0500
Received: from baldur.buserror.net ([165.227.176.147]:54352 "EHLO
        baldur.buserror.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgB2X3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 18:29:04 -0500
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Feb 2020 18:29:03 EST
Received: from [2601:449:8480:af0:12bf:48ff:fe84:c9a0]
        by baldur.buserror.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <oss@buserror.net>)
        id 1j8BEZ-0002KT-PB; Sat, 29 Feb 2020 17:09:24 -0600
Message-ID: <498ce16efb7784d95569d000bfab33ae25b823bd.camel@buserror.net>
From:   Scott Wood <oss@buserror.net>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>
Cc:     "christophe.leroy@c-s.fr" <christophe.leroy@c-s.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Sat, 29 Feb 2020 17:09:22 -0600
In-Reply-To: <20200123111914.2565-1-laurentiu.tudor@nxp.com>
References: <20200123111914.2565-1-laurentiu.tudor@nxp.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: laurentiu.tudor@nxp.com, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au, christophe.leroy@c-s.fr, linux-kernel@vger.kernel.org, diana.craciun@nxp.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: oss@buserror.net
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on baldur.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  -15 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        * -1.5 GREYLIST_ISWHITE The incoming server has been whitelisted for
        *      this recipient and sender
Subject: Re: [PATCH] powerpc/fsl_booke: avoid creating duplicate tlb1 entry
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-01-23 at 11:19 +0000, Laurentiu Tudor wrote:
> In the current implementation, the call to loadcam_multi() is wrapped
> between switch_to_as1() and restore_to_as0() calls so, when it tries
> to create its own temporary AS=1 TLB1 entry, it ends up duplicating the
> existing one created by switch_to_as1(). Add a check to skip creating
> the temporary entry if already running in AS=1.
> 
> Fixes: d9e1831a4202 ("powerpc/85xx: Load all early TLB entries at once")
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/powerpc/mm/nohash/tlb_low.S | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)

Assuming you've tested this on all combinations of 32/64 relocatable and not:

Acked-by: Scott Wood <oss@buserror.net>

-Scott


