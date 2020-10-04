Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C696B282AC6
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 14:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgJDM6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 08:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgJDM6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Oct 2020 08:58:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1CFF206C1;
        Sun,  4 Oct 2020 12:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601816286;
        bh=q7voBvalkDYpHVnayj03vU/GtK9W1LMSggDb9TuxEdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aKYWqbO2Upswj3dhmabn599HhUBqmJwFxKEqXlj39Rnb/2xBIPUVLCDFldQFMS8OG
         ZV/EKiQRDq6JRFGelptrTRSMBq/5JelWEJATKt5eBeU/ucOUngOEU4qHQg2hjPw1iO
         exZcipQgx1U2ntWRSjw3HDwl+OdIyJDJLYJm1J1A=
Date:   Sun, 4 Oct 2020 08:58:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.8 28/29] spi: fsl-dspi: fix use-after-free in
 remove path
Message-ID: <20201004125804.GL2415204@sasha-vm>
References: <20200929013027.2406344-1-sashal@kernel.org>
 <20200929013027.2406344-28-sashal@kernel.org>
 <20200929062216.GL11648@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200929062216.GL11648@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 08:22:16AM +0200, Sascha Hauer wrote:
>Hi Sasha,
>
>On Mon, Sep 28, 2020 at 09:30:25PM -0400, Sasha Levin wrote:
>> From: Sascha Hauer <s.hauer@pengutronix.de>
>>
>> [ Upstream commit 530b5affc675ade5db4a03f04ed7cd66806c8a1a ]
>>
>> spi_unregister_controller() not only unregisters the controller, but
>> also frees the controller. This will free the driver data with it, so
>> we must not access it later dspi_remove().
>>
>> Solve this by allocating the driver data separately from the SPI
>> controller.
>>
>> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
>> Link: https://lore.kernel.org/r/20200923131026.20707-1-s.hauer@pengutronix.de
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/spi/spi-fsl-dspi.c | 12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>
>This patch causes a regression and shouldn't be applied without the fix
>in https://lkml.org/lkml/2020/9/28/300.

Looks like the fix didn't make it yet, so I'll drop the patch.

-- 
Thanks,
Sasha
