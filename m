Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263A8282F9C
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 06:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgJEE1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 00:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgJEE1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 00:27:53 -0400
Received: from localhost (unknown [171.61.67.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C78A72080C;
        Mon,  5 Oct 2020 04:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601872072;
        bh=81ofi23+2Bd24RjsNBYMAaXLsVa+v1UhZoVfpnrdcyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BNx3Ocj5WDaaZsMjKvtb6KlkmixkUJ14/GXWbyKKCH/4pTnbzFJ5dPDN4f3g3ObMy
         2VaV8Hy/UMfsS2oBfOwNMuR32OTAV0qcLrukURh/fTctwNXUt7LcKcyizhVCd5UE/Q
         xq7mCIF+m8/a+jPtywoOIIeZx2SIJYSiS7OpdLwE=
Date:   Mon, 5 Oct 2020 09:57:47 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     od@zcrc.me, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Artur Rojek <contact@artur-rojek.eu>
Subject: Re: [PATCH] dma: dma-jz4780: Fix race in jz4780_dma_tx_status
Message-ID: <20201005042747.GC2968@vkoul-mobl>
References: <20201004140307.885556-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004140307.885556-1-paul@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04-10-20, 16:03, Paul Cercueil wrote:
> The jz4780_dma_tx_status() function would check if a channel's cookie
> state was set to 'completed', and if not, it would enter the critical
> section. However, in that time frame, the jz4780_dma_chan_irq() function
> was able to set the cookie to 'completed', and clear the jzchan->vchan
> pointer, which was deferenced in the critical section of the first
> function.
> 
> Fix this race by checking the channel's cookie state after entering the
> critical function and not before.

Applied, thanks

-- 
~Vinod
