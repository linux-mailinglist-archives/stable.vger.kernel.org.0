Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24EC4C6D3E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 13:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiB1Mzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 07:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiB1Mzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 07:55:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B82E76E0C;
        Mon, 28 Feb 2022 04:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A96D2B8112D;
        Mon, 28 Feb 2022 12:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76CDC340EE;
        Mon, 28 Feb 2022 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646052900;
        bh=Xmuf1eL68pU4DmpFVDTtZDXTAA5H0aTtLv3dpQ/Q6N4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=StUkJjrXr26DVsItWgn+XwP8DKEhpOHwTd22e7zZm7HJx8KRf1mG8XcsqDMzQvV9v
         hpGKgxewowjUALw+9kA5U/+r6+rrKZUVQVuTgFzheHXOv8Yu9o3iNhT3UE5TMO0Y5m
         YflI+/5m5HDC2NAXdW9NcO03CaxpuIEWOLMVELxfoQBBmE4QSThuIvIgf9fR0wL3rO
         HlW0yIqNMasJ8Ltf84xuhikoElEjrOMc+C2Xm+04cdWvfsLNkZkahVz2BoZ9fqy6QU
         xZE4HJXjYDa+OjgU33DtxNXFsvWXlJbbAHMKZt8e+14eErpTPwtOUTFI25AODju+mF
         oFveaCER83GJg==
Date:   Mon, 28 Feb 2022 13:55:39 +0100
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <YhzGS+x0eNoc3gyN@iki.fi>
References: <20220222120342.5277-1-jarkko@kernel.org>
 <33646f1e-da44-503a-c454-02658d512926@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33646f1e-da44-503a-c454-02658d512926@intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 09:14:05AM -0800, Dave Hansen wrote:
> On 2/22/22 04:03, Jarkko Sakkinen wrote:
> > +	if (pcmd_page_empty) {
> > +		pgoff_t pcmd_off = encl->size + PAGE_SIZE /* SECS */ +
> > +				   page_index * sizeof(struct sgx_pcmd);
> > +
> > +		sgx_encl_truncate_backing_page(encl, PFN_DOWN(pcmd_off));
> > +	}
> > +
> >  	return ret;
> >  }
> >  
> > @@ -583,7 +613,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
> >  static int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
> >  				struct sgx_backing *backing)
> >  {
> > -	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> > +	pgoff_t pcmd_off = encl->size + PAGE_SIZE /* SECS */ + page_index * sizeof(struct sgx_pcmd);
> 
> Jarkko, I really don't like how this looks.  The '/* SECS */' thing is
> pretty ugly and the comment in the middle of an arithmetic operation is
> just really hard to read.
> 
> Then, there's the fact that this gem is copied-and-pasted.  Oh, and it
> looks a wee bit over 80 columns.

Today you can have 100.

> 
> I went to the trouble of writing a nice, fully-fleshed-out helper
> function for this with a comment included:
> 
> > https://lore.kernel.org/all/8afec431-4dfc-d8df-152b-76cca0e17ccb@intel.com/

Keeping full byte offset up until parts of it are required for something
makes the formula just a simple equation of additions and multiplications,
e.g. nothing like "/ sizeof(struct sgx_pcmd)" is required.

Then you get the PCMD page index will be just PFN_DOWN(pcmd_off) and offset
inside that page is pcmd_off & PAGE_MASK. At least fro me this is more 
intuitive way to do the calculations.
 
I thought that the formula is so simple that it does not matter if it is
just in two sites open coded but I can wrap it too, if required, e.g.

/* 
 * Calculate byte offset of a PCMD struct associated to an enclave page.
 * PCMD's follow right after the EPC data in the backing storage. In
 * addition to the visible enclave pages, there's one extra page slot
 * for SECS, before PCMD data.
 */
static pgoff_t *sgx_encl_page_index_to_pcmd_offset(struct sgx_encl *encl, unsigned long page_index)
{
        return encl->size + PAGE_SIZE + page_index * sizeof(struct sgx_pcmd);
}

> 
> Was there a problem using that?  The change from the last version is:
> 
> * Sanitized the offset calculations.
> 
> Given that there have been multiple different calculations over the four
> versions so far, which version was right?  v3 or v4?

This one has correct and tested calculations but for peer test probably
Reinette should verify that. I tested this with my laptop in bare metal.

BR, Jarkko
