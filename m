Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9305B640BD4
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 18:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiLBRKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 12:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiLBRKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 12:10:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25023E3453;
        Fri,  2 Dec 2022 09:10:19 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670001017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QhR5YLd5BfIgI1MjKZbs02SuSNQnZhjwBK1D68xgBC4=;
        b=mia0uP4FM6Ytx078LoMw3+vpoIT3glY7aUosPPaGCh+7pA32Xk/4p+e5xNUM7Z8Yb9RB1s
        wVPyxqaEDrnEkVHbgh8J1jdf30z4NA1T6b9AnCmZ//KoXLD+IkgVhdlm5b7Ii/9z8x/ryZ
        2DnC2SF6rAgYgL+FywIdFTPQY9bzBI5lPXVlqI5/UKwPpl7byeF1PbrT3pd7sAeWjgoOm9
        eLS5MjtzJu05cNXv6YYJcsu2lc1Lx7QyqNU3/Hi2HVfX9m2u+cB3XL6UeydKYyV+v0e8sw
        YiS5lGF+CpdnbW2Hivh/X4drTZsqWUJm2DteHh57TWHJ8EOPdT1Wf/jm78FEbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670001017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QhR5YLd5BfIgI1MjKZbs02SuSNQnZhjwBK1D68xgBC4=;
        b=FdhGW6DpcJOKSFuOYV/Gm5eBIKv7qTcKkqe5mqG09y5wZY3BL/xgV5c9ZtXpsG7P6NSmhU
        cnvkYBoa5F4PwNBw==
To:     Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4 0/4] x86/crash: Fix double NMI shootdown bug
In-Reply-To: <20221130233650.1404148-1-seanjc@google.com>
References: <20221130233650.1404148-1-seanjc@google.com>
Date:   Fri, 02 Dec 2022 18:10:16 +0100
Message-ID: <87lenppw93.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30 2022 at 23:36, Sean Christopherson wrote:

> Fix a double NMI shootdown bug found and debugged by Guilherme, who did all
> the hard work.  NMI shootdown is a one-time thing; the handler leaves NMIs
> blocked and enters halt.  At best, a second (or third...) shootdown is an
> expensive nop, at worst it can hang the kernel and prevent kexec'ing into
> a new kernel, e.g. prior to the hardening of register_nmi_handler(), a
> double shootdown resulted in a double list_add(), which is fatal when running
> with CONFIG_BUG_ON_DATA_CORRUPTION=y.
>
> With the "right" kexec/kdump configuration, emergency_vmx_disable_all() can
> be reached after kdump_nmi_shootdown_cpus() (currently the only two users
> of nmi_shootdown_cpus()).
>
> To fix, move the disabling of virtualization into crash_nmi_callback(),
> remove emergency_vmx_disable_all()'s callback, and do a shootdown for
> emergency_vmx_disable_all() if and only if a shootdown hasn't yet occurred.
> The only thing emergency_vmx_disable_all() cares about is disabling VMX/SVM
> (obviously), and since I can't envision a use case for an NMI shootdown that
> doesn't want to disable virtualization, doing that in the core handler means
> emergency_vmx_disable_all() only needs to ensure _a_ shootdown occurs, it
> doesn't care when that shootdown happened or what callback may have run.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
