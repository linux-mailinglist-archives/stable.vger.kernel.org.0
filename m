Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D25640C85
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 18:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbiLBRsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 12:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiLBRsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 12:48:01 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740B27DA74;
        Fri,  2 Dec 2022 09:47:59 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id fp23so5913137qtb.0;
        Fri, 02 Dec 2022 09:47:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cZkrcSltncE8/ZuZoYv4b2d7hscDOxyl0JUDZPI6liw=;
        b=RaGlrd0ba8dYvndE1TLtFoQdEVC7LSet9MIgIcBBC4QOcWYtZn5YZZMX4oVb3ThRUK
         P7pOUy+ubpMKYXE4xbVbUP3qMGQU63s2QguP8LiQRFvoUIZc3yx5iEEgigxGJ7tvZ6DO
         /WkvDhcRd2BLd+HQdYgX00yWGKScXs/YEtC1FMFqRymib9P72pBI4NkdCZ26D/RbNdiR
         kew8s4YydKL7s0NcK3x01xRf5oVT9q4GW5ZToewO5ihFa/BkmTHLcsf2QNeENkhqzHs0
         Zo1SC5L1St0x0P2F9xBCFl25c+voRlg754QTZylfcFiNot18FmzWtYESxZxH/VkdtRoG
         gf3A==
X-Gm-Message-State: ANoB5pmRqeAPQ7my/7gaqlI+AoY1ZzQLgpPjb0m9rURuk11vM3iAs53B
        X7b43MyNBs6UtZvLGCyWqHb5AijwJondlfQff20=
X-Google-Smtp-Source: AA0mqf51uIOWkjKSwhAqxTpfKMjsu42I0eiMVKrm0VEx7HQYTsVmieNicP3p40lc7YCyIthr+ry0hUYCl4VWsxspqf0=
X-Received: by 2002:ac8:7dcb:0:b0:3a6:8dd0:4712 with SMTP id
 c11-20020ac87dcb000000b003a68dd04712mr11196833qte.411.1670003278849; Fri, 02
 Dec 2022 09:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20221127-snd-freeze-v8-0-3bc02d09f2ce@chromium.org> <20221127-snd-freeze-v8-2-3bc02d09f2ce@chromium.org>
In-Reply-To: <20221127-snd-freeze-v8-2-3bc02d09f2ce@chromium.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 2 Dec 2022 18:47:47 +0100
Message-ID: <CAJZ5v0jbKSTQopEoXW9FpqDmAqp6Pn=-Om5QP2-7ocuGdq8R9w@mail.gmail.com>
Subject: Re: [PATCH v8 2/3] freezer: refactor pm_freezing into a function.
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Juergen Gross <jgross@suse.com>, Mark Brown <broonie@kernel.org>,
        Chromeos Kdump <chromeos-kdump@google.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Len Brown <len.brown@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Biederman <ebiederm@xmission.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Joel Fernandes <joel@joelfernandes.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Takashi Iwai <tiwai@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        kexec@lists.infradead.org, alsa-devel@alsa-project.org,
        stable@vger.kernel.org, sound-open-firmware@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 1, 2022 at 12:08 PM Ricardo Ribalda <ribalda@chromium.org> wrote:
>
> Add a way to let the drivers know if the processes are frozen.
>
> This is needed by drivers that are waiting for processes to end on their
> shutdown path.
>
> Convert pm_freezing into a function and export it, so it can be used by
> drivers that are either built-in or modules.
>
> Cc: stable@vger.kernel.org
> Fixes: 83bfc7e793b5 ("ASoC: SOF: core: unregister clients and machine drivers in .shutdown")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

Why can't you export the original pm_freezing variable and why is this
fixing anything?

> ---
>  include/linux/freezer.h |  3 ++-
>  kernel/freezer.c        |  3 +--
>  kernel/power/process.c  | 24 ++++++++++++++++++++----
>  3 files changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index b303472255be..3413c869d68b 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -13,7 +13,7 @@
>  #ifdef CONFIG_FREEZER
>  DECLARE_STATIC_KEY_FALSE(freezer_active);
>
> -extern bool pm_freezing;               /* PM freezing in effect */
> +bool pm_freezing(void);
>  extern bool pm_nosig_freezing;         /* PM nosig freezing in effect */
>
>  /*
> @@ -80,6 +80,7 @@ static inline int freeze_processes(void) { return -ENOSYS; }
>  static inline int freeze_kernel_threads(void) { return -ENOSYS; }
>  static inline void thaw_processes(void) {}
>  static inline void thaw_kernel_threads(void) {}
> +static inline bool pm_freezing(void) { return false; }
>
>  static inline bool try_to_freeze(void) { return false; }
>
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 4fad0e6fca64..2d3530ebdb7e 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -20,7 +20,6 @@ EXPORT_SYMBOL(freezer_active);
>   * indicate whether PM freezing is in effect, protected by
>   * system_transition_mutex
>   */
> -bool pm_freezing;
>  bool pm_nosig_freezing;
>
>  /* protects freezing and frozen transitions */
> @@ -46,7 +45,7 @@ bool freezing_slow_path(struct task_struct *p)
>         if (pm_nosig_freezing || cgroup_freezing(p))
>                 return true;
>
> -       if (pm_freezing && !(p->flags & PF_KTHREAD))
> +       if (pm_freezing() && !(p->flags & PF_KTHREAD))
>                 return true;
>
>         return false;
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index ddd9988327fe..8a4d0e2c8c20 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -108,6 +108,22 @@ static int try_to_freeze_tasks(bool user_only)
>         return todo ? -EBUSY : 0;
>  }
>
> +/*
> + * Indicate whether PM freezing is in effect, protected by
> + * system_transition_mutex.
> + */
> +static bool pm_freezing_internal;
> +
> +/**
> + * pm_freezing - indicate whether PM freezing is in effect.
> + *
> + */
> +bool pm_freezing(void)
> +{
> +       return pm_freezing_internal;
> +}
> +EXPORT_SYMBOL(pm_freezing);

Use EXPORT_SYMBOL_GPL() instead, please.

> +
>  /**
>   * freeze_processes - Signal user space processes to enter the refrigerator.
>   * The current thread will not be frozen.  The same process that calls
> @@ -126,12 +142,12 @@ int freeze_processes(void)
>         /* Make sure this task doesn't get frozen */
>         current->flags |= PF_SUSPEND_TASK;
>
> -       if (!pm_freezing)
> +       if (!pm_freezing())
>                 static_branch_inc(&freezer_active);
>
>         pm_wakeup_clear(0);
>         pr_info("Freezing user space processes ... ");
> -       pm_freezing = true;
> +       pm_freezing_internal = true;
>         error = try_to_freeze_tasks(true);
>         if (!error) {
>                 __usermodehelper_set_disable_depth(UMH_DISABLED);
> @@ -187,9 +203,9 @@ void thaw_processes(void)
>         struct task_struct *curr = current;
>
>         trace_suspend_resume(TPS("thaw_processes"), 0, true);
> -       if (pm_freezing)
> +       if (pm_freezing())
>                 static_branch_dec(&freezer_active);
> -       pm_freezing = false;
> +       pm_freezing_internal = false;
>         pm_nosig_freezing = false;
>
>         oom_killer_enable();
>
> --
