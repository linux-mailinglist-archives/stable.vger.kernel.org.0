Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2C255F657
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 08:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiF2GMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 02:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiF2GMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 02:12:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6BF1C113;
        Tue, 28 Jun 2022 23:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3288BB821B8;
        Wed, 29 Jun 2022 06:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717C6C34114;
        Wed, 29 Jun 2022 06:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656483164;
        bh=jIm0tqTKNujOuxUdc0RFZZRNQYUYfjBOZqjmatJ9GSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MMiSB/S9B3aBzQlxpEkdtaOKo9of17fVDjPTaEFFhd0tmo6ZgixTuwbYk/17l5XQX
         g7GBPj8zQN5FyT6iRkyjO+wW5H/P9mnWsCrrmnsAcj2Kup8PLSify+gFJMZMnnwUow
         BkJnX83zkHvXXG19UCDvowCTIe9X3tF4Pfx4wGPc=
Date:   Wed, 29 Jun 2022 08:12:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     bhelgaas@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        rostedt@goodmis.org, namit@vmware.com, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, er.ajay.kaher@gmail.com
Subject: Re: [PATCH] MMIO should have more priority then IO
Message-ID: <YrvtWVqj/w8V5nIJ@kroah.com>
References: <1656433761-9163-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1656433761-9163-1-git-send-email-akaher@vmware.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 09:59:21PM +0530, Ajay Kaher wrote:
> Port IO instructions (PIO) are less efficient than MMIO (memory
> mapped I/O). They require twice as many PCI accesses and PIO
> instructions are serializing. As a result, MMIO should be preferred
> when possible over PIO.
> 
> Bare metal test result
> 1 million reads using raw_pci_read() took:
> PIO: 0.433153 Sec.
> MMIO: 0.268792 Sec.
> 
> Virtual Machine test result
> 1 hundred thousand reads using raw_pci_read() took:
> PIO: 12.809 Sec.
> MMIO: took 8.517 Sec.
> 
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  arch/x86/pci/common.c          |  8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 3507f456f..0b3383d9c 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -40,20 +40,20 @@ const struct pci_raw_ops *__read_mostly raw_pci_ext_ops;
>  int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
>  						int reg, int len, u32 *val)
>  {
> +	if (raw_pci_ext_ops)
> +		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
>  	if (domain == 0 && reg < 256 && raw_pci_ops)
>  		return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
> -	if (raw_pci_ext_ops)
> -		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
>  	return -EINVAL;
>  }
>  
>  int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
>  						int reg, int len, u32 val)
>  {
> +	if (raw_pci_ext_ops)
> +		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
>  	if (domain == 0 && reg < 256 && raw_pci_ops)
>  		return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
> -	if (raw_pci_ext_ops)
> -		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
>  	return -EINVAL;
>  }
>  
> -- 
> 2.30.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
