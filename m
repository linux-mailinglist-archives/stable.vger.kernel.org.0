Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A263C6BBD82
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 20:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbjCOTpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 15:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbjCOTpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 15:45:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C696EA7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4890061E4A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 19:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7996C43442;
        Wed, 15 Mar 2023 19:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909509;
        bh=+l9QBG9R0KNl4Qa3G0gMxX50q5jers5CRGPYlimlPsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EWLObe8rubG2ThERRLLgIDyhR/1067agzh4EMRw7QHr6HCDdsjO+4sB6oLWNxuzF6
         mVyQnf5JcgZgPa7RUEUPyQ6AL0x3lnpO/vWOZsT/e2ifZbEaInY5MRa+6tUkefC6nE
         wmLPeqT/zX6PeNLW9N6mbg/TU7t3FI/nxRuJ3shA=
Date:   Wed, 15 Mar 2023 12:45:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     wenyang.linux@foxmail.com, Sasha Levin <sashal@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Christoph Hellwig <hch@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Feng Tang <feng.tang@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] kexec: move locking into do_kexec_load
Message-Id: <20230315124508.e870a06008d028fb0df7a153@linux-foundation.org>
In-Reply-To: <ZBF5vkkwB+qs2GlS@kroah.com>
References: <tencent_FE90DDE46BFA03B385DFC4B367953D357206@qq.com>
        <ZBF5vkkwB+qs2GlS@kroah.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Mar 2023 08:54:38 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, Mar 02, 2023 at 12:18:04AM +0800, wenyang.linux@foxmail.com wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > commit 4b692e861619353ce069e547a67c8d0e32d9ef3d upstream.
> > 
> > Patch series "compat: remove compat_alloc_user_space", v5.
> > 
> > Going through compat_alloc_user_space() to convert indirect system call
> > arguments tends to add complexity compared to handling the native and
> > compat logic in the same code.
> > 
> > This patch (of 6):
> 
> What about the other 6?
> 
> And what kernel is this going to, just 5.10.y?
> 
> Can you resend this as an actual patch series linked together?  They do
> not show up properly for some reason (same for your 5.15.y patches.)
> 
> Try using git send-email to send them out.
> 

Well...  what bugs does this series fix?  I originally saw nothing
indicating that a backport was needed.
