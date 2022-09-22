Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EB05E66E9
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiIVPVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiIVPVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:21:34 -0400
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA1DF3716;
        Thu, 22 Sep 2022 08:21:33 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id g23so6508054qtu.2;
        Thu, 22 Sep 2022 08:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5wbLjt1ptS0e2F3zuisLshb8cZoB85PXpRGachu4Ne0=;
        b=y3RyaXtiHQ5BP60qthd/OoFNkS/CdnnHOPcThOMbIqMPK8jkeS24FnprUXjbkGHq8M
         EUaNhhePt/20e79PcYEKNJzbcnF1z3SMPvxbiDsJpXYnKFqib680hvYkVmrUMkJg8epH
         SzJZ3ewiDQsKdrusLSfdJgymhH5o/nd/fcF1QlStlQoKl69WhsRC+IzscIRQVVY+w45B
         J1PMOz/mBsC/GMNKAXZaS18abjcaEIoWLBP9L2xvEl3MEd7QXQSFriJJkZS3d76zdeuA
         3jYifiQF5+qfg8lXquED3qdGobGLtmFmP1sh121sJ/btba100Y0+75I7cmd/UysPmzdZ
         o3nA==
X-Gm-Message-State: ACrzQf1gfLiaq+4Rwrchpsvu5xcBQ7N5S1nk5XerGIAIq3MmI1uea764
        49EqTANGl/81vWP9NI+QOxjAUxSWHLqZF1ukv70=
X-Google-Smtp-Source: AMsMyM5JmyzM4Fn/yqQRqQjVZKnHwOkYTyAYwNcaYjs7UcT6AaG61yAPacMz920Hs8k7dLP3uYB83NuneFPF1cweQqI=
X-Received: by 2002:a05:622a:11c8:b0:35c:e912:a8ea with SMTP id
 n8-20020a05622a11c800b0035ce912a8eamr3273123qtk.17.1663860092476; Thu, 22 Sep
 2022 08:21:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220921063638.2489-1-kprateek.nayak@amd.com> <YysnE8rcZAOOj28A@hirez.programming.kicks-ass.net>
 <YytqfVUCWfv0XyZO@zn.tnic> <YywaAcTdLSuDlRfl@hirez.programming.kicks-ass.net>
In-Reply-To: <YywaAcTdLSuDlRfl@hirez.programming.kicks-ass.net>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 22 Sep 2022 17:21:21 +0200
Message-ID: <CAJZ5v0i9P-srVxrSPZOkXhKVCA2vEQqm5B4ZZifS=ivpwv+A-w@mail.gmail.com>
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, andi@lisas.de,
        Pu Wen <puwen@hygon.cn>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        ananth.narayan@amd.com, gautham.shenoy@amd.com,
        Calvin Ong <calvin.ong@amd.com>,
        Stable <stable@vger.kernel.org>, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 10:17 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Sep 21, 2022 at 09:48:13PM +0200, Borislav Petkov wrote:
> > On Wed, Sep 21, 2022 at 05:00:35PM +0200, Peter Zijlstra wrote:
> > > On Wed, Sep 21, 2022 at 12:06:38PM +0530, K Prateek Nayak wrote:
> > > > Processors based on the Zen microarchitecture support IOPORT based deeper
> > > > C-states.
> > >
> > > I've just gotta ask; why the heck are you using IO port based idle
> > > states in 2022 ?!?! You have have MWAIT, right?
> >
> > They have both. And both is Intel technology. And as I'm sure you
> > know AMD can't do their own thing - they kinda have to follow Intel.
> > Unfortunately.
> >
> > Are you saying modern Intel chipsets don't do IO-based C-states anymore?
>
> I've no idea what they do, but Linux exclusively uses MWAIT on Intel as
> per intel_idle.c.

Well, it can be forced to use ACPI idle instead.

> MWAIT also cuts down on IPIs because it wakes from the TIF write.

Right.
