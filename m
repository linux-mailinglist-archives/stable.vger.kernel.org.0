Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93636CAA80
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjC0QXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 12:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjC0QXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 12:23:40 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3502BC;
        Mon, 27 Mar 2023 09:23:39 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eh3so38451265edb.11;
        Mon, 27 Mar 2023 09:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679934218;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QlnmibugJa5DF6Dbq9WO+z/EeYR1Oyku4Ibk4pLFdb0=;
        b=ER0K0555mp6hpb9v4Rjrc+Tt4pCLw+n8H4ax9oXtyxCQNDdhs9UE5bXkmyGYp9S1KA
         PVjPvcnf9dGCwNsNuohIfFXXjtEgbmAFotXzXvgPPaL/QlTRi6NudTosKtkuA/X4qMTh
         rbHJJtQRzFRioj62rSnd2Nre4PBumUWfQeSTzLCydRK6M5bhVJKkrV7F9KODRFvfAKEx
         aTegErg9WmpR6e6+Va8o93hsCN4CA/7nGPeKxr5Z1zz4HLWJreuV5xAvzJK8v4LYq1Re
         fiu4gGWTWepmNlTCUCKxnyFXZntVhLN6GPel5B5LlhUo4H+OzjwGc6r7qEQDWw0aOAAE
         y3GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679934218;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QlnmibugJa5DF6Dbq9WO+z/EeYR1Oyku4Ibk4pLFdb0=;
        b=KgANc3XEjAbI9JZ4SuhFRvorQxyO4vWKq3aqm/HoziuQCYDoJK6aCECC4aIN6IGerP
         cCcUPJR0g9NI6kHPmeIxJvdURfIo+aObhrAFdkve+N0aBQ5GqikZaTwT2B4Z4GXHokQr
         mDbJ2kfqA1UcpoUnaO4GglZBr+kXozAuVSoYzmOeVv68DFmPJWnKPdr9B9Nv+kc6cPcG
         Yot6IF6CtIgq0xGGPwEW4AUGYfVyvDyotZzesIrNoKtvXdqDaB8o7kWAD0cZoi7+eFIS
         JBR7Z8DfLyKXyRHjaTInv7+MGTFNuXLPDzOcUQCrJsKKpOceDi71OxERiH9mmj/69mHB
         BDmA==
X-Gm-Message-State: AAQBX9cA2RIw7N7g3z+QVX69yxaCMCHXXy2fiw+wJhP1ms0cePfacHbU
        clZl90C+k58kYcpcmOPP2HHHDBgtWcdPB/wRdh8=
X-Google-Smtp-Source: AKy350a/7M1vZcBZqSPmvDdvNGZYoyQjp7On7rawI565dPyYfXt4Xk4ABHouLdqjUAi31IcOuTeHs+fLGcATYYlH3/o=
X-Received: by 2002:a17:907:6e29:b0:93b:cd04:28 with SMTP id
 sd41-20020a1709076e2900b0093bcd040028mr6380267ejc.10.1679934218234; Mon, 27
 Mar 2023 09:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com>
 <20230327-tegra-pmic-reboot-v3-2-3c0ee3567e14@skidata.com> <ZCGuMzmS0Lz5WX2/@ninjato>
In-Reply-To: <ZCGuMzmS0Lz5WX2/@ninjato>
From:   Benjamin Bara <bbara93@gmail.com>
Date:   Mon, 27 Mar 2023 18:23:24 +0200
Message-ID: <CAJpcXm6bt100442y8ajz7kR0nF3Gm9PVVwo3EKVBDC4Pmd-7Ag@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] i2c: core: run atomic i2c xfer when !preemptible
To:     Wolfram Sang <wsa@kernel.org>, Benjamin Bara <bbara93@gmail.com>,
        Lee Jones <lee@kernel.org>, rafael.j.wysocki@intel.com,
        dmitry.osipenko@collabora.com, jonathanh@nvidia.com,
        richard.leitner@linux.dev, treding@nvidia.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
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

On Mon, 27 Mar 2023 at 16:54, Wolfram Sang <wsa@kernel.org> wrote:
> For the !CONFIG_PREEMPT_COUNT case, preemptible() is defined 0. So,
> don't we lose the irqs_disabled() check in that case?

Thanks for the feedback!
PREEMPT_COUNT is selected by PREEMPTION, so I guess in the case of
!PREEMPT_COUNT,
we should be atomic (anyways)?
