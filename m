Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F14B4B3E7C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 00:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbiBMX4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 18:56:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbiBMX4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 18:56:41 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1510051E5B
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 15:56:34 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id p5so41123053ybd.13
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 15:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZ2kK0goc3/vjQqJIQMCKc+OYazRpzayZNMisgl9DFY=;
        b=UP5OSsTqlReuUnbYMjUGsL07qwGo7iGqMbPaC3XQc1yjarLVGAyAoXdgCfAZvy9Wrh
         ZAFE5Qkgn4zkOwCNh3AWmw5f5G54p3pJlh7Z1qX6vphAcDEdzpJs2LTM7CsuMaycDpSU
         s/wSCrEGOjne/99Kmr34ZzlBLB7FSyWrFCQq7T8cq9rMqsM4QrovBMa3h6AMDN0t7nHt
         jf4vLcYwxJrkI/+yftzPmnvTXkGl8tzgPNcoYU3CDkdtUSmX+M88j6cxOz/PUyzZ+D//
         77lm8yz2tr+RH/gZVkTQJF8f8ZbL3IDr57f3MG8QRfQF6Q8eyRW/BA55Hvj8UEogih4H
         Dcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZ2kK0goc3/vjQqJIQMCKc+OYazRpzayZNMisgl9DFY=;
        b=tyySeOrSv0E7nLK6Xl0ezw/ofXHpOZOfFNzl2VRw5ganKeKJleEBmLiyDLbsjPK399
         z8zuJuPdV4hANHg7gQJXjgQyLm0hqeVC+1p/WV/tuIT1LB6fTrrBPwpQLRmikosjfZae
         BWWeO0RP5zaGp8GJKBSoSWXKRRXwCGs+bHp1XznlHmRz/5ApsoctiGfwBY2yeE7EL60H
         Se/bcovKWA8Qe7wIbllxBtQ8++VrnpYhl9snX4m7JJ3dGF65sNHYPgtBHBjHzPzMP3Qu
         wMQWeG/NdWqqf/PFM+TXSFDnbpS4Wk5eThQfLVjC/jR4Mhhiwg4n46dDZ+Pa+Hdh8dvw
         838w==
X-Gm-Message-State: AOAM531p/wwL2l8ShY24dsZyv39BH013xoHNvC4XdkOw3DKZ+uZb4Mrg
        WyxVnYER2ZwtWGkFOLzCp82vfvt23TlJW6PmQencOnR5JtKIpK4p
X-Google-Smtp-Source: ABdhPJyg3vLyU0FBozuNK3IsfFSagbJAV6M3fTahC/Il4vNxR7f8zu0weiIO18uCVj4p/4tDjSzhjpyqTVsW4G9TlRE=
X-Received: by 2002:a25:ce03:: with SMTP id x3mr10298940ybe.587.1644796593303;
 Sun, 13 Feb 2022 15:56:33 -0800 (PST)
MIME-Version: 1.0
References: <20210720144115.1525257-1-linus.walleij@linaro.org>
In-Reply-To: <20210720144115.1525257-1-linus.walleij@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 14 Feb 2022 00:56:22 +0100
Message-ID: <CACRpkdZHhGu_E+WZQ2rCXHdnWKe6oEO_heaOnf2dYuaOoXOe5Q@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: core: Add a card quirk for non-hw busy detection
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc:     stable@vger.kernel.org, phone-devel@vger.kernel.org,
        Ludovic Barre <ludovic.Barre@st.com>,
        Stephan Gerhold <stephan@gerhold.net>, newbyte@disroot.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some updates on this issue:

We no longer get lockups as of kernel v5.17-rc1.

The console however says things like this:

[    1.979485] mmci-pl18x 80005000.mmc: mmc2: PL180 manf 80 rev4 at
0x80005000 irq 93,0 (pio)
[    1.987943] mmci-pl18x 80005000.mmc: DMA channels RX dma0chan6, TX dma0chan7
[    3.204496] mmc2: Card stuck being busy! __mmc_poll_for_busy
[    4.284431] mmc2: Card stuck being busy! __mmc_poll_for_busy

And after this it never finds the partitions on the card.

So the issue isn't gone, eMMC is still unusable on Skomer and Codina,
but the issue no longer hangs the whole MMC/SD stack which is nicer.

Yours,
Linus Walleij
