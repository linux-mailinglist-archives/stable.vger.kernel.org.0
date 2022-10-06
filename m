Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A2D5F626F
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 10:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiJFIS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 04:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiJFISz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 04:18:55 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6AA915CD;
        Thu,  6 Oct 2022 01:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jOhCFAz+ABqsadoAqIKbU6KkvClItnh/UukBSjxVbpk=; b=Fq/usoT/YTGMcqrNpDi93XTmQ7
        7jbS3Z8J1h27pAQ4sebkerq0/zN29g71dn5yRGUMJIgM8ycySLRWoeFq3bpJtIr3hjqPyxmTj+ONA
        q7W0WtUsD9p05URs35lnEd2f1ZggyKWairVQW6YJA5Dfqsaa+9HBu+0hqDJUtFYaOrSyRnX+GBbB3
        XpHX1VwsTAD5arR95bQEQ+Obt4eKUglJ9BHRIWecwVxqFSRUeelUcxohzaUz3LtHvTD2CJOvZLrbI
        mziNafed1Gpljf1HkSgNjMcjw1E7NSBZSlGoXndQLdYBApn+Fr72cJcMFKT/7L3O7ZTsEPySK6xKL
        l1MwJJpQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ogM5J-001C09-SQ; Thu, 06 Oct 2022 08:18:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6015C30007E;
        Thu,  6 Oct 2022 10:18:24 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 31EE82010D7AA; Thu,  6 Oct 2022 10:18:24 +0200 (CEST)
Date:   Thu, 6 Oct 2022 10:18:24 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jim Mattson <jmattson@google.com>
Cc:     Suraj Jitindar Singh <surajjs@amazon.com>, kvm@vger.kernel.org,
        sjitindarsingh@gmail.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@suse.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, jpoimboe@kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        benh@kernel.crashing.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
Message-ID: <Yz6PUJqThY9NPHRs@hirez.programming.kicks-ass.net>
References: <20221005220227.1959-1-surajjs@amazon.com>
 <CALMp9eThzv+5UBPtm77nvD_b48hHD7O1QLni7a+x9zAPicFk4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eThzv+5UBPtm77nvD_b48hHD7O1QLni7a+x9zAPicFk4Q@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 04:46:12PM -0700, Jim Mattson wrote:

>                 rmb();

Since we're not doing memory ordering but speculation hardening, this is
completely the wrong way to spell LFENCE. Please use barrier_nospec() in
those cases.

And as has already been pointed out, there's one of those just two lines
down already.

Also, what Andrew said.
