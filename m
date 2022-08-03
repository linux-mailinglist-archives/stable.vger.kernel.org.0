Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD96588FFC
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 18:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbiHCQDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 12:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbiHCQDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 12:03:15 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C992614009
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 09:03:14 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id c185so13219343iof.7
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 09:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7OygQDDOouiCiPlbWs7isceuYzV4DhEDfDd1Dqaw+Fk=;
        b=E2jMAjUkqHKj0vnFAxpfKrRcV7XNkEoSEbS/+BpgFbNEaGQdfJogCTXFyTTg3oPdxu
         W4Tg6IOdDVeix86om4oE8kGNrzh9M7t/I5oop39zGGh9naC7R1e239QiPSlOC6Zl1Vj2
         6MUgEnkwt1g+02rvhOq4hZbXbGUWqyLcE8Zlbj/oq+sQtpuhmIVJp4gml2ezY48ZumFI
         oj4C/3DDYbpIWHIxJXicHUZzIeGjqaDLswcDU0kE0SDZoPs85eANnO1uCfAYieNfcWHQ
         AkY7Vhn5ggpuxKKJA9qcgNsOucsoeyr7RQKxxD1Sj0Qzsm/DV62sJA4dsLACAT97zcda
         kioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7OygQDDOouiCiPlbWs7isceuYzV4DhEDfDd1Dqaw+Fk=;
        b=r0aMcfE73lWNm8nsuu1BH8A027Hss2jtSVC4cTBUkeFAvMZz9h1LTyrBWsVUiBJUgy
         DAJZ/u++BkPu9+yEA/7b3oO/JBBTvuSiAml+rS4fS9mZElD6QCzmmUqzONl6EgCuelfI
         WKOZf0VrIjLk+ly5ivHYp6qv27NQ+VMU4Kl5so7mf6GXiCDddlLsRrH2voX9NJzxA/y3
         Sp9MxupsfQJqx+OOOcbV8olkzWta8/NMOJe+M5pDdxxyXNOa0fIVx95BLc6GYUgP6Jln
         d2naJMkRtoWMOuUhTDbSWvqh/ZL9QaJey+nLTox1IwmYmjJWleDdksZpqeQtySvqfOMQ
         wUrQ==
X-Gm-Message-State: AJIora82AH0fHTqrBB/QZAAj2Zfq20GPF2f7khDgVslDnVuNcznWHyFU
        8JqCW9T8gPM0VJwHWLwZerb0H2r2uEhZdrdEFw92dg==
X-Google-Smtp-Source: AGRyM1s4mmvAjontxpiPUsqZ9BL+Z+O7jvL4u8eHKd3PuNbn9A7qwR3L2BfuiAthTAB+fTMfrg1DJ1ld3fzRbyA4n14=
X-Received: by 2002:a6b:6105:0:b0:67b:e68f:c9ee with SMTP id
 v5-20020a6b6105000000b0067be68fc9eemr9828309iob.154.1659542593947; Wed, 03
 Aug 2022 09:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220614021116.1101331-1-sashal@kernel.org> <YrI25yOy7WMqr+x3@sashalap>
In-Reply-To: <YrI25yOy7WMqr+x3@sashalap>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 3 Aug 2022 18:02:37 +0200
Message-ID: <CAG48ez36K0YzkQRF4UNf6HccackSKXvb4BYm=tqjNw8hjXm1cQ@mail.gmail.com>
Subject: Re: [PATCH MANUALSEL 5.18 1/6] KVM: x86: do not report a vCPU as
 preempted outside instruction boundaries
To:     Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jun 21, 2022 at 11:23 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Paolo, ping?

What happened here? From what I can tell, even the backports that
Sasha already wrote didn't get applied?
