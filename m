Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A81A18895C
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 16:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgCQPpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 11:45:25 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:46708 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgCQPpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 11:45:24 -0400
Received: by mail-vk1-f195.google.com with SMTP id s139so6086141vka.13
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 08:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqwE0LST7bQrMlS1npkM81NgJLaEPEMndv6Fs6jOD0Q=;
        b=PhRozuqb3/yllPbcOt9nm5DoWkHAVkcVOmhTNXefUe95wiUC+Gohh8hKoKtKTraQic
         M6WN6kZOkNRD/QkU4T2xreIdRfS6+zMAMZx2ji+PADf5Gz0Y/t22K7QQJ4Uqg3cbsO8u
         Dsj1v5tUrR3OR7cFyZoqgKR8efGtBn9eC3Hzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MqwE0LST7bQrMlS1npkM81NgJLaEPEMndv6Fs6jOD0Q=;
        b=XyuEcACls6jNNr9ZgkJCrK9jkBIYkNrTvncmbU3gNikLgCljPQq2ZQH/kcOLoYuSs9
         XQHLctOC7l5S7tz6Tb2AT1pJy5oRVy8cdrdDqURfdE1Y7pnS7+AbfG3zFlHdXtKZD+bQ
         TTLWwN2sWvLU9hnsw/lxWNRZUBVSrOviK+6or2EtPn8aL8XhKPoTZARDqdDXAxr11trU
         2LVYEGfaIu1Q+bQDYFiK1r4nlXuF0ijhkEzbilknhnOEPG5yr3iwvqp2oYMtSCd7PCE6
         dINTrAcX2XxGDCyYQlDksQ5kEWXyGNRQKbHazfaUwv6Rwf3JZSH6y9t/fYNg14dIoWP1
         TaOg==
X-Gm-Message-State: ANhLgQ2uuKOnBjatoNLzaOZZvxYBTxPEnKYDejsELk1ZO3xynxegyV2H
        s3dk29Ke+oLXC0Sl2DuPV34AGnCNMWA=
X-Google-Smtp-Source: ADFU+vshcj4SZOTKdXJZrLuF5kAK/voVdDmGZwtp4jKfjnPFoX3H+X9LbJdlEIVQ3BjfLS7KkFhI4w==
X-Received: by 2002:a1f:9646:: with SMTP id y67mr4307528vkd.21.1584459923113;
        Tue, 17 Mar 2020 08:45:23 -0700 (PDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id b22sm1512079vke.39.2020.03.17.08.45.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:45:22 -0700 (PDT)
Received: by mail-vs1-f45.google.com with SMTP id o3so4101257vsd.4
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 08:45:22 -0700 (PDT)
X-Received: by 2002:a05:6102:1cf:: with SMTP id s15mr4040657vsq.109.1584459921604;
 Tue, 17 Mar 2020 08:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200103045016.12459-1-wgong@codeaurora.org> <20200105.144704.221506192255563950.davem@davemloft.net>
 <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com> <20200317102604.GD1130294@kroah.com>
In-Reply-To: <20200317102604.GD1130294@kroah.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 17 Mar 2020 08:45:09 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XXPACnPt=5=7gH3L6DufZ4tLSPTN-AtTAmvi5KAJuP6A@mail.gmail.com>
Message-ID: <CAD=FV=XXPACnPt=5=7gH3L6DufZ4tLSPTN-AtTAmvi5KAJuP6A@mail.gmail.com>
Subject: Re: [PATCH v2] net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
To:     Greg KH <greg@kroah.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ath11k@lists.infradead.org,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Mar 17, 2020 at 3:26 AM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Feb 25, 2020 at 02:52:24PM -0800, Doug Anderson wrote:
> > Hi,
> >
> >
> > On Sun, Jan 5, 2020 at 2:47 PM David Miller <davem@davemloft.net> wrote:
> > >
> > > From: Wen Gong <wgong@codeaurora.org>
> > > Date: Fri,  3 Jan 2020 12:50:16 +0800
> > >
> > > > The len used for skb_put_padto is wrong, it need to add len of hdr.
> > >
> > > Thanks, applied.
> >
> > I noticed this patch is in mainline now as:
> >
> > ce57785bf91b net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
> >
> > Though I'm not an expert on the code, it feels like a stable candidate
> > unless someone objects.
>
> Stable candidate for what tree(s)?

I noticed that it was lacking and applied cleanly on 5.4.  As of
5.4.25 it's still not stable there.  I only noticed it because I was
comparing all the patches in mainline in "net/qrtr" with what we had
in our tree and stumbled upon this one.

Looking at it a little more carefully, I guess you could say:

Fixes: e7044482c8ac ("net: qrtr: Pass source and destination to
enqueue functions")

...though it will be trickier to apply past commit 194ccc88297a ("net:
qrtr: Support decoding incoming v2 packets") just because the math
changed.

-Doug
