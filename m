Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCAD310203C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 10:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfKSJ00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 04:26:26 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:53238
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbfKSJ0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 04:26:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574155584;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=04R5mjBFNb6yF5rldK/xnzdcVfFmrZckYZJnZOL4I8M=;
        b=VFscHZrpNwIeGbpbsZKLBQTe0zGIQKk2Xiolfc/Y6I+av3WvqffYDuU/9unKQmu7
        m/E8OyWb1XIOaKfUu21yy+iB77JoXLnYLB4x3rIEUdMSwDbgVDqm5eN+pDJ4L3fpZcc
        ykxESjxJMLMtD/RHNzbh/KAt+lrH4qFtjtbvga9I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574155584;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=04R5mjBFNb6yF5rldK/xnzdcVfFmrZckYZJnZOL4I8M=;
        b=HArAs762PzXwUsah1KKvXDOE9OUFf6Fz7XfSXFEFgL/0uwIZjpKVeF6YnrB26rVX
        Jd/a4Kbf/myr+DK96mD6KZq+RRB4NUJch0Ild6uDwPY2d9NBfN1JPUA2eaHX8urbEuS
        giMr7Hb1Wi/NeoF1WRIrfFOzexqrEKoEIKFuSQCo=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D526C447A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Winnie Chang <winnie.chang@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        stable@vger.kernel.org
Subject: Re: [PATCH FIX] brcmfmac: disable PCIe interrupts before bus reset
In-Reply-To: <20191118115308.21963-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Mon, 18 Nov 2019 12:53:08 +0100")
References: <20191118115308.21963-1-zajec5@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
Date:   Tue, 19 Nov 2019 09:26:24 +0000
Message-ID: <0101016e82fc042b-a255d0f0-84e9-4c33-8512-4a3da77d6520-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SES-Outgoing: 2019.11.19-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> Keeping interrupts on could result in brcmfmac freeing some resources
> and then IRQ handlers trying to use them. That was obviously a straight
> path for crashing a kernel.
>
> Example:
> CPU0                           CPU1
> ----                           ----
> brcmf_pcie_reset
>   brcmf_pcie_bus_console_read
>   brcmf_detach
>     ...
>     brcmf_fweh_detach
>     brcmf_proto_detach
>                                brcmf_pcie_isr_thread
>                                  ...
>                                  brcmf_proto_msgbuf_rx_trigger
>                                    ...
>                                    drvr->proto->pd
>     brcmf_pcie_release_irq
>
> [  363.789218] Unable to handle kernel NULL pointer dereference at virtua=
l address 00000038
> [  363.797339] pgd =3D c0004000
> [  363.800050] [00000038] *pgd=3D00000000
> [  363.803635] Internal error: Oops: 17 [#1] SMP ARM
> (...)
> [  364.029209] Backtrace:
> [  364.031725] [<bf243838>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) fr=
om [<bf2471dc>] (brcmf_pcie_isr_thread+0x228/0x274 [brcmfmac])
> [  364.043662]  r7:00000001 r6:c8ca0000 r5:00010000 r4:c7b4f800
>
> Fixes: 4684997d9eea ("brcmfmac: reset PCIe bus on a firmware crash")
> Cc: stable@vger.kernel.org # v5.2+
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> Kalle: if you are planning another pull request for 5.4 you may push
>        this to the wireless-drivers. Otherwise make it
>        wireless-drivers-next and lets have stable maintainers pick it.

Unless the sky falls down I'm not planning to submit anything for v5.4
anymore. So this has to go to -next.

--=20
Kalle Valo
