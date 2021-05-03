Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6635371617
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 15:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhECNmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 09:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234193AbhECNmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 09:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 417E261208;
        Mon,  3 May 2021 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620049302;
        bh=HC2d4sryXYEKw/mdCuZdVqcRyJ24TNA7pyXrQpSWiRQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Jhu7vIb7y4JVgGjvd3KXpTEMQ2NH5/7QBn7A1K4I8JRTuwF6gLoDdvbwmdaua+hAk
         hNZJhZLTvQXEaukRhPCrFQ6qYtYsVQIJok95D0N3xrO2+6en7w4e12x9zd8YjRnnn+
         ROmZXBliIlJG2oT1Uyt8T74gkPo9lnU+dV2f9EHRSL0/1C8awvPavIKlGTUtYsFjwR
         +cJmCSrt9Q+aPxmZCU9+49as+bQ1M+wecNTiDJ01GI0zmDI386hwLoC2KaYViDbf0M
         LNdMiySN3jDKAjyKPQO4ZzYBNfuqeAr5n7XWJJMPts49TEDOD4MOxrhC5E8b4WEVMW
         Rk5FaCB2vVEWg==
Received: by mail-ej1-f43.google.com with SMTP id l4so7888058ejc.10;
        Mon, 03 May 2021 06:41:42 -0700 (PDT)
X-Gm-Message-State: AOAM533llV/ZvLK8dMYHR29n78G15bq68C/ldaBWs0N2/aWyVcoVbTEz
        mx22wc9vkqqy/IE88D0Jn/KNU+O40wZ3dkoGdQ==
X-Google-Smtp-Source: ABdhPJyNu3uA4Iu/SjUcKvYm7Jyu7ouxKOKGrhC1U58NoSGkwGIU4s3nhfpxPL62pbbvrVXSGZJznxMVuZVT4lri8fc=
X-Received: by 2002:a17:906:18e1:: with SMTP id e1mr16505077ejf.341.1620049300677;
 Mon, 03 May 2021 06:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org> <20210503115736.2104747-67-gregkh@linuxfoundation.org>
In-Reply-To: <20210503115736.2104747-67-gregkh@linuxfoundation.org>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 3 May 2021 08:41:28 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKmx_yihD_627jHHyuH+xpi3_iJ=ekXcoV5FT6NDRWJRg@mail.gmail.com>
Message-ID: <CAL_JsqKmx_yihD_627jHHyuH+xpi3_iJ=ekXcoV5FT6NDRWJRg@mail.gmail.com>
Subject: Re: [PATCH 66/69] Revert "video: imsttfb: fix potential NULL pointer dereferences"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kangjie Lu <kjlu@umn.edu>, Aditya Pakki <pakki001@umn.edu>,
        Finn Thain <fthain@telegraphics.com.au>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 3, 2021 at 7:01 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This reverts commit 1d84353d205a953e2381044953b7fa31c8c9702d.
>
> Because of recent interactions with developers from @umn.edu, all
> commits from them have been recently re-reviewed to ensure if they were
> correct or not.
>
> Upon review, this commit was found to be incorrect for the reasons
> below, so it must be reverted.  It will be fixed up "correctly" in a
> later kernel change.
>
> The original commit here, while technically correct, did not fully
> handle all of the reported issues that the commit stated it was fixing,
> so revert it until it can be "fixed" fully.
>
> Note, ioremap() probably will never fail for old hardware like this, and
> if anyone actually used this hardware (a PowerMac era PCI display card),
> they would not be using fbdev anymore.
>
> Cc: Kangjie Lu <kjlu@umn.edu>
> Cc: Aditya Pakki <pakki001@umn.edu>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Fixes: 1d84353d205a ("video: imsttfb: fix potential NULL pointer dereferences")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/video/fbdev/imsttfb.c | 5 -----
>  1 file changed, 5 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
