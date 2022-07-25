Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC13580864
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 01:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiGYXt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 19:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiGYXt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 19:49:26 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DB0275CC
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 16:49:26 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 6so11688318pgb.13
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 16:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UGmUphhsDStNcO/CEBZzPh7srmUM3aPDy39H7jz66cI=;
        b=Mn84UibUt8h4omoP5pgz95pelGBkmhXbaCYTZnsIdCIQczepdcxZ0ElkxxM91Rv7YT
         qrKPZikuiroZ2j/4V15gn/8q0Qtek/jseqfwvL7XUTr2hVLmUfO0jxyrdsvJWzyB/Ti3
         GbqMc9UMH5l8ZFmU1LL0Vt92tBIYeJY2d9/p74Fb334WT8XHAb4+CUDoZ9V7jUf5IHax
         TLFXVeZCW5fYmT08S0WTab/+hzpkuN7E51260rEso0xGUNLqtlRY57iRRdkVyVOAWH3V
         zQ9vAaqaknylUvRjO1jQUvUoTCqP7PHOCy3D2PTgJbxp+pKLPjEpSIdaOyFCEinprYiq
         bsDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UGmUphhsDStNcO/CEBZzPh7srmUM3aPDy39H7jz66cI=;
        b=DhlwWXOTetQezJ6XwxvKaUHvaJOiuaYzdMOAOADfVh+Z+M1No2fhbLMOfkvKG2n2MV
         09A8syHfdwZT+3/QLADCEo9qKbAszNZmRV5E0psLo95RiTs6ki/bewm7HrWvb593wn2o
         PHTIyDcQ5RrYyA0c/4cc8hzltKVpM9C6mcT/Pfdag0X30WUlzuQUXm+CH53P75IFvb9a
         yisL0KKCV97nJMjYofN4UAgm3bJOMdrsDzfJIF6jJ49OM3VhYHavgLL8aY1NC0EnhvAT
         zxqM4u9tGLOCm8SZb+ckyd2GTuh1sYiWZRWqzxWkJltM+gw5OL2oKazLOdgarlrESXIg
         CDhg==
X-Gm-Message-State: AJIora8KpXUXKp4fGoRQD/iaeR9imB3YUar+iU8fHS1c2VSUIG4k2na4
        +YI0hekoL5fpL8fsYQh6sZiucQ==
X-Google-Smtp-Source: AGRyM1u5sxUzsMOmoSnWTGnKfWg0t/QDmEJwXXG//tpkpE7Mxhxk+3kkSnudiVSWYpvCNHfxsRqZYA==
X-Received: by 2002:a05:6a00:1589:b0:52a:eb00:71d8 with SMTP id u9-20020a056a00158900b0052aeb0071d8mr14838280pfk.38.1658792965602;
        Mon, 25 Jul 2022 16:49:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z11-20020aa7990b000000b005281d926733sm10088234pff.199.2022.07.25.16.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:49:25 -0700 (PDT)
Date:   Mon, 25 Jul 2022 23:49:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH MANUALSEL 5.10 1/2] KVM: x86: lapic: don't touch
 irr_pending in kvm_apic_update_apicv when inhibiting it
Message-ID: <Yt8sAWd6qvEtZVji@google.com>
References: <20220222140532.211620-1-sashal@kernel.org>
 <e9e3f438-8699-abba-a1f8-d4d8bfbd63ed@redhat.com>
 <6d900dc3-44c0-5a0d-a545-1a51936e6a80@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d900dc3-44c0-5a0d-a545-1a51936e6a80@huawei.com>
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

On Mon, Jul 25, 2022, Zenghui Yu wrote:
> Hi,
> 
> On 2022/3/2 1:10, Paolo Bonzini wrote:
> > On 2/22/22 15:05, Sasha Levin wrote:
> > > From: Maxim Levitsky <mlevitsk@redhat.com>
> > > 
> > > [ Upstream commit 755c2bf878607dbddb1423df9abf16b82205896f ]
> > 
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> What prevented it to be accepted into 5.10-stable? It can still be
> applied cleanly on top of linux-5.10.y.

KVM opts out of the AUTOSEL logic and instead uses MANUALSEL.  The basic idea is
the same, use scripts/magic to determine what commits that _aren't_ tagged with an
explicit "Cc: stable@vger.kernel.org" should be backported to stable trees, the
difference being that MANUALSEL requires an explicit Acked-by from the maintainer.

Many (most?) of the automatically selected patches for KVM are good stable candidates,
but there are enough selected patches that we _don't_ want backported that the "apply
unless there's an objection" model of AUTOSEL is a bit too risky for us. 
