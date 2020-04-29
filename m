Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651AA1BECA1
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 01:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgD2X06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 19:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgD2X06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 19:26:58 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C96C035494
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 16:26:56 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id g2so2587660vsb.4
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 16:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wzW2QoswANOc4BdubXXSnIPlG+98WpqoMVNvKMZnN90=;
        b=eA7p5JCBVyNn88KfixBzJiT1YbieVZWfEMsnVvZKOME6ZOaQyKuCYAlB9zqkCbaLX6
         Z8PSkYKabeGxUhxqpr4bIZyvkRrU40wg/ObnKdb+hwBj37ZYmQc9xjlvRK0BUOPT8m4c
         Waxov2b/Z7BTAuQ6+05KRfg+QVkMcrq4i2i3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wzW2QoswANOc4BdubXXSnIPlG+98WpqoMVNvKMZnN90=;
        b=sK946kL9fR6KJOg8FHuH5qa0Ei2orE/an2S2jjS1GLOdMZPpK6Bi5a7PRJBwyfw6a5
         lijOnFht1CRQZZ5j4qTLUS2zMnYtdtHoFSYI3XTmjd2unSb1J243lOMCSm8I5ShPrlEE
         I6x/J/tCpQ65SdgBnqqRFmxajREMX9n+qryIe6Wy6Rs07KL/fQKNK6ScuDYM17s2m9HA
         Umre1VzGdcM6zo4BOwGzGpZA6H8u3jcUsd/n6CAU0wIZ4glOhnpNGVAZdwCudAQf2Xf1
         dmH0+CkggQzbpqPpK+yg1OpAmJoCbOrP4/3x1Z8sbVXFwktwgyxIEyLyhUY+vl5HhO3F
         ny3w==
X-Gm-Message-State: AGi0PuaEjIRjJioGo1fswzYcrXcXW2SfOmLs02DmIRpCGXG/v/qK9SD7
        LjoWXk/+JC+qFZKfqEnkLa3eWoTDRXY=
X-Google-Smtp-Source: APiQypJ29cmDNRWFLKA0D9EjIfIgyhXIQjFQhJiDM5YwdHEIERq6zqRQV46K9ZMk3SEDOAa1rsxtSg==
X-Received: by 2002:a67:5d83:: with SMTP id r125mr825912vsb.0.1588202815326;
        Wed, 29 Apr 2020 16:26:55 -0700 (PDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id l9sm253181vsr.21.2020.04.29.16.26.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 16:26:54 -0700 (PDT)
Received: by mail-vs1-f48.google.com with SMTP id a5so2594790vsm.7
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 16:26:54 -0700 (PDT)
X-Received: by 2002:a67:bd07:: with SMTP id y7mr796832vsq.109.1588202814031;
 Wed, 29 Apr 2020 16:26:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191004073736.8327-1-cleger@kalray.eu>
In-Reply-To: <20191004073736.8327-1-cleger@kalray.eu>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 29 Apr 2020 16:26:41 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WgUNySbRE9dZys28fFo3eZwf_2=cj68jaw1ftakJDzVQ@mail.gmail.com>
Message-ID: <CAD=FV=WgUNySbRE9dZys28fFo3eZwf_2=cj68jaw1ftakJDzVQ@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: Fix wrong rvring index computation
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-remoteproc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Clement Leger <cleger@kalray.eu>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Evan Green <evgreen@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri,  4 Oct 2019 Clement Leger <cleger@kalray.eu> wrote:
>
> Index of rvring is computed using pointer arithmetic. However, since
> rvring->rvdev->vring is the base of the vring array, computation
> of rvring idx should be reversed. It previously lead to writing at negative
> indices in the resource table.
>
> Signed-off-by: Clement Leger <cleger@kalray.eu>
> ---
>  drivers/remoteproc/remoteproc_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Randomly stumbled upon this in a list of patches.  This patch landed
in mainline as:

00a0eec59ddb remoteproc: Fix wrong rvring index computation

Should it be queued up for stable?  I'm guessing:

Fixes: c0d631570ad5 ("remoteproc: set vring addresses in resource table")

-Doug
