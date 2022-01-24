Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0AA4984F8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243694AbiAXQiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243250AbiAXQiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:38:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C555C06173D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:38:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD0EBB810FD
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 16:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035B4C36AF5;
        Mon, 24 Jan 2022 16:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643042293;
        bh=CoYM6Zx0YaMWWYItE6AaQu0qBUEcrZe0KDqx/IJTN1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lGUyQHb1foxfxjVetR+kyRMAhvUn7DiP0iThPBHuvOOKZZQ0UVNUcVdmAMNEB2/ha
         RW/Jx/2Zh4shMVXiU+WCo/xWbfGUJa7qe6tqZyTVn92u8af3xmXKmMRk7KUqWK7lHs
         QsV6wZS++unaxMTGoWVuPMk4hP2NJ9WEYtpaU6fM=
Date:   Mon, 24 Jan 2022 17:38:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabio Estevam <festevam@denx.de>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: Re: [PATCH stable-5.10] ath10k: Fix the MTU size on QCA9377 SDIO
Message-ID: <Ye7V84vqcv5En/R6@kroah.com>
References: <20220124154454.1349296-1-festevam@denx.de>
 <Ye7O70cWHTlurYPO@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye7O70cWHTlurYPO@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 05:08:15PM +0100, Greg KH wrote:
> On Mon, Jan 24, 2022 at 12:44:54PM -0300, Fabio Estevam wrote:
> > [ Upstream commit 09b8cd69edcf2be04a781e1781e98e52a775c9ad ]
> >     
> > On an imx6dl-pico-pi board with a QCA9377 SDIO chip, simply trying to
> > connect via ssh to another machine causes:
> > 
> > [   55.824159] ath10k_sdio mmc1:0001:1: failed to transmit packet, dropping: -12
> > [   55.832169] ath10k_sdio mmc1:0001:1: failed to submit frame: -12
> > [   55.838529] ath10k_sdio mmc1:0001:1: failed to push frame: -12
> > [   55.905863] ath10k_sdio mmc1:0001:1: failed to transmit packet, dropping: -12
> > [   55.913650] ath10k_sdio mmc1:0001:1: failed to submit frame: -12
> > [   55.919887] ath10k_sdio mmc1:0001:1: failed to push frame: -12
> > 
> > , leading to an ssh connection failure.
> > 
> > One user inspected the size of frames on Wireshark and reported
> > the followig:
> > 
> > "I was able to narrow the issue down to the mtu. If I set the mtu for
> > the wlan0 device to 1486 instead of 1500, the issue does not happen.
> > 
> > The size of frames that I see on Wireshark is exactly 1500 after
> > setting it to 1486."
> > 
> > Clearing the HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE avoids the problem and
> > the ssh command works successfully after that.
> > 
> > Introduce a 'credit_size_workaround' field to ath10k_hw_params for
> > the QCA9377 SDIO, so that the HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE
> > is not set in this case.
> > 
> > Tested with QCA9377 SDIO with firmware WLAN.TF.1.1.1-00061-QCATFSWPZ-1.
> > 
> > Fixes: 2f918ea98606 ("ath10k: enable alt data of TX path for sdio")
> > Signed-off-by: Fabio Estevam <festevam@denx.de>
> > Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
> > Link: https://lore.kernel.org/r/20211124131047.713756-1-festevam@denx.de
> > ---
> > Hi,
> > 
> > This is the resolution for the linux-stable 5.10 tree.
> 
> Now queued up, thanks.

Nope this breaks the build :(

Dropping it again.
