Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5734498882
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiAXSme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:42:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46464 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiAXSmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:42:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A03DDB81213
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 18:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA468C340E5;
        Mon, 24 Jan 2022 18:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643049751;
        bh=GkrmCZ1DV0J0GLUVBO+zwiD0oN83T/OF6JJgpYiLR2c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ULWdm42/4eUEQwT4ErNgihowTpDpzrAJ8Z36VNSBo+h5cBF1Xu+EcvivhEZtAa+9M
         sXcxhf08RHEiP5XSI58FSZkDGS4GWcl2PhVIh/n+88lIDzt47TBfXH+zVD5uyzcQak
         JVuJcce7jwZAX9AcywseEs2DtbWq+uDp4Prs5eyo=
Date:   Mon, 24 Jan 2022 19:26:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabio Estevam <festevam@denx.de>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: Re: [PATCH v3 stable-5.10] ath10k: Fix the MTU size on QCA9377 SDIO
Message-ID: <Ye7vPkJRPILUeCaH@kroah.com>
References: <20220124171042.1454727-1-festevam@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124171042.1454727-1-festevam@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 02:10:42PM -0300, Fabio Estevam wrote:
> [ Upstream commit 09b8cd69edcf2be04a781e1781e98e52a775c9ad ]
>     
> On an imx6dl-pico-pi board with a QCA9377 SDIO chip, simply trying to
> connect via ssh to another machine causes:
> 
> [   55.824159] ath10k_sdio mmc1:0001:1: failed to transmit packet, dropping: -12
> [   55.832169] ath10k_sdio mmc1:0001:1: failed to submit frame: -12
> [   55.838529] ath10k_sdio mmc1:0001:1: failed to push frame: -12
> [   55.905863] ath10k_sdio mmc1:0001:1: failed to transmit packet, dropping: -12
> [   55.913650] ath10k_sdio mmc1:0001:1: failed to submit frame: -12
> [   55.919887] ath10k_sdio mmc1:0001:1: failed to push frame: -12
> 
> , leading to an ssh connection failure.
> 
> One user inspected the size of frames on Wireshark and reported
> the followig:
> 
> "I was able to narrow the issue down to the mtu. If I set the mtu for
> the wlan0 device to 1486 instead of 1500, the issue does not happen.
> 
> The size of frames that I see on Wireshark is exactly 1500 after
> setting it to 1486."
> 
> Clearing the HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE avoids the problem and
> the ssh command works successfully after that.
> 
> Introduce a 'credit_size_workaround' field to ath10k_hw_params for
> the QCA9377 SDIO, so that the HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE
> is not set in this case.
> 
> Tested with QCA9377 SDIO with firmware WLAN.TF.1.1.1-00061-QCATFSWPZ-1.
> 
> Fixes: 2f918ea98606 ("ath10k: enable alt data of TX path for sdio")
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
> Link: https://lore.kernel.org/r/20211124131047.713756-1-festevam@denx.de
> ---
> Hi,
> 
> This is the resolution for the linux-stable 5.10 tree.
> 
> Changes since v2:
> - Add the missing blank line in hw.h like done in the upstream version.
> Changes since v1:
> - Added the missing change in hw.h.

Ok, trying this again...
