Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C0E6B3925
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 09:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCJItW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 10 Mar 2023 03:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjCJIsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 03:48:33 -0500
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D617B114;
        Fri, 10 Mar 2023 00:47:35 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id s12so4910786qtq.11;
        Fri, 10 Mar 2023 00:47:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678438054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7g81XRiKNyIBTp5oUvq6xFiCldKiPwESDbwSoupQ7g=;
        b=SjNd01OvvlMYDpaD7s9kVSO2bmOD5KN1Ax+ma8s9lZqETB78vPjhcHw8stPZ5KUBhP
         m2bLU4SFkEH8UfDloEQ3m16CD2mzWs1PRokp+xNFoYJUu0zNit2BREoo1QuInyvLA9uJ
         NHj61/ilOs3i/j11q2fITav7+zfBMycRuPK09N3YsGgX6CEb9iKsTiYRtqkOFgE8HKbt
         GeBj4MxVNooZq8LKFcosE/UwkFjKrwLThkRqvp7JLuh74DM2BIjtwnFXXhWVU8NCdMDt
         WYC2EVlEhL4SeRqnJwJ6iiy35Sj3JyhKFO+XxCuuWFsWoqzwk3MD5rbCwhs+9J4ZjVCi
         hLlA==
X-Gm-Message-State: AO0yUKUJlagsWe+wgq1WEu2Sm8Hz7yR7XZDFSK5CJxEZQ6CipptSvXjz
        V6caXPiDmXsY0BYPgS0ElFBdrBxSu9M8jA==
X-Google-Smtp-Source: AK7set/oJqM5NuwoCaGWwf4DCVFzHLAaE7JD3ULKA9bQPIIGCJz9wlrfQvUkvKqElSiqx8YG7hGPdw==
X-Received: by 2002:a05:622a:1899:b0:3bf:cac4:a3a1 with SMTP id v25-20020a05622a189900b003bfcac4a3a1mr7592343qtc.66.1678438054205;
        Fri, 10 Mar 2023 00:47:34 -0800 (PST)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id k1-20020ac80201000000b003bf9f9f1844sm990854qtg.71.2023.03.10.00.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 00:47:33 -0800 (PST)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-536cb25982eso84400067b3.13;
        Fri, 10 Mar 2023 00:47:32 -0800 (PST)
X-Received: by 2002:a81:af4b:0:b0:533:91d2:9d94 with SMTP id
 x11-20020a81af4b000000b0053391d29d94mr16108471ywj.5.1678438052584; Fri, 10
 Mar 2023 00:47:32 -0800 (PST)
MIME-Version: 1.0
References: <20230303092347.4825-1-cheng-jui.wang@mediatek.com> <20230303092347.4825-5-cheng-jui.wang@mediatek.com>
In-Reply-To: <20230303092347.4825-5-cheng-jui.wang@mediatek.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 10 Mar 2023 09:47:20 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU8qujVdXNfk00s66NF04=A3Z4Gsj7W+OyeeJA=pFmEbQ@mail.gmail.com>
Message-ID: <CAMuHMdU8qujVdXNfk00s66NF04=A3Z4Gsj7W+OyeeJA=pFmEbQ@mail.gmail.com>
Subject: Re: [PATCH 04/10] cpuidle, psci: Push RCU-idle into driver
To:     Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     stable@vger.kernel.org, Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Cheng,

On Fri, Mar 3, 2023 at 10:35 AM Cheng-Jui Wang
<cheng-jui.wang@mediatek.com> wrote:
> From: Peter Zijlstra <peterz@infradead.org>
>
> commit e038f7b8028a1d1bc8ac82351c71ea538f19a879 upstream.
>
> Doing RCU-idle outside the driver, only to then temporarily enable it
> again, at least twice, before going idle is suboptimal.
>
> Notably once implicitly through the cpu_pm_*() calls and once
> explicitly doing ct_irq_*_irqon().
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Tested-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
> Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Guo Ren <guoren@kernel.org>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Link: https://lore.kernel.org/r/20230112195539.760296658@infradead.org
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>

Given this patch introduced a so far unresolved regression upstream,
I think it's premature to backport this to stable.

https://lore.kernel.org/all/ff338b9f-4ab0-741b-26ea-7b7351da156@linux-m68k.org

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
