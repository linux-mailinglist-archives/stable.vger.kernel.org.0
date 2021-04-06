Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9BB354C48
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 07:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242733AbhDFF1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 01:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242572AbhDFF1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 01:27:07 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2055DC061574
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 22:27:00 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id k8so7540283edn.6
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 22:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O4Bg6lHEr1Bcp5d6hAJjcBdq76xAwkKeYR92aKtHBrs=;
        b=VMz+w4Z3Cf8+n+GEU9s0APy0+L0oywRZagtG4g41FfPnUb5CJW0hQryA99cORzbefn
         Ej04TiGNCvF+yUlQ4aihFZI5J6+PgCbfssuD4kjGR1w/hG3GWeIj2gy3V/bt5Oj8ksNR
         cieGQBP6RAGYirbYixfrugimIHCV7UWez6BGZgxlgIVwKA1ftzk2qbB/yoTzIMHeVbrR
         aIayZnAUk7pbRdzpnEf7tVqm7B64u/vuEZiAxpoAk0Zbplwjbv6PicO0JU0C0LAh1wmA
         7mRNKSrsfblKKvdHFVCmg/rS1rHC4rNvv0/nEC92Id0nOVufjtGbmNnV69ta43iKKr4Y
         /5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O4Bg6lHEr1Bcp5d6hAJjcBdq76xAwkKeYR92aKtHBrs=;
        b=E7Zj99nhnibSKpmEflY+IcnAU4nSSupoQhXbuL42RBvSsC5UsqDR2V5nGiO1wVNrVG
         WBwE5FqSS9E3sC+B4KuQIFyMF33QCBFcQPkTDj2eFByK0rZtz4piwuGlnuaBMJuRs9gY
         Se55OPDz4ty6QJcJinxtNg5oexOZwLTL3dRdQmYXqK/WDtrp9UCSTrTwUSXQq7hkUFCk
         irniqn5KsSBggyr/mWRmDsMiVyE/HmHyT4NjtbueO/vviY8VZwbdjQ6BSXlcGz0iSLuN
         bsVt1LCNcGEFB1oswShxIQPGcNSP3+eVsrfgLjzQ5tBPX+Gp5EBBS8KUQeZ6RA/jNswe
         svjA==
X-Gm-Message-State: AOAM531etfxEbkLZJUfgmlUhhEpjTG+lsylEGIKHMAvZ+iPohUO6cn9+
        rbAUfCy9DRXzIW3njBg3KwAty58dy7L7SXTjjOc6CA==
X-Google-Smtp-Source: ABdhPJx3y9Qe65TDZI1Pw1aAaP4YrrLaBKafANPnboI6z3akSWt8D9TMbGpmHJu9LAJXlyJf1aVxNSBsNc5FFZJCaYc=
X-Received: by 2002:a05:6402:447:: with SMTP id p7mr35524862edw.89.1617686818934;
 Mon, 05 Apr 2021 22:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210402054212.17834-1-Viswas.G@microchip.com.com> <161768453466.32039.5842026607462396914.b4-ty@oracle.com>
In-Reply-To: <161768453466.32039.5842026607462396914.b4-ty@oracle.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 6 Apr 2021 07:26:48 +0200
Message-ID: <CAMGffEnDBRjMfdbnJpCTGse+LoHLHoNE_QadrwBEMif5c+_6dw@mail.gmail.com>
Subject: Re: [PATCH 1/1] pm80xx: Fix chip initialization failure
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Viswas G <Viswas.G@microchip.com>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Ash Izat <ash@ai0.uk>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 6, 2021 at 6:52 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> On Fri, 2 Apr 2021 11:12:12 +0530, Viswas G wrote:
>
> > Inbound and outbound queues are not properly configured and
> > that leads to MPI configuration failure.
> >
> > Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
> >
> > Cc: stable@vger.kernel.org # 5.10+
>
> Applied to 5.12/scsi-fixes, thanks!

Thanks for taking care of this.

Regards!
>
> [1/1] pm80xx: Fix chip initialization failure
>       https://git.kernel.org/mkp/scsi/c/65df7d1986a1
>
> --
> Martin K. Petersen      Oracle Linux Engineering
