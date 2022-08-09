Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8580F58D163
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 02:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244723AbiHIAed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 20:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244091AbiHIAeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 20:34:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAAF19C18
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 17:34:29 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id z187so9452283pfb.12
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 17:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=6C9ArOHrYaAILM0KZ4kBvP+nUNIqPYA+uHHXGsdeawA=;
        b=P7WoNvVpS3okL4YI3o5uz9544qztcUEr1d+LExJylyHYHQZklqf4z8S2h44Nc5Rqre
         qNENlB9cRxxMXJSQLaVPA0ibUYmjuaUJxWHlEQg7XuwMMHiCKjfD800w6HWCWFW97jG/
         ipFPUBO9QJxq33W2C+jnkG+6srCtqkLKyelalaRu86/MhVjtgfzdbu2VciP74lTDXia9
         tcw8AMqrymPwqEMiio9pnZkOQSBjcxgOGJcbHeqKSwXLqqqiqfSq/J4xmKGbmk8N1IHN
         DNkD36mh4S1SoQfCQvhfZ0UTfN6afTiLMOCwOk8MufKvKKOHJeMYrKKHKZ0GG2/hN1yX
         s3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=6C9ArOHrYaAILM0KZ4kBvP+nUNIqPYA+uHHXGsdeawA=;
        b=pjB/K4Fn1cmITQHKU21xmJSQpb3w1oUMJulzViI3xNL44L/t2Mrys30GQQBRWlG8Ys
         gj1AMNQgeBZhYI8UNSM9axBDjU4eaEC2F3SP+mv4OH0ZdhWbIQl9Zx5gY0LfzjcICjFz
         TEs6SQHbGqvsEbLOrm0I1QrwpTZjy6DPcpAXCu7lDCv69V8Y6B5EIVDOX7Aa+pmOki8i
         Wn2X+UY4Smz4u1fZCw+L0T0RaFNNlq4hOCOitrm07171ydVosx9gP95IHRupzEhoXzLR
         4mQ49xswbl2ux3nsJnIxsaaMJDj1Xk2FyNiUOi3H0eOLhzKxVZOBVrtLbdl8JZ5w2uKE
         PIMQ==
X-Gm-Message-State: ACgBeo1EmDi/zPd9RWIcR5JgWHFLHKyROTLx3Ce6swSRHwNFELufTPh5
        eaqk367l745Z9YTxjtaRPgbBXQ==
X-Google-Smtp-Source: AA6agR4Gz5g5vG/l/tZyqtSjI3vc8zXtknoeHx9hIKW+yKI0a0eBaFzsrwCevFsok5EYWzWVjhoKBA==
X-Received: by 2002:a63:ea11:0:b0:41d:9296:21e6 with SMTP id c17-20020a63ea11000000b0041d929621e6mr4696671pgi.603.1660005268964;
        Mon, 08 Aug 2022 17:34:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o13-20020a17090a420d00b001f260b1954bsm8740402pjg.13.2022.08.08.17.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 17:34:28 -0700 (PDT)
Date:   Tue, 9 Aug 2022 00:34:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Coleman Dietsch <dietschc@csp.edu>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 2/2] KVM: x86/xen: Stop Xen timer before changing IRQ
Message-ID: <YvGrkII3Sgw/qTeo@google.com>
References: <20220808190607.323899-2-dietschc@csp.edu>
 <20220808190607.323899-3-dietschc@csp.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808190607.323899-3-dietschc@csp.edu>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022, Coleman Dietsch wrote:
> Stop Xen timer (if it's running) prior to changing the IRQ vector and
> potentially (re)starting the timer. Changing the IRQ vector while the
> timer is still running can result in KVM injecting a garbage event, e.g.
> vm_xen_inject_timer_irqs() could see a non-zero xen.timer_pending from
> a previous timer but inject the new xen.timer_virq.
> 
> Fixes: 536395260582 ("KVM: x86/xen: handle PV timers oneshot mode")
> Cc: stable@vger.kernel.org
> Link: https://syzkaller.appspot.com/bug?id=8234a9dfd3aafbf092cc5a7cd9842e3ebc45fc42
> Reported-by: syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
> Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
