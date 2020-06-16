Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA181FA4EE
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 02:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgFPAMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 20:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgFPAMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 20:12:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5F6420739;
        Tue, 16 Jun 2020 00:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592266342;
        bh=/RKb5pdgXdzXez/EfNLSKGLUCw2v8oEqAIceEodRjYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UciE2mmYCJTD5EDOueTsqXam/+doIC4VGJaOwdCn2xK74pE+UnqO90W4uyNVn4Vtq
         yQ4NFbsTqxDdG9fmobTu2bSd3gtefGplFRcPopVEnv+E6ZmVJzn9oj4XamLCuKWBaq
         5hPUKXelcoQ3cDFaiBDn1GCeC67pIzPVicaK0qaE=
Date:   Mon, 15 Jun 2020 20:12:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, andriy.shevchenko@linux.intel.com,
        broonie@kernel.org, jarkko.nikula@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: pxa2xx: Fix runtime PM ref imbalance
 on probe error" failed to apply to 4.19-stable tree
Message-ID: <20200616001220.GJ1931@sasha-vm>
References: <15922344972213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15922344972213@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:21:37PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 65e318e17358a3fd4fcb5a69d89b14016dee2f06 Mon Sep 17 00:00:00 2001
>From: Lukas Wunner <lukas@wunner.de>
>Date: Mon, 25 May 2020 14:25:03 +0200
>Subject: [PATCH] spi: pxa2xx: Fix runtime PM ref imbalance on probe error
>
>The PXA2xx SPI driver releases a runtime PM ref in the probe error path
>even though it hasn't acquired a ref earlier.
>
>Apparently commit e2b714afee32 ("spi: pxa2xx: Disable runtime PM if
>controller registration fails") sought to copy-paste the invocation of
>pm_runtime_disable() from pxa2xx_spi_remove(), but erroneously copied
>the call to pm_runtime_put_noidle() as well.  Drop it.
>
>Fixes: e2b714afee32 ("spi: pxa2xx: Disable runtime PM if controller registration fails")
>Signed-off-by: Lukas Wunner <lukas@wunner.de>
>Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
>Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Cc: stable@vger.kernel.org # v4.17+
>Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
>Link: https://lore.kernel.org/r/58b2ac6942ca1f91aaeeafe512144bc5343e1d84.1590408496.git.lukas@wunner.de
>Signed-off-by: Mark Brown <broonie@kernel.org>

I've also grabbed 1274204542f6 ("spi: pxa2xx: Balance runtime PM
enable/disable on error") and worked around the master -> controller
rename. queued for 4.19.

-- 
Thanks,
Sasha
