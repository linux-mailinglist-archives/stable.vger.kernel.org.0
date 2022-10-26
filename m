Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B92F60E5D5
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiJZQxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJZQx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:53:29 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0618263F
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 09:53:28 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f9so11024174pgj.2
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 09:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JTPUTofw5Px6wDuzjSzBA6102cy8Q7KNCefTlzTbweA=;
        b=plQokVI3SK5E9C5Eux6lLxrfTaeOKu34+Dvgn5WDSMmlxq8E9baUEG5l3Sh7pwpdDf
         gaeTy9TLHpGuieH8/iPpADSK2EcFUT2kPYxCWCeSsw2qzWPsxwj7uKD/P2z6ifKM9Gjd
         1M2aslH1t5cGJBtVYrPVFSxpQmJXHOHKuyqYWM/kta7pvMJ5eHVWlgqRLQyI04spy0AP
         Hult9n0FmB6KMF8PCJTQFDfrSEQaOxHx2R69MMkYorjIoqfM/bKSo+M8xQxf+gJqeoS1
         nM0QjWBYaxeNREFj/oWzeDB1bIbTDlYwd21fFf3dIQ6esxEsqMDd4VWfzNUXA9o9S8Ej
         D38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JTPUTofw5Px6wDuzjSzBA6102cy8Q7KNCefTlzTbweA=;
        b=JL9sDlCZNCEUptFbviQHJu5igfW5mbuColMVZeiptvGW7LfBE9SWK+wF6tLKxin7W1
         f5ConrDLnY1fpq6r8x+zBAehet5EKgtyaG9EHsj9ekiUlLfZJCWT6xn5BBDzXCsB5b6W
         CdR+Fhf38F+ELVre9veTiF+ii4EOYoT6TAMDSLbCJ8j3cdOzVY4D3tHgrfianBIgvn5N
         rHLShJCbsbAcRIBBG1zivRTl3OvXYQNBaRDAZIg7Q0Hvl5DzSlNNuotPxJST9UkA4fFa
         od2R4jizKBUFii7ehuYjzJb0yY1FMu4NDwjSs4ApMBJouRxyB9xRxBpFYPas3Dl83YnY
         TqrA==
X-Gm-Message-State: ACrzQf3zJlxQ1BnkRwMWYR0Obx665RBpyKW89MhfzHqsCsS0vUPv52ke
        uGlm2KRdDrFNcWRPSamq+ZvEKA==
X-Google-Smtp-Source: AMsMyM6ASFYkyuw0HRAsVwxXGdfHdW987C3xTRNcsmMD6dT1BWLE2tdspKlhEZIkVvhJsNLo7agt2g==
X-Received: by 2002:aa7:96c7:0:b0:56b:c569:99c with SMTP id h7-20020aa796c7000000b0056bc569099cmr17505659pfq.4.1666803208298;
        Wed, 26 Oct 2022 09:53:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g5-20020a1709026b4500b001869ba04c83sm3124664plt.245.2022.10.26.09.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 09:53:27 -0700 (PDT)
Date:   Wed, 26 Oct 2022 16:53:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Bandan Das <bsd@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] KVM: nVMX: Advertise ENCLS_EXITING to L1 iff SGX is
 fully supported
Message-ID: <Y1lmASxiV0r2Ldfs@google.com>
References: <20221026072330.2248336-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026072330.2248336-1-eesposit@redhat.com>
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

On Wed, Oct 26, 2022, Emanuele Giuseppe Esposito wrote:
> Clear enable_sgx if ENCLS-exiting is not supported, i.e. if SGX cannot be
> virtualized.  This fixes a bug where KVM would advertise ENCLS-exiting to
> L1 and propagate the control from vmcs12 to vmcs02 even if ENCLS-exiting
> isn't supported in secondary execution controls, e.g. because SGX isn't
> fully enabled, and thus induce an unexpected VM-Fail in L1.
> 
> Not updating enable_sgx is responsible for a second bug:
> vmx_set_cpu_caps() doesn't clear the SGX bits when hardware support is
> unavailable.  This is a much less problematic bug as it only pops up
> if SGX is soft-disabled (the case being handled by cpu_has_sgx()) or if
> SGX is supported for bare metal but not in the VMCS (will never happen
> when running on bare metal, but can theoertically happen when running in
> a VM).
> 
> Last but not least, KVM should ideally have module params reflect KVM's
> actual configuration.
> 
> RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2127128
> 
> Fixes: 72add915fbd5 ("KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC")
> Cc: stable@vger.kernel.org
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
