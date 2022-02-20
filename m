Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CB94BD0C1
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 19:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242038AbiBTSw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 13:52:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237468AbiBTSw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 13:52:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB74E63;
        Sun, 20 Feb 2022 10:52:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14B2FB80D0F;
        Sun, 20 Feb 2022 18:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF0EC340E8;
        Sun, 20 Feb 2022 18:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645383121;
        bh=LbzbyzDNAbOoCp67yLR40FgOFgKNnLvEN/Fh3HPwgjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V68t634Mt5BuQsMfIhHdKG0/tNNqajVNKGOqe7dpJP93Vqfavl8A36YILvueV/xZq
         cNGrBWFDRX3kWgOmPbBRSgfkyHai2P0etze1HwQDzPP9v2I1j3esxIVH48yWSaUTc5
         3kzP9+1kKJ0cMe15+rWGeA3SFBAyLI3RE5ZkMNTR60u0iAyaJyEWIQykFCBCuDxwG0
         wj8e64S6xAeASkjQ5a+3fqclCVk6AJozz+DES7TMHr1NrC9CJGVLQYjOrWSKbYJOyc
         VBcLBD2GxOTdhhfzKoo/2Z9n9NEPd9z9sB5pWixsWi+JUmAQq/gK0Uew/ddITbEFJt
         blk6tkbcZka4g==
Date:   Sun, 20 Feb 2022 19:52:40 +0100
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <YhKN+LRD2vuhWhqB@iki.fi>
References: <20220108140510.76583-1-jarkko@kernel.org>
 <YfJDV63oGmWOmO4F@iki.fi>
 <8afec431-4dfc-d8df-152b-76cca0e17ccb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8afec431-4dfc-d8df-152b-76cca0e17ccb@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 03:30:52PM -0800, Dave Hansen wrote:
> On 1/26/22 23:01, Jarkko Sakkinen wrote:
> > On Sat, Jan 08, 2022 at 04:05:10PM +0200, Jarkko Sakkinen wrote:
> >> +static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
> >> +{
> >> +	return PFN_DOWN(encl->size) + 1 + (index / sizeof(struct sgx_pcmd));
> >> +}
> > Found it.
> > 
> > This should be 
> > 
> > static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
> > {
> > 	return PFN_DOWN(encl->size) + 1 + (index * PAGE_SIZE) / sizeof(struct sgx_pcmd);
> > }
> 
> I've looked at this for about 10 minutes and been simultaneously
> confused as to whether it is right or wrong.  That makes it
> automatically wrong. :)
> 
> First, this isn't calculating a "PCMD number".  It's calculating backing
> offset.  The "PCMD number" calculation is only a part of it.  I think
> that makes the naming rather sloppy.
> 
> Second, I think the typing is sloppy.  page_index for example:
> 
> > static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >                            struct sgx_epc_page *epc_page,
> >                            struct sgx_epc_page *secs_page)
> > {
> ...
> >         pgoff_t page_index;
> 
> It's storing a page number:
> 
>                 page_index = PFN_DOWN(encl->size);
> 
> not a real offset-into-a-file.  That makes it even more confusing when
> 'page_index' crosses a function boundary, gets renamed to 'index' and
> then its units get confused.
> 
> /*
>  * Given a page number within an enclave (@epc_page_nr), calculate the
>  * offset in bytes into the backing file where that page's PCMD is
>  * located.
>  */
> -static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl
> *encl, pgoff_t index)
> +static inline pgoff_t sgx_page_nr_to_pcmd_nr(struct sgx_encl *encl,
> unsigned long epc_page_nr)
> {
> 	pgoff_t last_epc_offset = PFN_DOWN(encl->size);
> 	pgoff_t pcmd_offset;
> 
> 	// The SECS page is stashed in a slot after the
> 	// last normal EPC page.  Leave space for it:
> 	last_epc_offset++;
> 
> 	pcmd_offset = epc_page_nr / sizeof(struct sgx_pcmd);
> 
> 	return last_epc_offset + pcmd_offset;
> }
> 
> Looking at that, I still think your *original* version is correct.
> 
> Am I just all twisted around from looking at this code too much?  Could
> you please take another look and send a new version of the patch?

Yeah, I will. It took me two weeks to make full remote attestation
implementation for SGX in Rust but at least I can confirm that all
the kernel bits work on that (and this will also help me to finish
the man page because it is pretty nasty to document it if you haven't
gone to the rabbit hole yourself).

I'll prioritize now to get SGX2 patches tested with Enarx implementation
but this 2nd thing in my kernel queue.

/Jarkko
