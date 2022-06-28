Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C0255EC39
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiF1SJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbiF1SJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:09:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D8418E33;
        Tue, 28 Jun 2022 11:09:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4C47B81F38;
        Tue, 28 Jun 2022 18:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7D3C3411D;
        Tue, 28 Jun 2022 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656439761;
        bh=ZM4K8CdrCdhFvd7sEv3qGYIHF7dGlpXMr3HUPGu67Kk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=cY69CLVM0FHX00SCURHz0in/P2rf4Uf1LF9t0/6qyO8eAIgcP/4qvC/eqwHggNdsF
         dND86lRkvNtjwu/E5u1y4IBT9BdXziLxeZfUCR7jEmI4S/WltsYkNtaetZi9ViFsjU
         EpAoMcYRuq/XcA6hhVJw3ckUgj4RN8+SQg89TW/Rcoi6IW4rXS1V3NA8RQ4brO6ASh
         dkBiT/AwPMtIVf7An3aSIPVkkAeXv2H4fea2/imZpE3CJmq8NdUqZIvth/fpwaNNvW
         +L0dQqakDJA0H75f+FSKNi1MLesZ+9+rT+nqXlxj7Wx34y4ERjws/NGHoYPXok+UrO
         Oehr7b5pjfF4Q==
Date:   Tue, 28 Jun 2022 13:09:19 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     bhelgaas@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        rostedt@goodmis.org, namit@vmware.com, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, er.ajay.kaher@gmail.com,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] MMIO should have more priority then IO
Message-ID: <20220628180919.GA1850423@bhelgaas>
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

[+cc Matthew]

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

This organization of raw_pci_read() dates to b6ce068a1285 ("Change
pci_raw_ops to pci_raw_read/write"), by Matthew.  Cc'd him for
comment, since I think he considered the ordering at the time.

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
