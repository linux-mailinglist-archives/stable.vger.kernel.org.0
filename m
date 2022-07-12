Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFEF572015
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiGLP6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiGLP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:58:46 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3C2A46F
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 08:58:43 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 73so7933760pgb.10
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 08:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3NuNGzPX7l2+4H4FqXMF3G2Iv4qIhgXKrczFI5RGpVE=;
        b=KobxG4F8v+qthtwpu7gbH2IQkDOCkXPPXTqHgHWNsvq6z38hgkKWUYINThYxJYBVjw
         evvB8xnHRoaczS8dHVfibY8iwBGTIYBP/5sj2W++9tP+LqoVuRSit+KlkFTWZYE14FGm
         C2r93ude/BoVRbzYL2mrDbdViI5aPXPl/pmDUdQgLowPuNBHh3cifa+dXlE4ddNA82J2
         86z3wVU4x3sIlHFaUNkJCa7sM6UBMTldfXCp+PiGW1t/5M9Ym9LVF+k125IPnqHOZ3JQ
         eDJcyXznBLiNyIh6oVr53sd8I9Xh+dcoAN5clFw3PfNtUQAifbjMnu39wUAYk+FqbPb6
         J8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3NuNGzPX7l2+4H4FqXMF3G2Iv4qIhgXKrczFI5RGpVE=;
        b=Yq5iUemn/ldbGeJDtd1HxAF1hj0DtqhLP7yTny5PsMKGDOIfBJhBlef7t8gBdknx6q
         qn6ZKbPhCZLudCs0W+GpGW86zlChJ1q3d7GMrmhhBO+bbIThB1Rw7x/vE6fXo+8AMwp0
         95BTAmOZxWrKhlnojI5udijuJszjM0xO5d3R1Vlv6JQ4AIkd+xtB92Kgx0NIpyQoUisg
         ypoTsngQ6KZdShcnEw/iakAaHwTDXGVzH/ieUXzzdzJ0mLB8+cN1elD7Iz3HZGZ7Jkv1
         1eg11t4HdHJZvWaxQqZUk7bekpwGszw52uJYVL0TZco+taAquYjkzAeT34i0GEEarSsv
         ZlWg==
X-Gm-Message-State: AJIora+KvvnsObHf6J+LbBybGB5ka6e2hDYL1b8amSgCl2grBvlHfnPi
        JygmSlI6X6M57vi8vV+dvXCOlQ==
X-Google-Smtp-Source: AGRyM1sxLANce1xqGhsht71y51IJWGaCzyWUoPHm08yJixijPHX2pu2nnl4Pm3GBexyPjWUZpfXJNg==
X-Received: by 2002:a05:6a00:22d6:b0:52a:b9fc:4c88 with SMTP id f22-20020a056a0022d600b0052ab9fc4c88mr18633914pfj.3.1657641522504;
        Tue, 12 Jul 2022 08:58:42 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id w1-20020a1709026f0100b0016b953872a7sm6963581plk.201.2022.07.12.08.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 08:58:41 -0700 (PDT)
Date:   Tue, 12 Jul 2022 15:58:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Wang Guangju <wangguangju@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, jmattson@google.com, wanpengli@tencent.com,
        bp@alien8.de, joro@8bytes.org, suravee.suthikulpanit@amd.com,
        hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, lirongqing@baidu.com
Subject: Re: [PATCH v3] KVM: x86: Send EOI to SynIC vectors on accelerated
 EOI-induced VM-Exits
Message-ID: <Ys2aLfYFfyQO0R86@google.com>
References: <20220712123210.89-1-wangguangju@baidu.com>
 <6dcd11aefcd817ee0f8603328886df3023a98fa5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dcd11aefcd817ee0f8603328886df3023a98fa5.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022, Maxim Levitsky wrote:
> On Tue, 2022-07-12 at 20:32 +0800, Wang Guangju wrote:
> > When EOI virtualization is performed on VMX, kvm_apic_set_eoi_accelerated()
> > is called upon EXIT_REASON_EOI_INDUCED but unlike its non-accelerated
> > apic_set_eoi() sibling, Hyper-V SINT vectors are left unhandled.
> > 
> > Send EOI to Hyper-V SINT vectors when handling acclerated EOI-induced
> > VM-Exits. KVM Hyper-V needs to handle the SINT EOI irrespective of whether
> > the EOI is acclerated or not.
> 
> How does this relate to the AutoEOI feature, and the fact that on AVIC,
> it can't intercept EOI at all (*)?
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> (*) AVIC does intercept EOI write but only for level triggered interrupts.

If there are one or more AutoEOI vectors, KVM disables AVIC.  Which begs the question
of why SVM doesn't disable the AVIC if there's an edge-triggered I/O APIC interrupt
that has a notifier, which is where kvm_hv_notify_acked_sint() eventually ends up.
vmx_load_eoi_exitmap() sets the EOI intercept for all such vectors, and for _all_
SynIC vectors (see vcpu_load_eoi_exitmap()), but AFAICT SVM relies purely on the
level-triggered behavior.

KVM manually disables AVIC for PIT reinjection, which uses an ack notifier;
AFAICT that's a one-off hack to workaround AVIC not playing nice with notifiers.

So yeah, it seems like the proper fix would be to add svm_load_eoi_exitmap() and
replace the PIT inhibit with a generic ACK inhibit that is set if there is at least
one edge-triggered vector present in the eoi_exit_bitmap.

Tangentially related to all of this, it's bizarre/confusing the KVM_CREATE_PIT{2}
is allowed regardless of whether or not the I/O APIC is in-kernel.  I don't see
how it can possibly work since create_pit_timer() silently does nothing if the I/O
APIC isn't in-kernel.
