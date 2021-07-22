Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193963D2A21
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhGVQJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbhGVQHY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 12:07:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215D6C0619E1
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 09:44:56 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so5189972pjb.0
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 09:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1cJcgd2pbuDAvD6mxdCLmHUV42c/BmtCCqL70EuWCpA=;
        b=e+HOMZagarSozD8bIXaYib9lPmwG9eY43uM8olXJgUY1lJKgwBPaPsatKS31Dk4J+S
         24FWGf9hU6byFWj+uXoKYkj8leVwQvH5tKb5Sy2NxyMCvyd6cJjiigrFf6RXnr3aAt5r
         egLCwmdjF2mbvutrpRFWriV3R9Beuk/SViCPuY92xG2OAD92B5xQ3WDAfVoe0hPvwkdF
         gc6pi+SpttXPOLuV5UI77yRrKg0jTH8Pp2u6aI1JapfmgjlEk03jTUXW6KoTxQoyU8rY
         Lh9u2aFyMFORKKOGIJfpIyKDhqAFxiwSi57azQCtsfjUNTO2zYX7IvGpb1BFXIa6oQby
         RkLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1cJcgd2pbuDAvD6mxdCLmHUV42c/BmtCCqL70EuWCpA=;
        b=CUac8jGdbbhtSnFBC5kC5D60xsbC5tBEgcAjAgH+zLcSeWWv52TyNwdriPEQZZBsyg
         vSanszS90LRZlUaKWE8mMJqHEFyi6tK/HP4foaGaLcW6NtcjwpaSDV/c2AeShXfJ2BaN
         sTZlWfcUE8zNESWNtvR7Bhci0WU9cyBqpJB4QE1HiGsYs2BTixT14HA6N77F/Rcvkk10
         alfjOHoolzRZAI7LtBllOMwSuewLCsXTjAj4lFH9H8EShhR6wMbSeYaJXrwcN5gduDcS
         OrcczX5Q1sO1Lhsn4uigCpsklS+7PxhZ+EMz1AH05QOIM3n16SPYqKCsod9Zr5UyEhnr
         5dBQ==
X-Gm-Message-State: AOAM530Rko0fWHiezVAvsKl4EQiJCAyOc/8sHhyzKJUrTUEjLEg5nLO2
        P9qkeE64CJo66dHfxf8fdoVVDNV/hneppINClrspoA==
X-Google-Smtp-Source: ABdhPJz9Uha/v0yX2FJeA+/t7j8I2y2VchBz+A+2WBfwhOQxvOMV5bTjEOkxNfOK/1/iP14pQEJmgco58qv6MLXMkE4=
X-Received: by 2002:a62:30c5:0:b029:31e:fa6d:1738 with SMTP id
 w188-20020a6230c50000b029031efa6d1738mr488151pfw.55.1626972295586; Thu, 22
 Jul 2021 09:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <1626968964-17249-1-git-send-email-loic.poulain@linaro.org> <CAHNKnsS1yQq9vbuLaa0XuKQ2PEmsw--tx-Fb8sEpzUmiybzuRA@mail.gmail.com>
In-Reply-To: <CAHNKnsS1yQq9vbuLaa0XuKQ2PEmsw--tx-Fb8sEpzUmiybzuRA@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 22 Jul 2021 18:54:48 +0200
Message-ID: <CAMZdPi_7-2tXGu0fqE4-Dx7MQpL=9St3JTgfTwov402BXBF5hg@mail.gmail.com>
Subject: Re: [PATCH] wwan: core: Fix missing RTM_NEWLINK event
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Network Development <netdev@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Jul 2021 at 18:14, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Hello Loic,
>
> On Thu, Jul 22, 2021 at 6:39 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> > By default there is no rtnetlink event generated when registering a
> > netdev with rtnl_link_ops until its rtnl_link_state is switched to
> > initialized (RTNL_LINK_INITIALIZED). This causes issues with user
> > tools like NetworkManager which relies on such event to manage links.
> >
> > Fix that by setting link to initialized (via rtnl_configure_link).
>
> Shouldn't the __rtnl_newlink() function call rtnl_configure_link()
> just after the newlink() callback invocation? Or I missed something?

Ah right, but the first call of rtnl_configure_link() (uninitialized)
does not cause RTM_NEWLINK event (cf __dev_notify_flags). It however
seems to work for other link types (e,g, rmnet), so probably something
to clarify here.

Regards,
Loic


>
> --
> Sergey
