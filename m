Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0B6622ECF
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 16:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiKIPOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 10:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKIPOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 10:14:08 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8FD1115B
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 07:14:07 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id k7so17364102pll.6
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 07:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UtJwvJLci/JkatzPK3HpdffetRpjfLyKGKg9pHS1Les=;
        b=MwKhsKJKuWT7rUX72ct9BRC3oqwZp+jCkoE4Wj4/KI6/IAHTVWqF+i1o6oWMA6UrEG
         1h/4GOO/9ys3qzDeMRBQ2oZRjeXrAp/SvFOnZ6Cqh/qX215D9d/QEteSI5UvFpASq+Dk
         7kCGz8qmfvs0D+OUhAMN6Zlbe6DO8JZWgxdLqReTuzVODyRy9yuH719baf+Kl6/q2zjA
         vsI0dRXhaT6Vt0MU32TLShFbaXhdkyCn16OnvMzzEkKpmDUCakpm00+4ManMWm7JKc7j
         q9avGzkB5W8zoWyqjelAmfCiQDV/O7qLitX3GLKtfjGd8dDKd8W8bN4yTVaQ0ZU4QuRk
         mtyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UtJwvJLci/JkatzPK3HpdffetRpjfLyKGKg9pHS1Les=;
        b=C9v1HxDqmMQiox7Cy7rsE/DFmDiDJXL1OZgGL4sWWuTSgU5KXY1OOCqBcRUPM3jKni
         mJMsid2tz5KYDhQ3R1Hs1GgOUF1ToRM6WWA8roE/Qk2VfcKmiXHueYjb5fbI1Kior7Cn
         rqW8TQf6uA4PWa1kG7818fw+w0pmMu4LUKyfGXI+BYm6toqwLOcZm5mODFYK69tcefRj
         hBidlUpewHRzN40ogF3rWWCvU9sCd+iYLsA5koRd5lBHdk960WjSl8co3NsA1iiYShrD
         iDW0q/mXtckFle9OwjndLjHjDDTVffusiAIGhBjC9D0g/d6eqK9rLzJxwNVvfNphrT++
         +4TA==
X-Gm-Message-State: ANoB5pmSgImNsb99pyHXzsqoPdmbjyjGHD60moYvhrmzA6m+bZuG5ec6
        IVGFGXoaXvYk53kY3P4jIXEkMw==
X-Google-Smtp-Source: AA0mqf5uG8MYfxZdmmvFGzKC7bnnIjzg8XzE+ryacGjVjx1GXT2Idp4er6qqAOaAC1YFbCO4UEwJcg==
X-Received: by 2002:a17:902:ce88:b0:188:6429:fedd with SMTP id f8-20020a170902ce8800b001886429feddmr28807424plg.0.1668006846620;
        Wed, 09 Nov 2022 07:14:06 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n6-20020a170903110600b001865c298588sm9252603plh.258.2022.11.09.07.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 07:14:06 -0800 (PST)
Date:   Wed, 9 Nov 2022 15:14:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, jmattson@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/11] KVM: SVM: replace regs argument of __svm_vcpu_run
 with vcpu_svm
Message-ID: <Y2vDujWx1Zz29VvF@google.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
 <20221109145156.84714-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109145156.84714-3-pbonzini@redhat.com>
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

Nit, () on function names.  Maybe I should offer to buy you a beer every time you
remember to add parantheses :-)

On Wed, Nov 09, 2022, Paolo Bonzini wrote:
> Since registers are reachable through vcpu_svm, and we will
> need to access more fields of that struct, pass it instead
> of the regs[] array.
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
