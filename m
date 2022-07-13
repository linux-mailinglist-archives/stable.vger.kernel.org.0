Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29826573882
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 16:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbiGMOMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 10:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiGMOMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 10:12:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1F032EC9;
        Wed, 13 Jul 2022 07:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wGRPtxM9zwJmyc5jc5elK4XE4EFRYrearKDZedH3sTg=; b=Z4A+w2PH9rZGkZa1+jFMumRm4R
        8JDguw6Sbit9O1V65ZDAPzRELm91U/PbJsV4AFPD30IdPTRL56sLpWv8e7fhuABFvOHUeAWWOTUJw
        FjLUI77YIqr8N7i6FOBGsVo6tti6QRrIatCQhIRjtWLVc6oUNaWaWi3ve3kCXzmvN/id8m3Sq3H5W
        FXsqV8L9L+fRNVtMlLo4KgpZgIky2yGzVByls6IqBSGkpZqRbGx+Z+ehGgSc8pR+YCEN4JwjPAk34
        WQp4hzRkmIffrCel9ogdZtu2uzQ+U78SOXT2HKTyMMqly1sIuxoPrd4Z2JDE/Uzz+QIZHZMlm2oO5
        uIDJS7nA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBd68-003aDZ-Ui; Wed, 13 Jul 2022 14:12:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C3B25300238;
        Wed, 13 Jul 2022 16:12:13 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AD62A20595D02; Wed, 13 Jul 2022 16:12:13 +0200 (CEST)
Date:   Wed, 13 Jul 2022 16:12:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
Message-ID: <Ys7Sved3UZOtzJLf@hirez.programming.kicks-ass.net>
References: <20220712183236.931648980@linuxfoundation.org>
 <CA+G9fYvRQ9gzee8pjRmsyedz6oGyh5pzSYEPkuDoKEE+X2RZDg@mail.gmail.com>
 <Ys7Cm17ShWUOXkRw@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys7Cm17ShWUOXkRw@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 03:03:23PM +0200, Greg Kroah-Hartman wrote:

> > 2) qemu_x86_64 boot warning
> >    - WARNING: CPU: 0 PID: 0 at arch/x86/kernel/alternative.c:558
> > apply_returns+0x19c/0x1d0
> 
> Warning, but does everything still work?
> 
> And again, still on Linus's tree?

Working on it: https://lkml.kernel.org/r/Ys66hwtFcGbYmoiZ@hirez.programming.kicks-ass.net
