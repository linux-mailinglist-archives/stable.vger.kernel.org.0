Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47A61AB64E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390792AbgDPDlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390005AbgDPDlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 23:41:35 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06E9820737;
        Thu, 16 Apr 2020 03:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587008495;
        bh=Xxxfk7JCYJtIqg5NU1a9JqslDlvWajIzRsC5FWXvvxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mhahTVztVw/otmGQFrX0MaY+eyBnSdVKBk3g2RxapE1LeR7DgMeFApUfl68thOTnR
         J+3sqryGIurWO4/nBqzzxuLJwkmlEWuKF4HlngD0nsFKxpG+TxPRWHKi9oat0NAF18
         SsKdCCptWuwLKTEJR3awKXEbRWmgDi/j1U0Im9WQ=
Date:   Wed, 15 Apr 2020 23:41:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Stable RC build failures (v4.19.y, v5.4.y, v5.5.y)
Message-ID: <20200416034133.GI1068@sasha-vm>
References: <20200415183655.GA66707@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200415183655.GA66707@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 11:36:55AM -0700, Guenter Roeck wrote:
>Hi,
>
>The folloewing build failures currently observed with stable release
>candidates.
>
>Thanks,
>Guenter
>
>---
>v4.19.y:
>
>drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:392:14: error: 'chipFeatures_PIPE_3D' undeclared here
>drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:397:14: error: 'chipFeatures_PIPE_2D'
>drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:402:14: error: 'chipFeatures_PIPE_VG' undeclared here
>
>Culprit is 'drm/etnaviv: rework perfmon query infrastructure'. Applying
>commit 15ff4a7b5841 ("etnaviv: perfmon: fix total and idle HI cyleces
>readout") as well fixes the problem.

Done.

>v5.4.y, v5.5.y:
>
>drivers/mmc/host/sdhci-tegra.c: In function 'tegra_sdhci_set_timeout':
>drivers/mmc/host/sdhci-tegra.c:1256:2: error:
>	implicit declaration of function '__sdhci_set_timeout'
>
>Culprit is "sdhci: tegra: Implement Tegra specific set_timeout callback".
>__sdhci_set_timeout() was introduced with commit 7d76ed77cfbd3 ("mmc:
>sdhci: Refactor sdhci_set_timeout()"). Unfortunately, applying that patch
>results in a conflict.

But that patch can be resolved by grabbing 7907ebe741a7 ("mmc: sdhci:
Convert sdhci_set_timeout_irq() to non-static") which just makes
__sdhci_set_timeout() non-static.

-- 
Thanks,
Sasha
