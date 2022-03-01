Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453A74C8A3E
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 12:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiCALDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 06:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiCALDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 06:03:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48AD63BDA;
        Tue,  1 Mar 2022 03:03:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46EC3B817A9;
        Tue,  1 Mar 2022 11:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7B9C340EE;
        Tue,  1 Mar 2022 11:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646132583;
        bh=s3AyX5haQ6VBA5pNSp/kFJK06ZJoccCHONGNMZ47+Z0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M93Z3h3QCJ/5SN+x4+sQ9dePM6ZeoZDUgHPeVlBkD4FLd6EpLvivvZqJZ70IN7+uc
         5r2wLM6NaxCZM1dpLU8mf2PCT+3kdG1K7varUEyeRX1YPI2jtktWEAnmkiHhorl1eO
         VRqD/lJEGEIM0e5ZsvbTH0zWhzetbdxgzsu9I4y4Ykv0QJZXy+z6ad1lvdYKQvC18G
         bSlFbx9FXmgJa1OuHo8PR7LqrGfbt01MBzvrOu1001MdgT+KLSbcCYWv5a4g2NqdL9
         VxxgQLcm/SH8Ux5h4j5KBoCFq3trI5zL4akmFibJsv5BXBaWXAIkiAz0Vy4oO0Mau2
         1ASioE9qDjc9A==
Date:   Tue, 1 Mar 2022 12:03:46 +0100
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
Message-ID: <Yh39kuf8kuZJ0pRJ@iki.fi>
References: <20220222120342.5277-1-jarkko@kernel.org>
 <33646f1e-da44-503a-c454-02658d512926@intel.com>
 <YhzGS+x0eNoc3gyN@iki.fi>
 <0e06910b-9313-94ae-11e3-10a2b14645f2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e06910b-9313-94ae-11e3-10a2b14645f2@intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 07:32:02AM -0800, Dave Hansen wrote:
> On 2/28/22 04:55, Jarkko Sakkinen wrote:
> > I thought that the formula is so simple that it does not matter if it is
> > just in two sites open coded but I can wrap it too, if required, e.g.
> > 
> > /* 
> >  * Calculate byte offset of a PCMD struct associated to an enclave page.
> >  * PCMD's follow right after the EPC data in the backing storage. In
> >  * addition to the visible enclave pages, there's one extra page slot
> >  * for SECS, before PCMD data.
> >  */
> > static pgoff_t *sgx_encl_page_index_to_pcmd_offset(struct sgx_encl *encl, unsigned long page_index)
> > {
> >         return encl->size + PAGE_SIZE + page_index * sizeof(struct sgx_pcmd);
> > }
> 
> Yes, it's required.  Please wrap it.
> 
> There's also nothing wrong with spreading that calculation across
> several lines.  It may be arithmetically simple, but it's combining
> three or four logical steps.  There's no shame in separating and
> commenting some of those separately.

I can do that but one thing that would make this more documentative would
be to describe the formula as "encl->size + sizeof(struct sgx_secs) +
sizeof(struct sgx_pcmd)", i.e. PAGE_SIZE is a magic number so the
end result would be:

/* 
 * Calculate byte offset of a PCMD struct associated to an enclave page. PCMD's
 * follow right after the EPC data in the backing storage. In addition to the
 * visible enclave pages, there's one extra page slot for SECS, before PCMD
 * structs.
 */
static inline pgoff_t sgx_encl_page_index_to_pcmd_offset(struct sgx_encl *encl, unsigned long page_index)
{
        pgoff_t epc_end_off = encl->size + sizeof(struct sgx_secs);

        return epc_end_off + page_index * sizeof(struct sgx_pcmd);
}

Now it is hard to get this wrong and also the file offset has the nice quality
of packing the page index for PCMD page, and offset within that page. IMHO,
this will nice and clean long-term way to sort this out.

/Jarkko
