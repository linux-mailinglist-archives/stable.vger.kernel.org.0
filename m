Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97E560D25C
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 19:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiJYRVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 13:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiJYRVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 13:21:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B08DAC7E
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 10:21:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v13-20020a17090a6b0d00b0021332e5388fso3825282pjj.1
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 10:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=du1ODIVzDVk6wmvqQAobisUJiOuA6OOoA0oy9u/yWR4=;
        b=syIE1vRJPa3K5k0d8UDqEvr3g8RMzSiY/aQ/i35eYRA/jVA6bkeDhz64mSRp9GHnja
         3lgRnMrV/SxoQaJYuJychgOhQvJ7xDq7fP8QSY6aF8AZ1eWqtO8EANBHZKNq7dSxBFGh
         suMo6Sr9qIEH2C3oxfW8XbKxGFj2nsA287g/+oFyJ+Nyt4vjjmrQS23t6YSYloTskpHV
         rF94Vv/+UuBVV+p5E7gKB3PdvqpW9ch/rsKdimJVwum415XeDIl3oJ8bjU87b0tRHiKo
         +pRKWAoge5JBnsuECpAZi6MtktM9Ckv6p68/bGLgZ+G5HON7i5Xg0cTWzUuQAr8Oz+8W
         UnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=du1ODIVzDVk6wmvqQAobisUJiOuA6OOoA0oy9u/yWR4=;
        b=nLdca8k3aeObktFRUzHmvDDy3BRTva+FBKWVV4gIlTFw50C9jCC6za/jhxa2iFO7Sb
         6Q4Pqr+++njRErGavvfPC+8go0I+TbYAu0E9v3z7Kj8MI/T18oHaeUepGJv7eFNi2t7l
         PZZgyc8/krG21AUcUb3bK+iHhFs9aUygokqIjVCe5spmc10gRkLygNK0JmxsPjGY+0RT
         WqayzidMjsbxQmknrmVbeAG5dlPhGHVCZYU6/2I1Wd+4oWAh3hL9/R6UJMGEFY5mHNnb
         WdP/URFR8JgOuPIdPRRbu9kUa51C8y62n2bswdKYGlHiaUm1Gj76ETsK2TyG3QE1xGHN
         dIUQ==
X-Gm-Message-State: ACrzQf3hOScyXBVHsZpUZCx6xmyRFljZQqnU0YXIBzGNZ7DVF14GE3cp
        /FhB0WKUjOinyb7E1M/j9BTbdg==
X-Google-Smtp-Source: AMsMyM6si9Fdq9RuatnrHWkqDzmyAZjGH3FNBfekkUCU7h3F2J05FKEUZB5jnmooXASYhnx1GhQsbw==
X-Received: by 2002:a17:902:ccd1:b0:186:5ee4:cf49 with SMTP id z17-20020a170902ccd100b001865ee4cf49mr30766395ple.26.1666718468613;
        Tue, 25 Oct 2022 10:21:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z24-20020a17090acb1800b00212d4cbcbfdsm1608210pjt.22.2022.10.25.10.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 10:21:08 -0700 (PDT)
Date:   Tue, 25 Oct 2022 17:21:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Bandan Das <bsd@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: vmx/nested: avoid blindly setting
 SECONDARY_EXEC_ENCLS_EXITING when sgx is enabled
Message-ID: <Y1gbAA0JVo9g3joi@google.com>
References: <20221025123749.2201649-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025123749.2201649-1-eesposit@redhat.com>
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

Shortlog scope is still wrong, should be "KVM: nVMX:"

The shortlog is also somewhat is misleading/confusing, as it's not at all obvious
that "sgx enabled" means "KVM's sgx_module param is enabled" and not "SGX is enabled
in the system".

E.g.

  KVM: nVMX: Advertise ENCLS_EXITING to L1 iff SGX is fully supported


On Tue, Oct 25, 2022, Emanuele Giuseppe Esposito wrote:
> Currently vmx

s/vmx/KVM

> enables SECONDARY_EXEC_ENCLS_EXITING even when sgx is not set in the host MSR.

"sgx is not set in the host MSR" is ambiguous.  "sgx ... in the host MSR" could
easily refer to the SGX_ENABLED bit in IA32_FEATURE_CONTROL, it could refer to
the ENCLS_EXITING bit in the allowed-1 half of IA32_VMX_PROCBASED_CTLS2, etc...

In other words, please be more precise.

This statement is also wrong in that it implies that KVM _always_ sets ENCLS_EXITING,
whereas the bug is purely limited to nested virtualization.

E.g.

Clear enable_sgx if ENCLS-exiting is not supported, i.e. if SGX cannot be
virtualized.  This fixes a bug where KVM would advertise ENCLS-exiting to
L1 and propagate the control from vmcs12 to vmcs02 even if ENCLS-exiting
isn't supported in secondary execution controls, e.g. because SGX isn't
fully enabled, and thus induce an unexpected VM-Fail in L1.

> When booting a guest, KVM checks that the cpuid bit is actually set
> in vmx.c, and if not, it does not enable the feature.

Again, this is nothing to do with the failure.
