Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2D94C9AA2
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 02:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbiCBBlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 20:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiCBBlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 20:41:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB78A1BE8;
        Tue,  1 Mar 2022 17:40:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C13BB81BEA;
        Wed,  2 Mar 2022 01:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76B5C340EE;
        Wed,  2 Mar 2022 01:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646185252;
        bh=t7b7XBlaSW5C/zrCE4sLY8sBYlVGnx0VRe90U0a1Cy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l3lTt8RMP2oSRblhVvuP/nR4t/f5RP5+dKwTfzyAbQLkLM4vYMpAbJi0fUWGfwBys
         WfrKmrTRN8b0ISJTN/m86zV74A7TWcU5T0vLRq3wkvaZkUX06hqPYlVlsg/h1ujrOQ
         tdZU7LUgSMB4/5vPlwDbVdITsVtOAJjjzkgW2GP0BUMkwNyQJB4A3/zzJculY7sXfg
         GjV4atlpSv7E7dy7ipGz26JmvlNTrpNqQMXhBV5FOlZX0ejmbR3A3icA8epoqvJYHs
         myfzsMdAxzUd6ZRXo2kIVVvSjndwL8xKbCHmxaiBYy3JVbaDoNsjfh6XqcmS/WRaJP
         RPJP7jGfou74Q==
Date:   Wed, 2 Mar 2022 02:41:37 +0100
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
Subject: Re: [PATCH v5] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <Yh7LUU401weiq0ew@iki.fi>
References: <20220301125836.3430-1-jarkko@kernel.org>
 <3a083b4d-9645-dec6-8cdc-481429dd0a1f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a083b4d-9645-dec6-8cdc-481429dd0a1f@intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 01, 2022 at 09:54:14AM -0800, Dave Hansen wrote:
> On 3/1/22 04:58, Jarkko Sakkinen wrote:
> > @@ -32,14 +58,16 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  	else
> >  		page_index = PFN_DOWN(encl->size);
> >  
> > +	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
> > +
> >  	ret = sgx_encl_lookup_backing(encl, page_index, &b);
> >  	if (ret)
> >  		return ret;
> 
> What tree is this against?  It looks like it might be on top of
> Kristen's overcommit series.
> 
> It would be best if you could test this on top of tip/sgx.  Kristen
> changed code in this area as well.

I rebased this against latest stuff and now I did a sanity check:

$ git fetch tip
remote: Enumerating objects: 75, done.
remote: Counting objects: 100% (75/75), done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 77 (delta 65), reused 65 (delta 63), pack-reused 2
Unpacking objects: 100% (77/77), 34.07 KiB | 157.00 KiB/s, done.
From git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
   161a9a33702a..cedd3614e5d9  perf/core  -> tip/perf/core
   6255b48aebfd..25795ef6299f  sched/core -> tip/sched/core

$ git rebase tip/x86/sgx 
Current branch master is up to date.

BR, Jarkko
