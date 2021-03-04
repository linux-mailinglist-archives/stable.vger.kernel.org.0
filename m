Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4140C32D029
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 10:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhCDJxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 04:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbhCDJxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 04:53:31 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18FFC061761;
        Thu,  4 Mar 2021 01:52:50 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id d11so19202675qtx.9;
        Thu, 04 Mar 2021 01:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OQqd7MKj8Re6kTuY9Kq2ebhYDPJcIlWVpSJHWhFglbs=;
        b=L3OQXVwVYJvE4QAQvwRqbrAQi7N7F2CEtCnqPbSTyx6j6JWH7K20Uv7/Mi48ZYjTkw
         n4sKuuR+IC0rdlKm+vbElNJtm0BVwMnlLWdE/4Rc4L7blqGSPTElVbVXqDuxcCya/uYI
         +hpvVSmlpCCH4DG81P0mNXvYJbt4uvqO86GYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OQqd7MKj8Re6kTuY9Kq2ebhYDPJcIlWVpSJHWhFglbs=;
        b=G8790XOFvLNxWvjEGWmjkENwayYkBYE8rAYeDG3AY9S6dPBKncV98Vck+QdHJKLcsq
         0+WV8pPKJw3LS/iXL7KpuWomJdzfGtNeuJJJz0PO0sAhTQasrszIweiKBF7hpRNYdCzA
         Wnsqblpg2RK6tQ0jMfIGpw/Llw4uHjy3DgyxSipiAtAKbnHrebOgDGRIISEoBQToarU4
         td0KGqznv6tW7S+sqml2xVBF284hMxwIRImXiufY6cxGsXohBJsSnsJ0Ne6qrQXk3gBR
         +BqV6Cbzwj2FCgI34mGz2KOaCegIpfBC4MpShw9Vsub3t3F1BooxQoeM3BVwcGJ6v39/
         tYrQ==
X-Gm-Message-State: AOAM530sr/3ptafdCqmhBUgU5OJcZrJH40g4+HTmpReu5UhDbG3ZidR1
        OIxJ3eO9wIAiKzDvppupDHpTtLsKRT+sHfMukug=
X-Google-Smtp-Source: ABdhPJzlCKXSuOs0/05oaz9/C2tl2sY0tyAx+P0+0sxxacx9TpsnGobdQSzTM8vo+MbsrebJEgGaXVSoBRkgTtpZ6Yo=
X-Received: by 2002:a05:622a:143:: with SMTP id v3mr3207635qtw.363.1614851569477;
 Thu, 04 Mar 2021 01:52:49 -0800 (PST)
MIME-Version: 1.0
References: <20210301161031.684018251@linuxfoundation.org> <20210301161034.369309830@linuxfoundation.org>
 <CACPK8XeoKfNCR9diNZoLCM04=G9BRVxY_VZhXr+XQcpq2+rCdQ@mail.gmail.com>
 <BY5PR11MB38788139CE6E4BA6A667CB84D2999@BY5PR11MB3878.namprd11.prod.outlook.com>
 <YECWglSMg0EKAhgd@kroah.com>
In-Reply-To: <YECWglSMg0EKAhgd@kroah.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 4 Mar 2021 09:52:37 +0000
Message-ID: <CACPK8XcCVZfi8n7v-dDwKN0PCN6sUUxXVCCBbC1c3aqR8eQJhw@mail.gmail.com>
Subject: Re: [PATCH 4.19 055/247] soc: aspeed: snoop: Add clock control logic
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Yoo, Jae Hyun" <jae.hyun.yoo@intel.com>,
        John Wang <wangzhiqiang.bj@bytedance.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vernon Mauery <vernon.mauery@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 4 Mar 2021 at 08:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 02, 2021 at 12:09:21AM +0000, Yoo, Jae Hyun wrote:

> > > From: Joel Stanley <joel@jms.id.au>

> > > Jae, John; with this backported do we need to also provide a corresponding
> > > device tree change for the stable tree, otherwise this driver will no longer
> > > probe?
> >
> > Right. The second patch
> > https://lore.kernel.org/linux-arm-kernel/20201208091748.1920-2-wangzhiqiang.bj@bytedance.com/
> > John submitted should be applied to stable tree too to make this module be probed
> > correctly.
>
> Now queued up, thanks.

Thanks Jae and Greg.
