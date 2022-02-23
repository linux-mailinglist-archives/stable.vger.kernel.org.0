Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E852B4C0D9B
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 08:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiBWHuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 02:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbiBWHuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 02:50:25 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F5D6D1BC
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 23:49:58 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id qe15so1904566pjb.3
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 23:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=E627RUNZI8BVu7aKzkB9EQU+HaYuIF8E1n5hAwi8GVI=;
        b=UhqSJ2zS5M8ZUtUHuH6t9qQu4lgWEU8YXCYrKcOaIeEMUDWkreFKvOOHIZu+3397hg
         RmMYQiZubfgjjm14Zk6D4fhr5sUY0f+1bdT2v7QCDpLQwZlGx7eTXJRc3FLW/l9lLA4a
         60opWRg2r3Y+fSFqq31WqhOUpbpJH+jbO3C1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=E627RUNZI8BVu7aKzkB9EQU+HaYuIF8E1n5hAwi8GVI=;
        b=3zM/QjwVo1uOX/AU0BwF0Gq6FuIiYCkLhgb7/MVbEqhXBdyx3cqtqdbpS5phP5VScP
         1hvDsb+FfRWg1ypKcyDwvNjbiPJQe14/UUv8M+lpWK3P8b+kURkYNo36F0NFDuZ16zfy
         8zMbOE7o9j3/Z40Z8Wl0hRm83R7gr/72jyZjNWqpzP50vBoy6dHcV3K3oQWllSzFAH+a
         z8LH7pA9s7/t4trL/x8o8zfTT3jllDKAH3Wi0d/Pbt2dd+FT+ZF6EV+dNdzCEVJVwloG
         arvqNUroZQ9UfrKc5Y6WaULQbyRnSDxXqs4iUp+946BDUey4M0ynBaPgb+4n9T1qBq6g
         Lu8w==
X-Gm-Message-State: AOAM530XMn1kS4rZpMa02Bt74NsUGEkSXspcM+Dq0N0xZKWErwyZ0Anh
        uQc3t1e4w8mGI36PGOUMhKrl2Q==
X-Google-Smtp-Source: ABdhPJzZcoICgoXFEPRWRrS1CdNR8/GchBf+zvOrVpytglbEK2XtyhsZd1JBznLxucmnfNejVvFwFw==
X-Received: by 2002:a17:90b:197:b0:1bc:5037:7c52 with SMTP id t23-20020a17090b019700b001bc50377c52mr7964776pjs.174.1645602597667;
        Tue, 22 Feb 2022 23:49:57 -0800 (PST)
Received: from [127.0.0.1] (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e10sm5221699pgw.16.2022.02.22.23.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 23:49:57 -0800 (PST)
Date:   Tue, 22 Feb 2022 23:49:54 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jann Horn <jannh@google.com>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>
CC:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_pstore=3A_Don=27t_use_sem?= =?US-ASCII?Q?aphores_in_always-atomic-context_code?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20220218181950.1438236-1-jannh@google.com>
References: <20220218181950.1438236-1-jannh@google.com>
Message-ID: <8D85619E-99BD-4DB5-BDDB-A205B057C910@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On February 18, 2022 10:19:50 AM PST, Jann Horn <jannh@google=2Ecom> wrote=
:
>pstore_dump() is *always* invoked in atomic context (nowadays in an RCU
>read-side critical section, before that under a spinlock)=2E
>It doesn't make sense to try to use semaphores here=2E

Ah, very nice=2E Thanks for the analysis!

>[=2E=2E=2E]
>-static bool pstore_cannot_wait(enum kmsg_dump_reason reason)
>+bool pstore_cannot_block_path(enum kmsg_dump_reason reason)

Why the rename, extern, and EXPORT? This appears to still only have the sa=
me single caller?

> [=2E=2E=2E]
>-			pr_err("dump skipped in %s path: may corrupt error record\n",
>-				in_nmi() ? "NMI" : why);
>-			return;
>-		}
>-		if (down_interruptible(&psinfo->buf_lock)) {
>-			pr_err("could not grab semaphore?!\n");
>+	if (pstore_cannot_block_path(reason)) {
>+		if (!spin_trylock_irqsave(&psinfo->buf_lock, flags)) {
>+			pr_err("dump skipped in %s path because of concurrent dump\n"
>+				       , in_nmi() ? "NMI" : why);

The pr_err had the comma following the format string moved, and the note a=
bout corruption removed=2E Is that no longer accurate?

Otherwise looks good; thank you!

--=20
Kees Cook
