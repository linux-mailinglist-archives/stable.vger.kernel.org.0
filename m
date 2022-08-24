Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6859F5A0193
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 20:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbiHXSsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 14:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235430AbiHXSsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 14:48:54 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C5D7AC29;
        Wed, 24 Aug 2022 11:48:53 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9859329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9859:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1F7DD1EC0589;
        Wed, 24 Aug 2022 20:48:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1661366928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=WK0v1hXG889a9fqR0dwBxVsBZk9FUHaTtJZfPydUhIc=;
        b=pqc6eljUoZBxhlQgJ2cDUW+RwMQZhRdZ1mo8y3pqZKKKvvGBXhK38x2By3ZTBXhsRdXiJl
        yZY8O9TbYmwKKqC2xzAFirjjOaUzktvF15qckD8yWgmTXaaHBH58L/aBc/rhFzLLqc29PT
        yp+B98UZgihGoEdu8p8pRdaIJaZvcx0=
Date:   Wed, 24 Aug 2022 20:48:44 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Asish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] x86/sev: Don't use cc_platform_has() for early SEV-SNP
 calls
Message-ID: <YwZyjE6BmnvxHXcR@zn.tnic>
References: <0c9b9a6c33ff4b8ce17a87a6c09db44d3b52bad3.1661291751.git.thomas.lendacky@amd.com>
 <10bc452f-3564-e41b-836d-e135a8f4260d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <10bc452f-3564-e41b-836d-e135a8f4260d@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 11:43:10AM -0700, Dave Hansen wrote:
> So, we don't have *ANY* control over where the compiler uses jump
> tables.  The kernel just happened to add some code that uses them, fell
> over, and this adds a hack to get booting again.
> 
> Isn't this a bigger problem?

I had the same question already. Was thinking of maybe disabling
the compiler from producing jump tables in the ident-mapped code.
Tom's argument is that that might prevent the compiler from doing
optimizations but I haven't talked to compiler folks whether those
optimizations are even worth the effort.

Regardless, the potential problem is limited:

"# (jump-tables are implicitly disabled by RETPOLINE)"

i.e., only RETPOLINE=n builds for now which should be a minority?

I guess when this explodes somewhere else again, we will have to
generalize a fix.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
