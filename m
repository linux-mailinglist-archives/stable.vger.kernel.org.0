Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EFA2EF85E
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 20:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbhAHTs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 14:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbhAHTs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 14:48:58 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32BCC061380;
        Fri,  8 Jan 2021 11:48:17 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r5so12283005eda.12;
        Fri, 08 Jan 2021 11:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I8TKAHdoaMvYSSqtTCZDWPAAByIaQ1v5o/szfpAMfPI=;
        b=AFvoo6GF4rLr+/wmxY6an8Ra99XiWLq3NePV7Jm4wKbfP3kzzYk4ibd4/pThs8pDY1
         cT7Z8PSPOVHMFEknsuxrH64bvGD5lnzQgop1iIkEOsSSqxCyrbeUeuD39M5e4zblEwz7
         F9u7NOD1iptwQP+6Ddnk7uWeh+2pCOqP7gzJ2hCR73JtCO/tt3ocbiSnn/IZmhAqYEHx
         I0OxPx5+EMiq1r8vzX3QE8BGH3vjSSrY65Ho7pN3J4eR1qyrnPJeyqjxEi9YShHjguS9
         NQZqUp+IetfWAgdJTRFBVxWOLKC9QCmU1BrObx/dyWjtm0UgmEu+3mFe6NkWSkvwWjSP
         1mQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I8TKAHdoaMvYSSqtTCZDWPAAByIaQ1v5o/szfpAMfPI=;
        b=osZ20ho5fbQCMQN1ZjRvi7O8pl5WmoF7jRvu7ubg/HMXyog3T15YTS7B6uY3ZnbH72
         cf1ftZDN2OjRZf0HWQRBku0JNQgoZGModuNW/3oN3S3rNhB5N+Tdeeen1Z5nLwlYxdKw
         MuBYxyxMhznnObhMrim/1e1wCm1B7ciO06SvlQ463o810saiUQB9RJqPOOV30otnrihh
         Qs1S+/fb6QuXc7XgczB8Qmu+YaQA9Ip8CjPK1d8cAY8zD8XHlQ1bte0WwREj8DQU4J66
         WEGAbB72ydXDE6riNIUUOvfVDRnkneLaBsYRmiqACZrypsKoarKhH2bWg907YaFUVBIE
         t+pw==
X-Gm-Message-State: AOAM531YsAT60QMd095n0byuWPYSoQ6eCsC73fqX3V6U4dj+EjR6ICQZ
        fetvIV6qITpPH2+J/DKzh9Nuyz/HujnDomO0o0w=
X-Google-Smtp-Source: ABdhPJyenGgCHpGwIEFtgOpxprh9mlhrucBVG/ODvez51ZPA9HerfntfYtO/J2aXFHAYBrI30uDivgk3HmS0VlYRDh8=
X-Received: by 2002:a50:fd18:: with SMTP id i24mr6543911eds.146.1610135296578;
 Fri, 08 Jan 2021 11:48:16 -0800 (PST)
MIME-Version: 1.0
References: <20210107224901.2102479-1-dev@kresin.me>
In-Reply-To: <20210107224901.2102479-1-dev@kresin.me>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 8 Jan 2021 20:48:05 +0100
Message-ID: <CAFBinCBm21ZwN2eB8pjWQivkZQp1eC_5=g9M-VwKpRtakJjnHg@mail.gmail.com>
Subject: Re: [PATCH] phy: lantiq: rcu-usb2: wait after clock enable
To:     Mathias Kresin <dev@kresin.me>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 7, 2021 at 11:49 PM Mathias Kresin <dev@kresin.me> wrote:
>
> Commit 65dc2e725286 ("usb: dwc2: Update Core Reset programming flow.")
> revealed that the phy isn't ready immediately after enabling it's
> clocks. The dwc2_check_core_version() fails and the dwc2 usb driver
> errors out.
>
> Add a short delay to let the phy get up and running. There isn't any
> documentation how much time is required, the value was chosen based on
> tests.
>
> Cc: <stable@vger.kernel.org> # v5.7+
> Signed-off-by: Mathias Kresin <dev@kresin.me>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
