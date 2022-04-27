Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93A7511F7E
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiD0Ra4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 13:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243990AbiD0Ra4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 13:30:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC6474DE0;
        Wed, 27 Apr 2022 10:27:44 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h1so2121552pfv.12;
        Wed, 27 Apr 2022 10:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BzSUWHcbSbIUG8Be1XSOAdrtfZjDbG3/mXUuT1itZXc=;
        b=VxBKksreuBYZNErBWS4bqoHxx9xPZ+nj7mVZ8RqPksMrWbPjOByZHpFdHzo8eSwE2u
         w0IBM7UDwKQ9irFxTXg3OIdwxCtw43Gya+r26wQEgMOpDgotTePN6z9Ud3zEprsY7wDA
         vHv6/vFQcrhrV7mnbZfG5AJS8yA5w3J3kMVR5fPwdYev2n78fTZhEQipueB5bG5jT2O8
         k/sn58V9WXDgx8fgm+9QncL3AM3wQ7FvHyf8wBlf02BMg9GrA+4hSbCZdiyx4uPXObko
         dAyFfnUtiicAro3PGwNm6nQqZVQXHCskWr9ymzMRZYAtlIl00Zgbi6qaD2ZwdzG3HLDk
         3JLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=BzSUWHcbSbIUG8Be1XSOAdrtfZjDbG3/mXUuT1itZXc=;
        b=YCVFoOdwRO+h0zPWaqmvJe9ZEyc0EY6q5dVifIbGHtjzdyzSLuwvwfAc/7/S34qj94
         fr5/+w1Z2zDtavxTrhSQTU82TDj7nysBD1HlUmy+Q9jauSi5yvrV511i2DTkfCVPmUqp
         9tqOTO0N1bYfI5DqM73OzIEl+0g40SByMbqty3253UWdazn/KGfRmrMQdUD5x2irVatd
         Ibet57vdmqHLNOc3Rz8/Y87c0EgEX6tWJFNirPcet26/zRNuTYpsR3AnDfkoOEJmMiG5
         rgEcziJDpUYDuY2lOr6ytzbLW97QyWsriTPu09dlzyBvei7QIA2y2DoD7X/T1fwnu376
         o3/g==
X-Gm-Message-State: AOAM530ZO2W0PAjH66hriyfsNmFs2PTjIpELw92Inrh1pi9CAagumSMm
        UT0v7MyppTfvt/cQtM/3xSA=
X-Google-Smtp-Source: ABdhPJwAX++wrhvaoohbEVduON8WDdFuUdRNvuGm+VfnK2Nx+3CpW61edOXdfoPxMuKYm/07nEHPPg==
X-Received: by 2002:a05:6a00:1749:b0:50a:8eed:b824 with SMTP id j9-20020a056a00174900b0050a8eedb824mr31049201pfc.50.1651080464269;
        Wed, 27 Apr 2022 10:27:44 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:4f81])
        by smtp.gmail.com with ESMTPSA id h9-20020a17090a054900b001d953eb2412sm3669504pjf.19.2022.04.27.10.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 10:27:43 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 27 Apr 2022 07:27:42 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jirka Hladky <jhladky@redhat.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        regressions@lists.linux.dev,
        Justin Forbes <jforbes@fedoraproject.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] kernfs: fix NULL dereferencing in kernfs_remove
Message-ID: <Yml9Djpe5HT0HqoN@slm.duckdns.org>
References: <20220427172152.3505364-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427172152.3505364-1-minchan@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 27, 2022 at 10:21:51AM -0700, Minchan Kim wrote:
> kernfs_remove supported NULL kernfs_node param to bail out but revent
                                                                 ^
                                                                 typo
> per-fs lock change introduced regression that dereferencing the
> param without NULL check so kernel goes crash.
> 
> This patch checks the NULL kernfs_node in kernfs_remove and if so,
> just return.
...
> Cc: stable@vger.kernel.org
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215696
> Link: https://lore.kernel.org/lkml/CAE4VaGDZr_4wzRn2___eDYRtmdPaGGJdzu_LCSkJYuY9BEO3cw@mail.gmail.com/
> Fixes: 393c3714081a (kernfs: switch global kernfs_rwsem lock to per-fs lock)
> Reported-by: Jirka Hladky <jhladky@redhat.com>
> Tested-by: Jirka Hladky <jhladky@redhat.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
