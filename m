Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071E56D91F9
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 10:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDFIui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 04:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbjDFIuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 04:50:37 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6337A4EE2;
        Thu,  6 Apr 2023 01:50:35 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pkLK5-00D1xX-DF; Thu, 06 Apr 2023 16:50:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Apr 2023 16:50:25 +0800
Date:   Thu, 6 Apr 2023 16:50:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Clear PSP interrupt status register before
 calling handler
Message-ID: <ZC6H0Y7ERWV2c6AN@gondor.apana.org.au>
References: <20230328151636.1353846-1-jpiotrowski@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328151636.1353846-1-jpiotrowski@linux.microsoft.com>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 03:16:36PM +0000, Jeremi Piotrowski wrote:
> The PSP IRQ is edge-triggered (MSI or MSI-X) in all cases supported by
> the psp module so clear the interrupt status register early in the
> handler to prevent missed interrupts. sev_irq_handler() calls wake_up()
> on a wait queue, which can result in a new command being submitted from
> a different CPU. This then races with the clearing of isr and can result
> in missed interrupts. A missed interrupt results in a command waiting
> until it times out, which results in the psp being declared dead.
> 
> This is unlikely on bare metal, but has been observed when running
> virtualized. In the cases where this is observed, sev->cmdresp_reg has
> PSP_CMDRESP_RESP set which indicates that the command was processed
> correctly but no interrupt was asserted.
> 
> The full sequence of events looks like this:
> 
> CPU 1: submits SEV cmd #1
> CPU 1: calls wait_event_timeout()
> CPU 0: enters psp_irq_handler()
> CPU 0: calls sev_handler()->wake_up()
> CPU 1: wakes up; finishes processing cmd #1
> CPU 1: submits SEV cmd #2
> CPU 1: calls wait_event_timeout()
> PSP:   finishes processing cmd #2; interrupt status is still set; no interrupt
> CPU 0: clears intsts
> CPU 0: exits psp_irq_handler()
> CPU 1: wait_event_timeout() times out; psp_dead=true
> 
> Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
