Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F60E4A5D4C
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 14:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbiBANQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 08:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbiBANQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 08:16:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7548AC061714;
        Tue,  1 Feb 2022 05:16:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D18BCB82DE3;
        Tue,  1 Feb 2022 13:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8765EC340EF;
        Tue,  1 Feb 2022 13:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643721382;
        bh=UaVOPrZ2MW3v73wj5jL6yYbvsFi5Uh7hAAKwFmb6cms=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jM2G7l58pX7fzAJNYKR7OGgVw//fL9Zw0pcho/QheJNUDQZKLPBPeiDHMHL1UCzEj
         3YZH1jX1pET95yU3MAS7ok7zbMnO3HExSbrve9Y0n4pVGOtWkruReWjplCEKxv8wuv
         TTjO4XQM34oUWwhxoqre5JJgaD6xksH/Xgbiahjd/Q4QuUSxbtwnrzcvmnV+yXobp5
         RQw+M7LQNuNiAPL6v0oweou/Jbvugev4Zf2IlkhvR/HTp71xHzNml2h1zsyLdXDMEw
         3NMp+kqoB/XvV7i8DtNxM6/Z4EyBx7LpZZxq+I528lm7QWPACvVzYADqh1TGSJL/Oo
         BZcPWe8Ix2kYw==
Received: by mail-ej1-f54.google.com with SMTP id m4so54225821ejb.9;
        Tue, 01 Feb 2022 05:16:22 -0800 (PST)
X-Gm-Message-State: AOAM532rntE3gbN/1qP6WKWAjS1BUrSioOVwwYXxuTknXrrmoG+u0UGs
        JCGr4nSZp4CS1tG7w9GC3IZl3PpZ2+GqnF4ZjA==
X-Google-Smtp-Source: ABdhPJzy9MuzObhcYyskRJVEt40Siz6xKdIKSxIxEJ2Z/KqP2iA7ZjtDgOplHMyrhQzUbUReOMoTRaPXB1JGPeH0oBY=
X-Received: by 2002:a17:907:7f1a:: with SMTP id qf26mr15019342ejc.20.1643721380863;
 Tue, 01 Feb 2022 05:16:20 -0800 (PST)
MIME-Version: 1.0
References: <20220106103645.2790803-1-festevam@gmail.com>
In-Reply-To: <20220106103645.2790803-1-festevam@gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 1 Feb 2022 07:16:09 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+_qASKWhoLHgnaypVjuDwHwAovke48PQFXUenO2JoEDw@mail.gmail.com>
Message-ID: <CAL_Jsq+_qASKWhoLHgnaypVjuDwHwAovke48PQFXUenO2JoEDw@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: imx6: Allow to probe when dw_pcie_wait_for_link() fails
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Richard Zhu <hongxing.zhu@nxp.com>,
        PCI <linux-pci@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 6, 2022 at 4:36 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> The intention of commit 886a9c134755 ("PCI: dwc: Move link handling into
> common code") was to standardize the behavior of link down as explained
> in its commit log:
>
> "The behavior for a link down was inconsistent as some drivers would fail
> probe in that case while others succeed. Let's standardize this to
> succeed as there are usecases where devices (and the link) appear later
> even without hotplug. For example, a reconfigured FPGA device."
>
> The pci-imx6 still fails to probe when the link is not present, which
> causes the following warning:
>
> imx6q-pcie 8ffc000.pcie: Phy link never came up
> imx6q-pcie: probe of 8ffc000.pcie failed with error -110
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 30 at drivers/regulator/core.c:2257 _regulator_put.part.0+0x1b8/0x1dc
> Modules linked in:
> CPU: 0 PID: 30 Comm: kworker/u2:2 Not tainted 5.15.0-next-20211103 #1
> Hardware name: Freescale i.MX6 SoloX (Device Tree)
> Workqueue: events_unbound async_run_entry_fn
> [<c0111730>] (unwind_backtrace) from [<c010bb74>] (show_stack+0x10/0x14)
> [<c010bb74>] (show_stack) from [<c0f90290>] (dump_stack_lvl+0x58/0x70)
> [<c0f90290>] (dump_stack_lvl) from [<c012631c>] (__warn+0xd4/0x154)
> [<c012631c>] (__warn) from [<c0f87b00>] (warn_slowpath_fmt+0x74/0xa8)
> [<c0f87b00>] (warn_slowpath_fmt) from [<c076b4bc>] (_regulator_put.part.0+0x1b8/0x1dc)
> [<c076b4bc>] (_regulator_put.part.0) from [<c076b574>] (regulator_put+0x2c/0x3c)
> [<c076b574>] (regulator_put) from [<c08c3740>] (release_nodes+0x50/0x178)
>
> Fix this problem by ignoring the dw_pcie_wait_for_link() error like
> it is done on the other dwc drivers.
>
> Tested on imx6sx-sdb and imx6q-sabresd boards.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 886a9c134755 ("PCI: dwc: Move link handling into common code")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
> Changes since v1:
> - Remove the printk timestamp from the kernel warning log (Richard).
>
>  drivers/pci/controller/dwc/pci-imx6.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
