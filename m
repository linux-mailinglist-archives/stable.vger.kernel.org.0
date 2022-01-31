Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A104A47BE
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 14:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359827AbiAaNIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 08:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359493AbiAaNIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 08:08:18 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160B0C061714;
        Mon, 31 Jan 2022 05:08:18 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id jx6so43268509ejb.0;
        Mon, 31 Jan 2022 05:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yer1h7Q57Hhc2AYJOkeuOjCbI45J4/n82MO+BUV/L6A=;
        b=CMTks2J9DDKj9XdR3mizU4peWg5dztMTAaft+NdZxUhxPbNVKGvvB4xugW5zVDy276
         48kjOOnr6vv1IiJMHgDdE2C0VLf/kCutpuWb3q545WnyTSSnwVYaZ1Ff4IMdU+4zz1ho
         +HexvB+ZuWG6q1PoQFVsCkLlpvuDIJ5KPjLeaqFwKVefxhc/rOTcIj/htlh+8pFxn4nn
         gOKf9LHTgK+ii4cXhZgv5xMJ/tQTJJH9Zxb7QJoObjgME//pJT39DIvKh7XdPvuYAX5f
         bMFBzAOcGAhbWVUjGVDsr1a0mUUehIJNb4m95Wf4El1DJgsAbRGyv+cNbvdmIPr6Fs4A
         aOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yer1h7Q57Hhc2AYJOkeuOjCbI45J4/n82MO+BUV/L6A=;
        b=E+H+9nNgpAs/GmJgG9f2lv/5GkWAuhA+mKLOxHg20Bpwag/skmhxZwqv6pYSppfll6
         zuEwkWvGdIU93R1Zcbk8DrGlvTLbsXMuunmmtJvxdCMqd+AJUEviAr01Ca9FDMZW1wmu
         WwSPzD+nhhVmsQSvuTYdleIweaivWHdds7QtMlQTnL2kp44ksFiSi97k59oCcgilYqGY
         LJi04OJEBK49KG2Ye2XcvY0Wr6oBRlUAA1J8txr7xx8CFStwVTyLBJHP78USGNibgDGT
         0kb9gfpCbI0TzB4sVVW7a1LWKGUPf0zK916Wgmm9K6nSxZTUylwr0C37gluVtOTbtfta
         Frpg==
X-Gm-Message-State: AOAM531hQ4U3+7ptW7BJ6ZXnWSKmF+9LLDemnm6idmJecaCpuihZ6XsW
        iDnPhfWYWPdjxk9Rut6VuUiiy+UlfdLJMmQ/8ag=
X-Google-Smtp-Source: ABdhPJyYuRJF9jhsS6htnks95+TXwh92ECeMBjs7V6X0/AuPJBJRMTD55grtSN6JmLZpUReL12VcaJs3nx1qoMPilD4=
X-Received: by 2002:a17:907:7ba9:: with SMTP id ne41mr17436998ejc.4.1643634496530;
 Mon, 31 Jan 2022 05:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20220106103645.2790803-1-festevam@gmail.com> <AS8PR04MB8676540C48042F8E71D45E098C4D9@AS8PR04MB8676.eurprd04.prod.outlook.com>
In-Reply-To: <AS8PR04MB8676540C48042F8E71D45E098C4D9@AS8PR04MB8676.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 31 Jan 2022 10:08:05 -0300
Message-ID: <CAOMZO5BjkfBzza6nRHFN+BtaPjC8d=c6Vu1GVmDg=Vbos2ucMg@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: imx6: Allow to probe when dw_pcie_wait_for_link() fails
To:     Hongxing Zhu <hongxing.zhu@nxp.com>
Cc:     "bhelgaas@google.com" <bhelgaas@google.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 7, 2022 at 12:12 AM Hongxing Zhu <hongxing.zhu@nxp.com> wrote:
>
> > -----Original Message-----
> > From: Fabio Estevam <festevam@gmail.com>
> > Sent: Thursday, January 6, 2022 6:37 PM
> > To: bhelgaas@google.com
> > Cc: lorenzo.pieralisi@arm.com; robh@kernel.org;
> > l.stach@pengutronix.de; Hongxing Zhu <hongxing.zhu@nxp.com>;
> > linux-pci@vger.kernel.org; Fabio Estevam <festevam@gmail.com>;
> > stable@vger.kernel.org
> > Subject: [PATCH v2] PCI: imx6: Allow to probe when
> > dw_pcie_wait_for_link() fails
> >
> > The intention of commit 886a9c134755 ("PCI: dwc: Move link handling
> > into common code") was to standardize the behavior of link down as
> > explained in its commit log:
> >
> > "The behavior for a link down was inconsistent as some drivers would fail
> > probe in that case while others succeed. Let's standardize this to succeed
> > as there are usecases where devices (and the link) appear later even
> > without hotplug. For example, a reconfigured FPGA device."
> >
> > The pci-imx6 still fails to probe when the link is not present, which causes
> > the following warning:
> >
> > imx6q-pcie 8ffc000.pcie: Phy link never came up
> > imx6q-pcie: probe of 8ffc000.pcie failed with error -110 ------------[ cut
> > here ]------------
> > WARNING: CPU: 0 PID: 30 at drivers/regulator/core.c:2257
> > _regulator_put.part.0+0x1b8/0x1dc Modules linked in:
> > CPU: 0 PID: 30 Comm: kworker/u2:2 Not tainted 5.15.0-next-20211103
> > #1 Hardware name: Freescale i.MX6 SoloX (Device Tree)
> > Workqueue: events_unbound async_run_entry_fn [<c0111730>]
> > (unwind_backtrace) from [<c010bb74>] (show_stack+0x10/0x14)
> > [<c010bb74>] (show_stack) from [<c0f90290>]
> > (dump_stack_lvl+0x58/0x70) [<c0f90290>] (dump_stack_lvl) from
> > [<c012631c>] (__warn+0xd4/0x154) [<c012631c>] (__warn) from
> > [<c0f87b00>] (warn_slowpath_fmt+0x74/0xa8) [<c0f87b00>]
> > (warn_slowpath_fmt) from [<c076b4bc>]
> > (_regulator_put.part.0+0x1b8/0x1dc)
> > [<c076b4bc>] (_regulator_put.part.0) from [<c076b574>]
> > (regulator_put+0x2c/0x3c) [<c076b574>] (regulator_put) from
> > [<c08c3740>] (release_nodes+0x50/0x178)
> >
> > Fix this problem by ignoring the dw_pcie_wait_for_link() error like it is
> > done on the other dwc drivers.
> >
> > Tested on imx6sx-sdb and imx6q-sabresd boards.
> >
> > Cc: <stable@vger.kernel.org>
> > Fixes: 886a9c134755 ("PCI: dwc: Move link handling into common code")
> > Signed-off-by: Fabio Estevam <festevam@gmail.com>
> [Richard Zhu] Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>

A gentle ping on this one.
