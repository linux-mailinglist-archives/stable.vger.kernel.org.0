Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CB85E679B
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiIVPxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbiIVPxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:53:30 -0400
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963AD45F6C;
        Thu, 22 Sep 2022 08:53:29 -0700 (PDT)
Received: by mail-qv1-f51.google.com with SMTP id g4so7106536qvo.3;
        Thu, 22 Sep 2022 08:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vD0+VxiAGurIOKv6AW3dsyvyb0Nd5x0MkeebHLF5GZY=;
        b=RVo/ccidPJXz4f4vELxxPcPFwgdY/+PUCGKapOiq2qasI7UXtmq6wf848HhuDcyNkA
         SbKd2mu+LglmnqDAtz8xRM/ajErxU+e7n0U+JqaN3zRnCyy4+DPKTWC+w1QVICKyznkM
         Oqr+zZPKmDkn1NC2drokHNGRnjIENr0mFMbWxAA4+QXd78vhcxkoq/Q+I6jq+MKb62FS
         Wv+3n5Xw8JBhvy+ldWX1P4t+0J4v+a/puSJhpDFd/yiu2HvEdYH1szrbveRwd1JJgTqQ
         TWaDLbdWkckXF9vEWNbqjcZabSCkTQKqrJLiW80LG4CqEBuiYxA09BFJLdvvQ6kh8/N1
         Stqw==
X-Gm-Message-State: ACrzQf1zSYXLTRnrX9Tc+gYJKR9Ndx4bN1E4mR06kwvs6O6rFd593Xrh
        IDRjrFUaP+t9uNSTN2aOgKqFYSm1v6VzFDY2h2w=
X-Google-Smtp-Source: AMsMyM7uV5oXIb+tahsXXoQim6m4K48OLfD7owDsxQLXf2RDEqng6L3d0fltb2aUF4yFYR35Ezp55+QqlvRaTemITlA=
X-Received: by 2002:a05:6214:1cc9:b0:496:aa2c:c927 with SMTP id
 g9-20020a0562141cc900b00496aa2cc927mr3110108qvd.15.1663862008742; Thu, 22 Sep
 2022 08:53:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220921063638.2489-1-kprateek.nayak@amd.com> <YysnE8rcZAOOj28A@hirez.programming.kicks-ass.net>
 <YytqfVUCWfv0XyZO@zn.tnic> <YywaAcTdLSuDlRfl@hirez.programming.kicks-ass.net>
 <CAJZ5v0i9P-srVxrSPZOkXhKVCA2vEQqm5B4ZZifS=ivpwv+A-w@mail.gmail.com> <YyyA9AV9qiPxmmpb@zn.tnic>
In-Reply-To: <YyyA9AV9qiPxmmpb@zn.tnic>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 22 Sep 2022 17:53:17 +0200
Message-ID: <CAJZ5v0i0NzJfRuqcuJQC3J5moaEikoRusquCybAz0T8dMy8gCw@mail.gmail.com>
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 5:36 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 22, 2022 at 05:21:21PM +0200, Rafael J. Wysocki wrote:
> > Well, it can be forced to use ACPI idle instead.
>
> Yeah, I did that earlier. The dummy IO read in question costs ~3K on
> average on my Coffeelake box here.

Well, that's the cost of forcing something non-default.
