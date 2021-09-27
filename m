Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDDA4196D9
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 16:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhI0O7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 10:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhI0O7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 10:59:49 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546D9C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 07:58:11 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id v10so25840042oic.12
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 07:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cHMFVm5hf7kJJgUtqrzezf6W2fGyhglHfmB/uYFeGQ8=;
        b=TQgBNG+k5XoeTbqFYfcGBQm05buCvHluyA7JLRiJUPNCznuPYFMhdHjv0m0wczRdCt
         tAQIxRbscDyqKWzTYXxN96eSWfhdv0oNSQ9bK4VxoMv67gBdF+UGYC6G1GTCfjOPpn7q
         2erOamrEwrcJW+IkGA25yGdIl5vYntaNBNLAbhj4WlY9VdUles1t4iDa6O2VpitOydFJ
         3LaX7/G7sDCJWwq2XyneroQ2RCeyx21qu91t0FzZa1x2wcoAae3gpEFHOOtVP09FRHWF
         uOog25ya7Vky1MEhTfm3WDt4bb+Antk7ox2sRa523h3hJod2xyIhsktAq8lFcngCFeeQ
         C0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cHMFVm5hf7kJJgUtqrzezf6W2fGyhglHfmB/uYFeGQ8=;
        b=m45iD6McyOxn2zBODdE15xoGLKs8csGfU68CHubtgBPr6M16MINrixbuZkQA3CZyLn
         f3HgLwOUK6xgpdt3LtSMHfpcYgBzoLrtCAhcRBJXM/v9jKLbpGoAEa1Exqb20f+ZRKtD
         9RcGta06SYQRoOkVeAQsqixvpEGL5N/c6WziGnEjf8lFteilH04G+Mr13Aixf9YWd7ZG
         9TbEC1xokU8NwSq/q2UFM2QDXxUUwDQSaiF2LNQ6a0+kYxKyijGmNic2rDUjyYHmXb3/
         l9phSurkl+lOm99JUbgVelqoNQzZrLlVdM8QOIAzCHHc1vsrna+6Eo3GtV+K7zheNe9T
         aGkw==
X-Gm-Message-State: AOAM5317dZsNW43Ph5QcfLBXJJc4V9mXJtcYgHuFHP4qH1JYNsTPJ1+5
        oXTeSi++3M7yRWt+s1YG//Exfg7dsok4/oh//HY=
X-Google-Smtp-Source: ABdhPJy/4tliBTh/Vdqqapab71XikNVQlslcIQPduSbmdP7NWU8gy7muYMOwWETs97qebb50PhtoHIBgyHxokuj8nSw=
X-Received: by 2002:aca:ab4d:: with SMTP id u74mr290079oie.120.1632754690719;
 Mon, 27 Sep 2021 07:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210920103133.3573-1-contact@emersion.fr> <Kmwa-gfuqYfkMsvvUXAaujfROLLXX4PuTRBRQ5efixoEvM3arNB_yT5eure3D1iqmnFB54wnbB87S1zBLL-79Ci7fhqoKx-M-ciPVs5fcSU=@emersion.fr>
In-Reply-To: <Kmwa-gfuqYfkMsvvUXAaujfROLLXX4PuTRBRQ5efixoEvM3arNB_yT5eure3D1iqmnFB54wnbB87S1zBLL-79Ci7fhqoKx-M-ciPVs5fcSU=@emersion.fr>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 27 Sep 2021 10:57:59 -0400
Message-ID: <CADnq5_PFMLUfadfA83bH7i4wAQdEtLWsKf7L7iLT_YjEhXDGug@mail.gmail.com>
Subject: Re: [PATCH] amdgpu: check tiling flags when creating FB on GFX8-
To:     Simon Ser <contact@emersion.fr>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 9:09 AM Simon Ser <contact@emersion.fr> wrote:
>
> Alex, Harry, Nicholas: any thoughts on this patch?

No objections from me with the WARN_ONCE change suggested by Michel.

Alex
