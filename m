Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7F24B18CF
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 23:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345254AbiBJWuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 17:50:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbiBJWuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 17:50:01 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0335BB75
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 14:50:02 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so7056890pjm.2
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 14:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XkU5iLNArD+gSSsbOviCay34l6txBbFA8zH6dv+uNvw=;
        b=YPaiEstUGXzuhD/Cg6vlfCuNXdeHpFm5v+9Bb7yfrNTAVUueaL3Tx0iJiwnN3f5t90
         o54COLLM2Omp0pdH/gBHFkfd2Mc3EU1SHKIPFJR8OQM/a+J/4IOvEPtg68VdYYanZd/E
         HoFuqxbKGMrXWg8uqSlH6em70kiQzKWC4mNDKcaRQB0sSx2cSYJn4Md2Yg2fsn0ZA2G2
         jZXr2rO9MHu4kh+BTRzxBTalggjBRX6d74MEJciRH+/RlMbErgpUXYHFgaE8wVC4hWkj
         Gf84g3ojYFR89mjYV3P/YSoymiT1DZ7/7B65zgR5y/niEpDcrTD+7Jqux9mkNkncTrzi
         6Wjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XkU5iLNArD+gSSsbOviCay34l6txBbFA8zH6dv+uNvw=;
        b=ymqIAojLEdF1Yb8J4vhEJskQOGESvYsyS39HHyk/q4A1cKL6DoekD6a+AQecTDq53x
         b3DFVSZTOXUPqE1uqjpgXqWTgqmhHMPc/JwwG8yPC8B8BbFnDrhc1hlIhtfg4RqEwYsF
         junZw0hSZwDhRZ3Fi7r/bYmZwpp0296a9/4tAviKvHTSlaHGB2CmI0BIz6XkfUJO8Ngj
         tJ3Yfz1wyzUVXWYYz5lF5mQAQ6gfLguMranG1rvb/7jImvyFipHI69K2XDzSsSNlQJsp
         soTzPpUL54yNDQgsDJbSBtIdyqdmoP3TbCnXv0/5s1+TYKVYfixL+7t+nNSRPhJV9etY
         obWw==
X-Gm-Message-State: AOAM531LsIuUOw9ZGS5dm+LffEzmLHB3hc0PBK3+CBDL1qrMNq9LDxgj
        KIK7v7pHnLN5BN16b1Je/m4Taw==
X-Google-Smtp-Source: ABdhPJzzbNPsKwKl0OnLYb9dCa4vgV+051VSPWXGr9kQVp9PSnpPfGQeV097gomnmYuBH4/z/wfuDA==
X-Received: by 2002:a17:90b:1c0f:: with SMTP id oc15mr5128547pjb.70.1644533401368;
        Thu, 10 Feb 2022 14:50:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pi9sm3850809pjb.46.2022.02.10.14.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 14:50:00 -0800 (PST)
Date:   Thu, 10 Feb 2022 22:49:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/12] KVM: x86: host-initiated EFER.LME write affects
 the MMU
Message-ID: <YgWWldQdqHBMdzA6@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-2-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> While the guest runs, EFER.LME cannot change unless CR0.PG is clear, and therefore
> EFER.NX is the only bit that can affect the MMU role.  However, set_efer accepts
> a host-initiated change to EFER.LME even with CR0.PG=1.  In that case, the
> MMU has to be reset.
> 
> Fixes: 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Ugh, but KVM_SET_SREGS handles this... It's basically KVM's equivalent of VMX putting
EFER in the VMCS, but then also allowing EFER in the load/store lists.

Reviewed-by: Sean Christopherson <seanjc@google.com>
