Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB58103579
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 08:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfKTHpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 02:45:55 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:60652
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727052AbfKTHpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 02:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574235955;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=p8K3o/lFoopCfjZ/JulFFvlJ/OXXANqrw/rnnKXfsCk=;
        b=GkzC7HDxYFptORcQOJLXvvWVz6vFvvRzhjnWOgs8CH/PXtREz+tjhG9yuXhRkPc1
        cQMtI6WxMR9NiETmzxJjk6eaUIzM6dbFE4eNzN0a0h/OoT3QafojepkXp+E2SOjVKTe
        LIX/dLbTY5ecQw96sttL2UjBNRmpLNKrmgyCRYT0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574235955;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=p8K3o/lFoopCfjZ/JulFFvlJ/OXXANqrw/rnnKXfsCk=;
        b=XS++2RSdUelFAwjoZr61ZyYbhdtTShes3dNX44g6b+DgHZpSS/qc+Z/805/Fi3ph
        2ol5gOfYvIpWrRIaQwkIt4g8b1NUQ9ez8qlYLhywrEpKeXrc/TEfDZkl1H8BVmJ5+Sn
        1JwyAzD5UlZBG19/pNX3jSeh8/7BNXgFn/oIizXM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1CD61C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH FIX] brcmfmac: disable PCIe interrupts before bus reset
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191118115308.21963-1-zajec5@gmail.com>
References: <20191118115308.21963-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
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
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016e87c65ed5-2079be01-c96f-4861-91cb-108117dbb861-000000@us-west-2.amazonses.com>
Date:   Wed, 20 Nov 2019 07:45:54 +0000
X-SES-Outgoing: 2019.11.20-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
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
> [  363.789218] Unable to handle kernel NULL pointer dereference at virtual address 00000038
> [  363.797339] pgd = c0004000
> [  363.800050] [00000038] *pgd=00000000
> [  363.803635] Internal error: Oops: 17 [#1] SMP ARM
> (...)
> [  364.029209] Backtrace:
> [  364.031725] [<bf243838>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf2471dc>] (brcmf_pcie_isr_thread+0x228/0x274 [brcmfmac])
> [  364.043662]  r7:00000001 r6:c8ca0000 r5:00010000 r4:c7b4f800
> 
> Fixes: 4684997d9eea ("brcmfmac: reset PCIe bus on a firmware crash")
> Cc: stable@vger.kernel.org # v5.2+
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

5d26a6a6150c brcmfmac: disable PCIe interrupts before bus reset

-- 
https://patchwork.kernel.org/patch/11249683/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

