Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D12A5E754B
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 09:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiIWH6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 03:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiIWH6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 03:58:31 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB5812E407;
        Fri, 23 Sep 2022 00:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OBb/Vyt/knoHoeVbmT/onk2LeOhkHBZeeIy4HQ7B610=; b=kbx8x+vJdxxg0SYtDk6TZ/8TQ0
        LRgsxJZK09kxU4gmM2WloCSBDUu4eSWhSD4GWQXXHQTmkESIqSLqInRQCVl+N98wZqz+lvMK7Gohh
        lGEaPydkRwFl0hvrvnc+OAIp1oT07orwd6jaiouTzuYj/o9bd1VflVdaf42S50eCYqBtezEK8N0qB
        EI85G4Dzlkg1aWZSVGWmcNplNbVOrJ6Gfn8Fsc8VQexstnwQamqQOirbg+SSMQm1Q4sAIf/3f9NPW
        lAt1/dKXB7IKFHQLKijTg+0jw5jLSlunoSIHlGlrfgB0hGHgaXQKHv5Ta7qMhuv5en7RHhWppGVK/
        E6EC9rYA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obdZI-00FAQd-33; Fri, 23 Sep 2022 07:57:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 386193001FD;
        Fri, 23 Sep 2022 09:57:51 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1970C207C83B0; Fri, 23 Sep 2022 09:57:51 +0200 (CEST)
Date:   Fri, 23 Sep 2022 09:57:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andreas Mohr <andi@lisas.de>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        puwen@hygon.cn, mario.limonciello@amd.com, rui.zhang@intel.com,
        gpiccoli@igalia.com, daniel.lezcano@linaro.org,
        ananth.narayan@amd.com, gautham.shenoy@amd.com,
        Calvin Ong <calvin.ong@amd.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <Yy1m/5topydhbWS2@hirez.programming.kicks-ass.net>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
 <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
 <Yyy6l94G0O2B7Yh1@rhlx01.hs-esslingen.de>
 <YyzBLc+OFIN2BMz5@rhlx01.hs-esslingen.de>
 <4d61b9c0-ee00-c5f6-bef1-622b80c79714@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d61b9c0-ee00-c5f6-bef1-622b80c79714@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 02:21:31PM -0700, Dave Hansen wrote:
> FWIW, I'd much rather do something like
> 
> 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
> 	    (boot_cpu_data.x86_model >= 0xF))
> 		return;
> 
> 	inl(slow_whatever);
> 
> than a Zen check.  AMD has, as far as I know, been a lot more sequential
> and sane about model numbers than Intel, and there are some AMD model
> number range checks in the codebase today.

Some might be broken; apparently their SoC/Entertainment divisions has a
few out of order SKUs that were not listed in their regular documents.
(yay interweb)

I ran into this when I tried doing a Zen2 range check for retbleed. In
the end we ended up using the availablility of STIBP as a heuristic to
indentify Zen2+ or something.
