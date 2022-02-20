Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3514BD12F
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 21:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiBTUJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 15:09:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiBTUJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 15:09:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16E74C424;
        Sun, 20 Feb 2022 12:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56F38B80DBF;
        Sun, 20 Feb 2022 20:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5402AC340E8;
        Sun, 20 Feb 2022 20:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645387725;
        bh=DhetoqoN1bQhE470buT/GVnwjIyJoyikQ9zpkEijeOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=syRskMMvwodSY+IksRqwKxVATeoGUHVDeg3Div3p3y6fy+hqj6twSBflY12UNaH0R
         +7LpN+B6KuyWpBxcYKGFBUHBH83ZhFfJvrcCgSJw03GyrHabH6pQi0Jh/NsSXQHfGX
         N/Z6qiScEZiBlx0nJLzzmSBqrAQYP88YCMWlhenLHokWYDY/Ac0mTZEW4ZzI2RMf4U
         33CzErzYtnltTNvrVP5QkotUw70uwwbIlmkqEFRDNVjhRfnC517/FtMi2w0VaC0eZ4
         s1nXgA3uaTYORUXEFBn21vTZbf7C+mI+d5JEikX59DRO3OIhHma0jL3xEoNhvC6Sty
         xEanaeGwrBBeA==
Date:   Sun, 20 Feb 2022 21:09:22 +0100
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
Message-ID: <YhKf8gwdE8tyPTOA@iki.fi>
References: <20220108140510.76583-1-jarkko@kernel.org>
 <YfJDV63oGmWOmO4F@iki.fi>
 <8afec431-4dfc-d8df-152b-76cca0e17ccb@intel.com>
 <YhKN+LRD2vuhWhqB@iki.fi>
 <bf6654d9-572b-3423-59a0-c17112f75792@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf6654d9-572b-3423-59a0-c17112f75792@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 20, 2022 at 10:58:00AM -0800, Dave Hansen wrote:
> On 2/20/22 10:52, Jarkko Sakkinen wrote:
> >> Am I just all twisted around from looking at this code too much?  Could
> >> you please take another look and send a new version of the patch?
> > Yeah, I will. It took me two weeks to make full remote attestation
> > implementation for SGX in Rust but at least I can confirm that all
> > the kernel bits work on that (and this will also help me to finish
> > the man page because it is pretty nasty to document it if you haven't
> > gone to the rabbit hole yourself).
> > 
> > I'll prioritize now to get SGX2 patches tested with Enarx implementation
> > but this 2nd thing in my kernel queue.
> 
> I really prioritize bug fixes over new features.  New features can's
> really get merged until this gets fixed up.

Fair enough. In this case I was not exactly sure whether it is categorized
as bug or enhancement. Should I also put a fixes tag to this to the
original reclaimer code (since it has been like this since the epoch)?

BR, Jarkko
