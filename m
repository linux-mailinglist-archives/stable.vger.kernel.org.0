Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D354A581916
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 19:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbiGZRvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 13:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239706AbiGZRuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 13:50:50 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED02C32BBB
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 10:50:44 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 12so13532517pga.1
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 10:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UKelOhAD/MflxLQCD3CV9kXt3f1tm8+576g2JP0lVpo=;
        b=W7QtxS0d7v0FLhrRBjTKZS6Q+aaT1urckWujSbu9ali0265KYUu+LFR3AI5YHakGX+
         mELKyPkdV/nQ7mU/ld7cyu2BEdZqAj3bHyxgBBKNOg+BYYhCoiHBbJvEH8rLjpzKfXJl
         UgdAe6tfldL8UB9r+aAJY8+GTwsaPbUU62dpvsAHnwdblrkSP31Gefmao3dzFMVn1CMB
         AyNq/YwMxbVzUG43/NJGgV0VbvAaCdtiMJ/5Kz/GJIf/O9OJfocMUOTr8i+utPaaowuA
         QgWtzVZcj8fUS4PeUuipl1MK8q8a2ZPQapkLrOD6TZBWoDGKK7nFwKWcJ1nS11GI22Jb
         kI7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UKelOhAD/MflxLQCD3CV9kXt3f1tm8+576g2JP0lVpo=;
        b=PmYyGiI7ECZSvQTdB4RR/AO5RPGOfwp2tkv/AquC0dLeZTYmBT7anTCA3ZNwU5fE7q
         U3Nlxka/rjW7crPuxG3Ms3FIQlJJrWVm4hn5eSNmAeiIxr6wD9rrEgLxloPl46/aqIbN
         PdCRTEqAlmjI6m3vf/sdOppyPkssRgavx8MZy8aM31dWNzt05AMqZt2LbeUi7yMvq5/m
         B3mQKRc9xhFQH33jEImE1aIhCjSRijC9irz6oyN0xUU2AxUDB0GbBASR5mVhR5qcXTFx
         sZuN0zN2k2MV4uPFzbv4iB8+bzQUo71IrtbkH83UmuHvrKeXY+I2Qw4X1kDBFhzaNyH7
         iLdg==
X-Gm-Message-State: AJIora+5Gov6Rt3izk0VZxN4UdrLjiK6dW8enUF8cU1l6zbYVDC35hGI
        d7luhTmRMb77aKxqmuJf3zjIiQ==
X-Google-Smtp-Source: AGRyM1tJvdhzrKNTIthwDvTfOxqlbckVevLtZ4SxGr4UMG2i25ORucstPh9+wtI0sYmeyzFxmNqc9w==
X-Received: by 2002:a63:2c89:0:b0:411:66bf:9efc with SMTP id s131-20020a632c89000000b0041166bf9efcmr15386950pgs.589.1658857844100;
        Tue, 26 Jul 2022 10:50:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s22-20020a17090b071600b001ecbd9aa1a7sm11112804pjz.1.2022.07.26.10.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 10:50:43 -0700 (PDT)
Date:   Tue, 26 Jul 2022 17:50:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH MANUALSEL 5.10 1/2] KVM: x86: lapic: don't touch
 irr_pending in kvm_apic_update_apicv when inhibiting it
Message-ID: <YuApb56AjxaeOirP@google.com>
References: <20220222140532.211620-1-sashal@kernel.org>
 <e9e3f438-8699-abba-a1f8-d4d8bfbd63ed@redhat.com>
 <6d900dc3-44c0-5a0d-a545-1a51936e6a80@huawei.com>
 <Yt8sAWd6qvEtZVji@google.com>
 <3f2f83a3-e240-a509-38ca-1b88bdc179d4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f2f83a3-e240-a509-38ca-1b88bdc179d4@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 26, 2022, Paolo Bonzini wrote:
> On 7/26/22 01:49, Sean Christopherson wrote:
> > On Mon, Jul 25, 2022, Zenghui Yu wrote:
> > > Hi,
> > > 
> > > On 2022/3/2 1:10, Paolo Bonzini wrote:
> > > > On 2/22/22 15:05, Sasha Levin wrote:
> > > > > From: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > 
> > > > > [ Upstream commit 755c2bf878607dbddb1423df9abf16b82205896f ]
> > > > 
> > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > 
> > > What prevented it to be accepted into 5.10-stable? It can still be
> > > applied cleanly on top of linux-5.10.y.
> > 
> > KVM opts out of the AUTOSEL logic and instead uses MANUALSEL.  The basic idea is
> > the same, use scripts/magic to determine what commits that _aren't_ tagged with an
> > explicit "Cc: stable@vger.kernel.org" should be backported to stable trees, the
> > difference being that MANUALSEL requires an explicit Acked-by from the maintainer.
> 
> But as far as I understand it was not applied, and neither was "KVM: x86:
> nSVM: deal with L1 hypervisor that intercepts interrupts but lets L2 control
> them".

Ah, I misunderstood the question.  I'll get out of the way.
