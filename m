Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688D42351B6
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 12:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgHAKgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 06:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbgHAKgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Aug 2020 06:36:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3319120716;
        Sat,  1 Aug 2020 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596278205;
        bh=ypc9SaC58w/7F3+0+sN/r0ObXpVEV3kJQ6nBsLVAAxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2SLoBz1Pq8c+pEoor6GhvHjucyuDZbGMvye6gtHDO9u8QEXDJ+jaXonPPoUom90yY
         gpHlrhj8+zJkHRuAP913/KdQfO4Y9x83yV9HzTU/x0r1xufvsj3nmWkD57AfUx8wjK
         Nx0Vv5peiv6laQ6wStTFxfft8xdhqhoQAOKmPkBU=
Date:   Sat, 1 Aug 2020 12:36:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Robert Hancock <hancockrwd@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Nominate "PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085
 PCIe-to-PCI bridge" for stable
Message-ID: <20200801103630.GC3046974@kroah.com>
References: <CADLC3L20-OaNXhNQ-uW29XPQv0uus8zwLcv=vk-YGL=0P3sdeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADLC3L20-OaNXhNQ-uW29XPQv0uus8zwLcv=vk-YGL=0P3sdeA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 07:22:22PM -0600, Robert Hancock wrote:
> I would like to nominate the following commit, now in mainline, for
> stable. This fixes an issue exposed by commit 66ff14e59e8a ("PCI/ASPM:
> Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges") and so should go
> into all stable branches which that was backported to (which appears
> to be all of the currently maintained releases).
> 
> commit b361663c5a40c8bc758b7f7f2239f7a192180e7c
> Author: Robert Hancock <hancockrwd@gmail.com>
> Date:   Tue Jul 21 20:18:03 2020 -0600
> 
>     PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge
> 
>     Recently ASPM handling was changed to allow ASPM on PCIe-to-PCI/PCI-X
>     bridges.  Unfortunately the ASMedia ASM1083/1085 PCIe to PCI bridge device
>     doesn't seem to function properly with ASPM enabled.  On an Asus PRIME
>     H270-PRO motherboard, it causes errors like these:
> 
>       pcieport 0000:00:1c.0: AER: PCIe Bus Error: severity=Corrected,
> type=Data Link Layer, (Transmitter ID)
>       pcieport 0000:00:1c.0: AER:   device [8086:a292] error
> status/mask=00003000/00002000
>       pcieport 0000:00:1c.0: AER:    [12] Timeout
>       pcieport 0000:00:1c.0: AER: Corrected error received: 0000:00:1c.0
>       pcieport 0000:00:1c.0: AER: can't find device of ID00e0
> 
>     In addition to flooding the kernel log, this also causes the machine to
>     wake up immediately after suspend is initiated.
> 
>     The device advertises ASPM L0s and L1 support in the Link Capabilities
>     register, but the ASMedia web page for ASM1083 [1] claims "No PCIe ASPM
>     support".
> 
>     Windows 10 (build 2004) enables L0s, but it also logs correctable PCIe
>     errors.
> 
>     Add a quirk to disable ASPM for this device.
> 
>     [1] https://www.asmedia.com.tw/eng/e_show_products.php?cate_index=169&item=114
> 
>     [bhelgaas: commit log]
>     Fixes: 66ff14e59e8a ("PCI/ASPM: Allow ASPM on links to
> PCIe-to-PCI/PCI-X Bridges")
>     Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208667
>     Link: https://lore.kernel.org/r/20200722021803.17958-1-hancockrwd@gmail.com
>     Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Now queued up everywhere, thansk!

greg k-h
