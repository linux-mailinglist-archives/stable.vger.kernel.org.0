Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F656D36D5
	for <lists+stable@lfdr.de>; Sun,  2 Apr 2023 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjDBKFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Apr 2023 06:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDBKFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Apr 2023 06:05:02 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291C2C7;
        Sun,  2 Apr 2023 03:05:01 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i5so106562316eda.0;
        Sun, 02 Apr 2023 03:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680429899;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vON38RePuqLozDLYgddF4MhnfOMXnlOt/UI+1d380Tc=;
        b=AGf0Nt8d3g3Tjs8UM6Y9oy0kRPOCOY3mhu/4yHnogRcf625IkJ//ZQZA5l5ruJeH7J
         SGztoIejVOeoCQHRQYU1kIB3AIE7RtuIvcJVGr8GLMAFsFnVNR5wTwmoYGDeeTodMU0a
         QNmmOschEdAt8dvirRPvk6DpE5YFMgHTalXk3+0PUbrQ70fOQ0dTB4151PXw+l/MyZwI
         OoWvtXBKMcry5heube3yrkiCQnCffICAhH7bHYxb8jIZzzTFpaLI38joM4doWEgeDkBt
         +fGlCpnvDOyIXA2xHOw96Ghv4HBZ62dN/J8+XTmj+RmFymXpimBvBdpkLwZsHwCZnKhP
         5Emg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680429899;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vON38RePuqLozDLYgddF4MhnfOMXnlOt/UI+1d380Tc=;
        b=AVr7Gqo9MTnTz25CzBRtAaN6tmg9FUYYhoHyxoMdoEEKJGGWm8/pV/+zvDw05OjI1C
         bLWVG7sa4ecnk5ULsC2IN1YE8GVTldolFY7IZYjOkkNiDBHF7j7wv38wWask0qD1LTjG
         OEa8E0EVk95c3bpNm4SOtwO4rdnWWDb4FiaPg7nbqyDtFidvoaBe63shUETY8FBRLLkJ
         yCzmZb4wEZPQvPku5PnaJ1U+teqXpn4pcPr9aVcPrB+r31YWl0bMMSiSfLMDzXRLR5VB
         cZmkdqplOAb8qBhMC1OYwzig+TidZPiZddBxH3B4EHRXRc9msujgW+OAyEIxEcoosY3n
         1WeQ==
X-Gm-Message-State: AAQBX9cNFJqxrCMUMJGlZ4RRLczZ4qKk95r2es3PZJP6sAQ4HeB+qLI+
        hRL/wAbJ/5Khjo9FJ79F5bfWgo6sbuiZKSnAtvuaqGUv1JQeeg==
X-Google-Smtp-Source: AKy350bETyU8FCFBHNo7aZNd+kj0kRyOpAWPw1ac3/+7VMBqkj27wnx24V7VJ6rrxW7Kz7QIPmwANFA6TtuBcxCUYTw=
X-Received: by 2002:a17:906:6a0d:b0:928:6456:729c with SMTP id
 qw13-20020a1709066a0d00b009286456729cmr16213480ejc.10.1680429899526; Sun, 02
 Apr 2023 03:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com>
 <20230327-tegra-pmic-reboot-v3-2-3c0ee3567e14@skidata.com>
 <ZCGuMzmS0Lz5WX2/@ninjato> <CAJpcXm6bt100442y8ajz7kR0nF3Gm9PVVwo3EKVBDC4Pmd-7Ag@mail.gmail.com>
 <ZCSWkhyQjnzByDoR@shikoro>
In-Reply-To: <ZCSWkhyQjnzByDoR@shikoro>
From:   Benjamin Bara <bbara93@gmail.com>
Date:   Sun, 2 Apr 2023 12:04:48 +0200
Message-ID: <CAJpcXm5eKhQg3JDksGs5fHi-DN+VAJNnuyUKtQGiS2OzTgzyVw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] i2c: core: run atomic i2c xfer when !preemptible
To:     Wolfram Sang <wsa@kernel.org>, Benjamin Bara <bbara93@gmail.com>,
        Lee Jones <lee@kernel.org>, rafael.j.wysocki@intel.com,
        dmitry.osipenko@collabora.com, jonathanh@nvidia.com,
        richard.leitner@linux.dev, treding@nvidia.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 Mar 2023 at 21:50, Wolfram Sang <wsa@kernel.org> wrote:
> Could you make sure please?

Sure, I'll try. The check before bae1d3a was:
in_atomic() || irqs_disabled()
which boils down to:
(preempt_count() != 0) || irqs_disabled()
preemptible() is defined as:
(preempt_count() == 0 && !irqs_disabled())

so this patch should behave the same as pre-v5.2, but with the
additional system state check. From my point of view, the additional
value of the in_atomic() check was that it activated atomic i2c xfers
when preemption is disabled, like in the case of panic(). So reverting
that commit would also re-activate atomic i2c transfers during emergency
restarts. However, I think considering the system state makes sense
here.

From my understanding, non-atomic i2c transfers require enabled IRQs,
but atomic i2c transfers do not have any "requirements". So the
irqs_disabled() check is not here to ensure that the following atomic
i2c transfer works correctly, but to use non-atomic i2c xfer as
long/often as possible.

Unfortunately, I am not sure yet about !CONFIG_PREEMPTION. I looked into
some i2c-bus implementations which implement both, atomic and
non-atomic. As far as I saw, the basic difference is that the non-atomic
variants usually utilize the DMA and then call a variant of
wait_for_completion(), like in i2c_imx_dma_write() [1]. However, the
documentation of wait_for_completion [2] states that:
"wait_for_completion() and its variants are only safe in process context
(as they can sleep) but not (...) [if] preemption is disabled".
Therefore, I am not quite sure yet if !CONFIG_PREEMPTION uses the
non-atomic variant at all or if this case is handled differently.

> Asking Peter Zijlstra might be a good idea.
> He helped me with the current implementation.

Thanks for the hint! I wrote an extra email to him and added him to CC.

Thanks & best regards,
Benjamin

[1] drivers/i2c/busses/i2c-imx.c
[2] https://www.kernel.org/doc/Documentation/scheduler/completion.txt
