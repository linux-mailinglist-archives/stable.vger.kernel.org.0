Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE135C043F
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiIUQeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbiIUQdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:33:45 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C648A1D30
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 09:15:33 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-12b542cb1d3so9712466fac.13
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 09:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=nho4Mx1okgWawVlTzUYe67i9YWynaM+oXQaK+2MMuvI=;
        b=VwqCvKnPJ7HggbwxjUkIkIQa8H/b7PRW5aOthoIKPKSz1DK+gLZjQ6BW4nlT6EaaVo
         FQTCFBHAgsK3r9PXjfda17cDQYAzny1+jxbYFIKGrPqDUy5vTb8wIgXRTWmeXA0g556q
         rCYCPmFCWZOzbBCa0bTpi8Ecw8GT/IUH8FkWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=nho4Mx1okgWawVlTzUYe67i9YWynaM+oXQaK+2MMuvI=;
        b=XmNoSvTM+8v2CCf5a9XrIHEb8T668YEg5cBeBX82VUWCDNRAgKNCj4eyOvYjEiGqfZ
         UP3j0DCiNYuCOP/73/aOHMUjGEgqQKOwbuxFecOvmmxpDbDjD7rKZGTJ+qkFNB8zZbIN
         8p9rhvnRA5AtV5z1fUWuhXMXJeKkZkgiYDZ7uiFgvWzTqFjs2NBueqMMb97ZhK2ZFTvq
         +uzOA56zhgQZ9Llezfo3VYXC4CpIinFWFg8bW0mC4vwvV3XKLZj85t8ef0eesGRfBEP4
         j/nXv+iw0v6es1ubg1EhhF1kUHFPQhIoaiavdgAQxBZHwz9t/4nJze4l7vvzeffBGkgJ
         fZeg==
X-Gm-Message-State: ACrzQf24uXDerNnkHnKRMb7ToSj9fz9cnfk3wFcp8xcI8nbWOB9hjuoJ
        bCo1blYSXAyWarvdl3LUo2AVlnqwZpS9MQ==
X-Google-Smtp-Source: AMsMyM7uawNSMP/DTNkY1d1hBwIHU92DjvxKQxO/pf3BHpu7vZ2RXa9p4zpfFuK3gu2BlaoDbg40iw==
X-Received: by 2002:a05:6870:8a08:b0:12b:c621:b987 with SMTP id p8-20020a0568708a0800b0012bc621b987mr5314177oaq.149.1663776932012;
        Wed, 21 Sep 2022 09:15:32 -0700 (PDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com. [209.85.167.169])
        by smtp.gmail.com with ESMTPSA id x22-20020a056830115600b00655bc32a413sm1538502otq.42.2022.09.21.09.15.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 09:15:29 -0700 (PDT)
Received: by mail-oi1-f169.google.com with SMTP id n124so8662510oih.7
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 09:15:29 -0700 (PDT)
X-Received: by 2002:a05:6808:11cf:b0:34b:8f4f:314b with SMTP id
 p15-20020a05680811cf00b0034b8f4f314bmr4277924oiv.126.1663776928733; Wed, 21
 Sep 2022 09:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <1d1844f0-c773-6222-36c6-862e14f6020d@leemhuis.info>
 <fd672632-7935-14ff-e2be-0db8443b0907@leemhuis.info> <YyrI/qzx/EWapzck@8bytes.org>
In-Reply-To: <YyrI/qzx/EWapzck@8bytes.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 21 Sep 2022 09:15:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgU0PyYHut+8zV+kNCxOZiCXd5J29Eisiy8badzsk8Msw@mail.gmail.com>
Message-ID: <CAHk-=wgU0PyYHut+8zV+kNCxOZiCXd5J29Eisiy8badzsk8Msw@mail.gmail.com>
Subject: Re: How to quickly resolve the IOMMU regression that currently
 plagues a lot of people in 5.19.y
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Greg KH <gregkh@linuxfoundation.org>,
        Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 1:19 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> Thanks for the noise :) I will queue the fix today and send it upstream.

.. and it's in my tree now.

                  Linus
