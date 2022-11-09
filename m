Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C1F622EEB
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 16:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiKIPUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 10:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiKIPUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 10:20:07 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8841D677
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 07:20:05 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b21so17374593plc.9
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 07:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x9teoJ5wje0VkvVwfbh872sgK0WyIimofXUzASdDvqA=;
        b=SHtyJHGvJeg5P42AZAxJL4cIAhjRarkT+Cu6YbFyPk9onbab5/HQtm1iHGWnZlR61s
         afoyV/6v11Ql85YbQFKudmE5nQSMHREIGmM3Nvo6jh7OVUVSh8LzTUt3IkGJXwmKqKT6
         WRafW2EzCe146gR5GvJj72BUidMgPVoF+yEWGt0c7TkGTPWaf1rGAfboRncdC5tHxa1R
         g3rg7fPIjGpHYKgCGG+AnwUVo6RCvczl/5KW4eRQHkSiBb0ZPjjXpV7NK8Hv1CZUBgEL
         2ecpbyBnzlU7lbJVbTKuVSMyO2e10d7gKMGfZx2UimOIYgvU2KpzV5LTwUy8l7jFFihw
         yAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9teoJ5wje0VkvVwfbh872sgK0WyIimofXUzASdDvqA=;
        b=t/B1vPSh86ABz0MFfklOz7B4qPO2KURjrhAHmZAlTG5UFi/nQ0g7eoohF7GAwhZudc
         Q7+GWNd5yG2SxFyLo7cGZQ4FjqKFC/SD49rTckvyz/HmDCCg5HbeVRcy3T8bC6EanMy8
         t75saNVU/PR7LUG59ndE1/Sfey2Qc3Nuu7TmsraIme2D6DUnzJ6GbH7wR4iRYZFNraoZ
         0az/V4RwpaoU3tU4APxlE4mU6qS9oO3t0R48GlgR2BEIT/EHNsxs238TjbqE91DGw7xv
         MMh8KYbGmrE3/jBKGUFd1bTSad4MmLZBM782Jceo0iAfnin/pBh0XIjvS8JMKsKclDsx
         s5Ug==
X-Gm-Message-State: ACrzQf20vYyt9UHWVvJyaJ0VyvUQKyhn+FD5mGYh3DbCBbUdiQEShIZT
        OJgQiTJIaXHqpQ4ukl48okcd6Q==
X-Google-Smtp-Source: AMsMyM4boMHPt76cAxey5Fe/JfDpSNTYBXnZkeYQ19CkhPccng6LpwJObfa7wg8zMbWlv4QcuAmfNw==
X-Received: by 2002:a17:902:ab89:b0:186:7cfc:cde8 with SMTP id f9-20020a170902ab8900b001867cfccde8mr62403327plr.9.1668007205217;
        Wed, 09 Nov 2022 07:20:05 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y15-20020a1709027c8f00b0017854cee6ebsm9219777pll.72.2022.11.09.07.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 07:20:04 -0800 (PST)
Date:   Wed, 9 Nov 2022 15:20:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, jmattson@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 03/11] KVM: SVM: adjust register allocation for
 __svm_vcpu_run
Message-ID: <Y2vFIR+T+9SFY0xO@google.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
 <20221109145156.84714-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109145156.84714-4-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022, Paolo Bonzini wrote:
> In preparation for moving vmload/vmsave to __svm_vcpu_run,

__svm_vcpu_run()

> keep the pointer to the struct vcpu_svm in %rdi.  This way
> it is possible to load svm->vmcb01.pa in %rax without
> clobbering the pointer to svm itself.

If you feel like doing fixup before pushing, add a note to call out that avoiding
RAX will also be "necessary" to play nice with loading/storing MSR_SPEC_CTRL?
When fiddling with this code, I found the RDMSR/WRMSR clobbers to be far more
problematic than the VMCB pointers.

> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
