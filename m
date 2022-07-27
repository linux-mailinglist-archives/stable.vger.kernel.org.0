Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2B581DF5
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 05:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbiG0DMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 23:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240168AbiG0DMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 23:12:10 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9B41C126;
        Tue, 26 Jul 2022 20:12:09 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id r14so18422284ljp.2;
        Tue, 26 Jul 2022 20:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vjqboMjUafpTNGUy0/O4ZDtfa56hWKNu2C1XCtWQzVA=;
        b=Q5Xo+Bg4msAdmVwzpBwCtILRjoM1yJhUc972HzJcEoCaxF/JjzLsi9okJmR2dCNhnm
         GLf+ZPI3plNCoXTd0rDjKsAy/+/0giq1jUTovcZaTd1Q0f0YgTm1cQt3HeO50O9KQBei
         6eePw2J4KHWgrOvrek1LtHJUQBaHntpaTF2mNAiid10OowP2K4PE/qM49A/tlQUm89PL
         29VElTUpRzd2+CwuIdptK9G5Kr+MeiNSqsdAfHYEEYxEBADiNVC8u3x58tA9zml5XRVh
         MrANXuRRlTbZhlonGdbsWS3O75N/Qv96MXvIYitmfLlpNNME/ty9esOgEokZNkl55fzp
         cGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vjqboMjUafpTNGUy0/O4ZDtfa56hWKNu2C1XCtWQzVA=;
        b=rXow1m0xYhgGLY47UApfiJ2cfDBTR22REM4GynHUgwN4LZuaHIwg7dSCsd3bYvjiaU
         3PTWyS5GX17LoqGC4Z3vZS8w+kgZM3ylb6HXYL/gLqQ4w0AhzYSa/Kyl+mj+ww0q/bnX
         d0BYS5VZ89rT+KA5Xse1Nkn8Dt6KEPd5IFEeCwwoLhiTBLkVgh8B0bH6ILe+f8s8krM2
         dEJNxEXcFCDEaWNk+pAOkxa1OmjVlhmDNkns0rIAK1/4nKzTi+UmhwbLXqZFmo51EV4y
         /MWdi/0m5EARNWxLgc5n8rbNv4NCA1qbON0xsoB9Nscq4o70WP9dWiEiay/CBrPo8Zas
         v9oQ==
X-Gm-Message-State: AJIora/5qwmNELoUjZjuoIs5FjTyB1gq2SQ+LSaruNyHQxOfkgvyak/q
        3KlFj/kPNBxRPPnxicTjwgD18tsDV2dc9uySXw==
X-Google-Smtp-Source: AGRyM1v4Ncd9HBGYmoz4GB4ul2KRx32NDFuoju0Nas2HcyCjW1c4g23bxplhHnlVMchicE6sR/kHzTuS7vhfvbW0uG0=
X-Received: by 2002:a05:651c:1796:b0:25d:7288:ed0b with SMTP id
 bn22-20020a05651c179600b0025d7288ed0bmr6844732ljb.228.1658891527252; Tue, 26
 Jul 2022 20:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220727030526.31022-1-peter.wang@mediatek.com>
In-Reply-To: <20220727030526.31022-1-peter.wang@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Wed, 27 Jul 2022 11:11:55 +0800
Message-ID: <CAGaU9a9FG9DxNsPEC=DDE_ZENn9PGoeQy0BG9FG8p-trdmTNmQ@mail.gmail.com>
Subject: Re: [PATCH v5] ufs: core: correct ufshcd_shutdown flow
To:     peter.wang@mediatek.com
Cc:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>, alim.akhtar@samsung.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        Chun-Hung Wu <chun-hung.wu@mediatek.com>,
        alice.chao@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
        powen.kao@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 11:10 AM <peter.wang@mediatek.com> wrote:
>
> From: Peter Wang <peter.wang@mediatek.com>
>
> After ufshcd_wl_shutdown set device power off and link off,
> ufshcd_shutdown could turn off clock/power.
>
> Also remove pm_runtime_get_sync.
> The reason why here can remove pm_runtime_get_sync is because,
> (1) ufshcd_wl_shutdown -> pm_runtime_get_sync, will resume hba->dev too.
> (2) device resume(turn on clk/power) is not required, even if device is in RPM_SUSPENDED.
>
> Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
