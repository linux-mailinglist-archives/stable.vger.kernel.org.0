Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BEB258BB0
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 11:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIAJey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 05:34:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38077 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgIAJew (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 05:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598952891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o5Y78x1ZbIMZDcyiKJ8JiDFugDPHcPR0uo/OCjQ9IBA=;
        b=I8R7EcxOU0XtL+pSEfK5zUjs+J42RTLpdjNvPLzd6qe7g86xvZNzRuiL7ZtlctWiry3QDt
        9U6d1zXO9kfVNikqkEQ7baOT7CFS7tPKD6vnstHE0QYniKR2kASntVIQEQijO9e+OsC/WM
        Q+7d/Nnu99ZGsRhhIjqLw9iEq/MDYsg=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-d7YiLiT8MJWZjRAyCm0kmQ-1; Tue, 01 Sep 2020 05:34:49 -0400
X-MC-Unique: d7YiLiT8MJWZjRAyCm0kmQ-1
Received: by mail-pf1-f197.google.com with SMTP id x2so320533pfd.8
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 02:34:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o5Y78x1ZbIMZDcyiKJ8JiDFugDPHcPR0uo/OCjQ9IBA=;
        b=IfTXAfgdkwmy97p5pRg085V6e0M+ykLM0mUFP8GJ5VVBTGFd3BEkHTWPhecl4yv8mi
         Yl+GE0JMR68GS3I1UMqQzIff4DJkc+iT/DMXvI9wZMRdwBdzNHaEDSxxTbRTd1EaQR+I
         R7Mq2x80jFVjYGMdsr1bftRATKLVmRWHJtLgwhbkxN1aV04ISGhEgjlAk1rxwdUieePN
         F2mdwgomJlikntp40k64wADaGn3+IFDaNahZ63La2y/wrjnKkSwBpfZ4PjtvgWdKmy4m
         I5mUkcXM3fq2GRRUNDLjl7JcRPEtaeNOZkK38Lio7+l08rNTnypU5L0DGQaAjOZaFlO0
         i1aw==
X-Gm-Message-State: AOAM533dV42x+4BIr0Rs8/nkJzpZU4sQLlN9Cmv1AWQN2Zhw3GzeVwFF
        J8wMPxcT6VTn7V0U321gzMb7Aiq0qSl+rW8QVTR1ZV8mVkc0ymAx/x3pQpPF0hgJPJyxuMSREvT
        3EJKIcVaftHMbvUHLEBJyHg7Rm6X0Wyhl
X-Received: by 2002:a63:6e01:: with SMTP id j1mr743709pgc.147.1598952888715;
        Tue, 01 Sep 2020 02:34:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWGx5gRzrr+E1Ah23gCssdxWPYkby9RSfbimJo07tkodnjtRxFh3BSEUXgTJbgP/qmIUT/Y2585CMTPSDc8ZE=
X-Received: by 2002:a63:6e01:: with SMTP id j1mr743688pgc.147.1598952888314;
 Tue, 01 Sep 2020 02:34:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200829112601.1060527-1-maz@kernel.org> <nycvar.YFH.7.76.2009011013400.4671@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.2009011013400.4671@cbobk.fhfr.pm>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 1 Sep 2020 11:34:37 +0200
Message-ID: <CAO-hwJKa9QWxEo7PvCEjoEG3YZLS+1EKvaC8C3pga7R9Yc5_tw@mail.gmail.com>
Subject: Re: [PATCH] HID: core: Correctly handle ReportSize being zero
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 1, 2020 at 10:14 AM Jiri Kosina <jikos@kernel.org> wrote:
>
> On Sat, 29 Aug 2020, Marc Zyngier wrote:
>
> > It appears that a ReportSize value of zero is legal, even if a bit
> > non-sensical. Most of the HID code seems to handle that gracefully,
> > except when computing the total size in bytes. When fed as input to
> > memset, this leads to some funky outcomes.
> >
> > Detect the corner case and correctly compute the size.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
>
> Thanks Marc; Benjamin will be pushing this patch through his regression
> testing machinery, and if all is good, I'll push it for 5.9-rc still.

Test results were good. I have now pushed this patch to for-5.9/upstream-fixes

Cheers,
Benjamin

>
> --
> Jiri Kosina
> SUSE Labs
>

