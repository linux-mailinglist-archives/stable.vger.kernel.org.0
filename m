Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09A646B437
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 08:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhLGHrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 02:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhLGHrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 02:47:47 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA265C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 23:44:17 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id z21so9421414lfu.8
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 23:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZnCX1L7P9G+B1Vs43uOrlGg0q/TNmHjNB6lJj8IG4e8=;
        b=XUGwj4FwsXOHgrbkMFHdG9X5APBb5lhYszRRYrYFySRbayuFbY952MeCzaaZ3x4PBw
         VNKdEq+biAvsxHOkvEHgYGX1D8nOzTk7b5IdjuZz9zpjDPQcxG+/oMHLVinGLZefD6F+
         nw5gwQkSXK/3Qjx1tIWa32zmSIt7yq+1jSAj5IcEvNYaGfEpIqIdKONKN/t6vLMS+vC/
         ZRXq+gb42oBDsaEmDMchCrAXLoGcmRqO7rLK4W+S+v2nK9TJTpxzV5SmiBM/AprqE68j
         EfgrTOnSiPnMXaBi7WN3Yg+rPXU4LYXEDeXHRWfGUjiPoNpWwAAHR9WEpysSp2vrDYNf
         ijug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZnCX1L7P9G+B1Vs43uOrlGg0q/TNmHjNB6lJj8IG4e8=;
        b=hwE945Qf7fh9KoqNNvIpP5EfuWHaFeYoRyLrVs8LqD/fJeMzSZAsTaZ7UX0WfZs3BJ
         hfJwEWZ91FvMwQGNzb1Kz2mu2e/JDeaSELi0//fXjd2WK5treOQzScHgEM7tPMDlPU+F
         17ghr5DeVN/KJWRviuw+G3Tv3gBuw5L1mf8Hr4yubAKnaCCn9ZJSYukmrfwktzXum8K/
         fHdixNXrkMf4+MGwIwH1ruGAJ7NwauP+v6IXEFhsBoERNx0EzGuwlSBn1CqtLf2br3h0
         qR4PVRA0z1vBw0DFfuDZ61OhQfTFPGawLU7bcwvnrlPHCWp8WZ0lA/YlRtzG+225szC2
         /81g==
X-Gm-Message-State: AOAM530EpBggKLDIoWKHhM+cM947rmheB+BuG09xoX8USHYCWRCRjCWL
        spkTdWp/Bl4mGqv10757NT3vAL6Y1Xjyr8y3UjeZkg==
X-Google-Smtp-Source: ABdhPJzwbJ+AmwlUxupF37WJgIpFtFfggIdfhyWyrwmYld6riTYG/enamZ6VzXuHPFbXRIRNmoXnaKAQ9+M1/sQAgJI=
X-Received: by 2002:a05:6512:118b:: with SMTP id g11mr36461383lfr.46.1638863056070;
 Mon, 06 Dec 2021 23:44:16 -0800 (PST)
MIME-Version: 1.0
References: <20210621070058.37682-1-mie@igel.co.jp> <ed4de030-e0b3-503f-f0dc-75b103769dfc@ti.com>
In-Reply-To: <ed4de030-e0b3-503f-f0dc-75b103769dfc@ti.com>
From:   Shunsuke Mie <mie@igel.co.jp>
Date:   Tue, 7 Dec 2021 16:44:05 +0900
Message-ID: <CANXvt5r-1+W91DXNcVuRxTE0_T0TSGuduMhOfmYgY=N87uzqCg@mail.gmail.com>
Subject: Re: [PATCH] PCI: endpoint: Fix use after free in pci_epf_remove_cfs()
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kishon,

2021=E5=B9=B412=E6=9C=887=E6=97=A5(=E7=81=AB) 16:26 Kishon Vijay Abraham I =
<kishon@ti.com>:
>
> Hi Shunsuke,
>
> On 21/06/21 12:30 pm, Shunsuke Mie wrote:
> > All of entries are freed in a loop, however, the freed entry is accesse=
d
> > by list_del() after the loop.
> >
> > When epf driver that includes pci-epf-test unload, the pci_epf_remove_c=
fs()
> > is called, and occurred the use after free. Therefore, kernel panics
> > randomly after or while the module unloading.
> >
> > I tested this patch with r8a77951-Salvator-xs boards.
>
> Can you provide the crash dump?
Ok. However, that is use-after-free bug. so, the crash log is changed rando=
mly.
I'll send some crash dumps.
> >
> > Fixes: ef1433f ("PCI: endpoint: Create configfs entry for each pci_epf_=
device_id table entry")
> > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> > ---
> >  drivers/pci/endpoint/pci-epf-core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/pci/endpoint/pci-epf-core.c b/drivers/pci/endpoint=
/pci-epf-core.c
> > index e9289d10f822..538e902b0ba6 100644
> > --- a/drivers/pci/endpoint/pci-epf-core.c
> > +++ b/drivers/pci/endpoint/pci-epf-core.c
> > @@ -202,8 +202,10 @@ static void pci_epf_remove_cfs(struct pci_epf_driv=
er *driver)
> >               return;
> >
> >       mutex_lock(&pci_epf_mutex);
> > -     list_for_each_entry_safe(group, tmp, &driver->epf_group, group_en=
try)
> > +     list_for_each_entry_safe(group, tmp, &driver->epf_group, group_en=
try) {
> > +             list_del(&group->group_entry);
>
> Need full crash dump to see if this is really required or not. Ideally th=
is
> should be handled by configfs (or a configfs API could be used).
>
> Thanks,
> Kishon
