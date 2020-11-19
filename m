Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942752B941A
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 15:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgKSOIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 09:08:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41627 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgKSOIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 09:08:13 -0500
Received: from mail-ej1-f70.google.com ([209.85.218.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1kfkba-0007Bk-KZ
        for stable@vger.kernel.org; Thu, 19 Nov 2020 14:08:10 +0000
Received: by mail-ej1-f70.google.com with SMTP id y23so2204025ejp.10
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 06:08:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l+pQI3vl7MWJqgPLAwywjvM8WWJx1RapH5cmUPMx6aU=;
        b=n5gU0WopkpmLCECJySRi42UuPDfMzEhv3FAkzV/6NXrRHwwuzM9whpaZoNzlY2fWaY
         027tOqTa9dXAs/0J24NM/j4rJz+teWn2n8miFWh736nvUU0i+kaJ42jIlGjWXNbtMUBL
         /dy/E36kDPxS1PZFQ1CzbN6wqgtYDzEGgzr+BKLjCmwRh7pALevlmR0OKfKo2xjAyBwY
         0n2v+QPHRLsSxoWr4U3K+aOczWxOIpyhosmThca+fSOY1inEnnBWzm78uCKOq2mroh4P
         67YpWLqvOQnlx/QlQhKFUW5+/qeAKBuJotjSDelH2T/j3pyJoSowk7TnkQusbfoUbT2i
         /4rA==
X-Gm-Message-State: AOAM530M73I8rFnNWz4wdxzcsEhvRyDAjcXJY/gcOg6OXbLAHhl3VOaQ
        QQuu87+Av0KsnbTqGR/BPiiPk8ZjB0IkyBwFXf7J19EWKtgBF1ixMx2KmKHA9qhel5scABV1ljV
        MTyCNeLCCBSde+aFt4k1IZ+9RxtlJFVgiVbgBp5qNbVJN9+1D0w==
X-Received: by 2002:aa7:d298:: with SMTP id w24mr6122158edq.82.1605794890266;
        Thu, 19 Nov 2020 06:08:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhOyXhhKlZ1fwP9pcGwN0YH59LtZfO6NjPKkXh/FKc3qHoKSXt9FJCq2QZls2j4A2BlKV2fgreh08s8mqGRAU=
X-Received: by 2002:aa7:d298:: with SMTP id w24mr6122126edq.82.1605794890082;
 Thu, 19 Nov 2020 06:08:10 -0800 (PST)
MIME-Version: 1.0
References: <17fc60a3-cc50-7cff-eb46-904c2f0c416e@canonical.com>
 <20201118235015.GB6015@geo.homenetwork> <20201119003319.GA6805@geo.homenetwork>
 <CAKfTPtBYm8UtBBnbc7qddA2_OAa3vwH=KoHNgvsQJ9zO2KocYQ@mail.gmail.com>
 <7c9462c9-8908-8592-0727-9117d4173724@canonical.com> <CAKfTPtAfzxbm0qM+8r2i+3jWjpJ2OLbU4F1WE8GrzTZH6Ck7FA@mail.gmail.com>
In-Reply-To: <CAKfTPtAfzxbm0qM+8r2i+3jWjpJ2OLbU4F1WE8GrzTZH6Ck7FA@mail.gmail.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Thu, 19 Nov 2020 11:07:34 -0300
Message-ID: <CAHD1Q_xNgdAD59UnJmA4xHgwVcoNVTUkG1x_KfCuTVkc1SE9Aw@mail.gmail.com>
Subject: Re: [PATCH v3] sched/fair: fix unthrottle_cfs_rq for leaf_cfs_rq list
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Tao Zhou <t1zhou@163.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        SeongJae Park <sjpark@amazon.com>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Tao Zhou <ouwen210@hotmail.com>, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavan Kondeti <pkondeti@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Gavin Guo <gavin.guo@canonical.com>,
        "Heitor R. Alves de Siqueira" <halves@canonical.com>,
        Nivedita Singhvi <nivedita.singhvi@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thank you Vincent, much appreciated! I'll respond in the patch thread,
hopefully we can get that included in 5.4.y .

Cheers,


Guilherme
