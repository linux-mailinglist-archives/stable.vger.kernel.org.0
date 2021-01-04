Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32F02E995C
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbhADP6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727293AbhADP6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 10:58:41 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871EBC061574;
        Mon,  4 Jan 2021 07:58:00 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id x20so65411885lfe.12;
        Mon, 04 Jan 2021 07:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3EGmnRyr5X4ekn3lhgCJIAOH3HIZX6HuJoFIgiIne5A=;
        b=ETEh1F2gbphfLcdW3xIPLalLRA3f5vupSOfICX0vhGXhXx00INyaR528/FggcVmyPx
         dmj/mkQHOYzBdAZ8gfj7DqRDU3qb3NPK6qDPR/VOqmwBqAYbHEqn4IGRnbxCYlxhQJmw
         7rDoT/FcbzCTJViD3o7yKHU7Ce+ZStMfhg/DYi57qBmJK5GCBySqL1uZgBZ+a6WVKIII
         V/o76swGGpcBXbWx92V6+Fs9BADjn7XQp7F69dxYCky6EAKAYqH+RdKMFhiV6FQw019A
         I8gLq3HboLV9JAN2g4yKk+8YmqpJJoFuOqmJH3raM/xclo6tkk5n5Ep5x+4m/1D6Ivul
         eA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3EGmnRyr5X4ekn3lhgCJIAOH3HIZX6HuJoFIgiIne5A=;
        b=XpoQ/3+le1k58rDovS0r3FePZTTND1QXOVGnzO94BqT878zCQTAR2aSGXfGnlk7YpJ
         2ivh5rtee3MtxiEHJJvMjIEPdYOQ00SKaleeQ87TrIQ7edZYRH85zH6RL7cgL2zQm6Pg
         7AooaIGkLOTWJQgMc+pIHCxjJwN5flH4R6yy5LHuiWVjWcMgWbc7af2Cf2mk+YfqtDdG
         ea4y2FJMeHaX1MsNCJnyLC2WpQbKhfXlMDLeJ2pFmHNKhwXGISfvozXtMOiZTe4cqmP0
         P/TxT2XBXuDlExxBRofQAhi4TXs4NAQXaW0wjFPmBmLMpS8jL3hcDC5weAs0YQdOU1SO
         Zo1A==
X-Gm-Message-State: AOAM532kKvXOT2L7PZ/A4VBeF8SFWwYeKqBTk6T4l1RNVTvL2pc+qUVN
        41BD/nii/FAwsM9IWVk912YTiy4j4txCGBDP3es=
X-Google-Smtp-Source: ABdhPJymAII9319mW2lvf9Ihhj6dyeGy8xw7TY6lLt+hZw8BDX/IaP2UuHc/of7JD4rVDvLjCHsHXbJzS1DV8usg33E=
X-Received: by 2002:a05:6512:3288:: with SMTP id p8mr30124378lfe.443.1609775879070;
 Mon, 04 Jan 2021 07:57:59 -0800 (PST)
MIME-Version: 1.0
References: <20210104152058.36642-1-frederic@kernel.org> <20210104152058.36642-4-frederic@kernel.org>
In-Reply-To: <20210104152058.36642-4-frederic@kernel.org>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 4 Jan 2021 12:57:47 -0300
Message-ID: <CAOMZO5ChFtTj0O0RVxmq-pX8acuvvGhL4ON4bu9fvwBqj_fyrQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: imx6q: Fix missing need_resched() check after rcu_idle_enter()
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Frederic,

On Mon, Jan 4, 2021 at 12:21 PM Frederic Weisbecker <frederic@kernel.org> wrote:
>
> Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
> kthread (rcuog) to be serviced.
>
> Usually a wake up happening while running the idle task is spotted in
> one of the need_resched() checks carefully placed within the idle loop
> that can break to the scheduler.
>
> Unfortunately imx6q_enter_wait() is beyond the last generic
> need_resched() check and it performs a wfi right away after the call to
> rcu_idle_enter(). We may halt the CPU with a resched request unhandled,
> leaving the task hanging.
>
> Fix this with performing a last minute need_resched() check after
> calling rcu_idle_enter().

Shouldn't tif_need_resched() be used instead of need_resched() in the
commit log?
