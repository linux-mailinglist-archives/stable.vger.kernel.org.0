Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB97C66A3B4
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 20:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjAMTxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 14:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjAMTxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 14:53:49 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8B67D9C8
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 11:53:47 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id x37so23536300ljq.1
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 11:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yxJoOeJeLXuoA2xLIDUsuFLs7ZqEd/yD5fE3qlFqk7A=;
        b=Rn1YZS2w7L3nZ8Sb7Ng6rbdcbE7pzQCTm+HI1VdJOFiBKz1gQk/5vq2IkEfp/r4i9Z
         1jKK1lUJ0SjoNPb+Y5P2VvTmWKAcNkGOc0jrRONz5A860SrcC6J8dKeZG+U1iFGIgjkB
         3l+Tb08gbsYT08e3F6TMrj4JqE0/4fh/prky8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxJoOeJeLXuoA2xLIDUsuFLs7ZqEd/yD5fE3qlFqk7A=;
        b=uBchZJKTJxEqSZUGguHid5/HaN1UGEbmuzdJkleZghLe5vfWoqbB4fitz2rZNfuSIu
         zM7xGP5ua518/wA2ucCaz9TN3KJAB2gOujAYURhT0zv1uYWaUafiaT26ZZO90Hoc2JNt
         dsvoH2udAsSfBvbIPRsbgkuhkd6OJ7CrX/gnz8FytKjxoxlbZxiE0zYhUAfKpA7IBBs7
         xo5eVaS1N98VlmYLuZZhabzq3smvYlaGarXkWoV4q9hktdjkUnYcMTQ9Kgso6BM66h+5
         h+uNy79pVeDWD24UcUfA6BpL+Qoz4tl+fKzoHmhOgPE89nB8kwmqD2tCkf74uwvJDyz4
         UbHA==
X-Gm-Message-State: AFqh2kq4e3k2/Xh9Gb7zCN46IMHu6cgW/RBZ5ozd6btZ6fAScXBNThlD
        jr+FM3aWl3PM3axZd1AH5GTuFZpqKae/6DY++zFde60/a9za3g==
X-Google-Smtp-Source: AMrXdXtIP5DEa3Zgi51YDgDbmJhKbc57SuJt0SLQKb1Q8s8fsroNJOyivDPMX0662NXb/zobe6OaHrS84aCoVTRebHg=
X-Received: by 2002:a2e:9a8c:0:b0:287:dd66:81f0 with SMTP id
 p12-20020a2e9a8c000000b00287dd6681f0mr1080397lji.4.1673639625718; Fri, 13 Jan
 2023 11:53:45 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 13 Jan 2023 13:53:44 -0600
MIME-Version: 1.0
In-Reply-To: <Y8EO8w9Smn4NAox6@hovoldconsulting.com>
References: <20230113005405.3992011-1-swboyd@chromium.org> <20230113005405.3992011-3-swboyd@chromium.org>
 <Y8EO8w9Smn4NAox6@hovoldconsulting.com>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date:   Fri, 13 Jan 2023 13:53:44 -0600
Message-ID: <CAE-0n52LkayyRwV0tDk2LAciAfOmYU056L53f8Ma1QLiQCHfoQ@mail.gmail.com>
Subject: Re: [PATCH 5.15.y 2/4] phy: qcom-qmp-combo: fix memleak on probe deferral
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Johan Hovold (2023-01-12 23:57:39)
> On Thu, Jan 12, 2023 at 04:54:03PM -0800, Stephen Boyd wrote:
> > From: Johan Hovold <johan+linaro@kernel.org>
> >
> > commit 2de8a325b1084330ae500380cc27edc39f488c30 upstream.
> >
> > Switch to using the device-managed of_iomap helper to avoid leaking
> > memory on probe deferral and driver unbind.
> >
> > Note that this helper checks for already reserved regions and may fail
> > if there are multiple devices claiming the same memory.
>
> This bit turned out to catch some buggy bindings and dts, so if you want
> to backport this one then the corresponding fixes for that would be
> needed as well.
>
> That includes
>
>         a5d6b1ac56cb ("phy: qcom-qmp-usb: fix memleak on probe deferral")
>
> and some dts fixes which likely already have been backported.
>
> It may even be preferred to keep to just skip this patch and keep those
> small memory leaks on probe deferral to not risk any regressions in
> stable.

I only see qcom,sm8350-qmp-usb3-uni-phy in the stable tree and that
hasn't been changed since the node was introduced. I'll try to port the
exclusive logic from a5d6b1ac56cb into this patch. I don't think it's
preferable to keep the memory leak.
