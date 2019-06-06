Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664FA36906
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 03:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfFFBI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 21:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbfFFBI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 21:08:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B74062070B;
        Thu,  6 Jun 2019 01:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559783339;
        bh=rLe4wDM1i8CUFx415ydIm5XkrbpThXQyTUO1Dg0eLXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2mEGngSqWpMxkHC7m+iR4PKQmzOLiH0JMRN2BOqO+Wp2Hu17PHY9+axqBQ/jWRmsm
         ZZrML5vbocNStOeyg/rZLakuwSZlHaH6qv+nT3ohes3ARlc3pb5RZooNej7ZAQ79UQ
         S85Up0xct/oDOWO4Uc7X6s+k6uzfxIK4ZHBV8+oo=
Date:   Wed, 5 Jun 2019 21:08:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Chunyan Zhang <zhang.chunyan@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grygorii Strashko <grygorii.Strashko@ti.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [BACKPORT 4.4.y] PM / sleep: prohibit devices probing during
 suspend/hibernation
Message-ID: <20190606010857.GF29739@sasha-vm>
References: <20190605111412.3461-1-zhang.chunyan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190605111412.3461-1-zhang.chunyan@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 07:14:12PM +0800, Chunyan Zhang wrote:
>From: "Strashko, Grygorii" <grygorii.strashko@ti.com>
>
>[ Upstream commit 013c074f8642d8e815ad670601f8e27155a74b57 ]
>
>It is unsafe [1] if probing of devices will happen during suspend or
>hibernation and system behavior will be unpredictable in this case.
>So, let's prohibit device's probing in dpm_prepare() and defer their
>probing instead. The normal behavior will be restored in
>dpm_complete().
>
>This patch introduces new DD core APIs:
> device_block_probing()
>   It will disable probing of devices and defer their probes instead.
> device_unblock_probing()
>   It will restore normal behavior and trigger re-probing of deferred
>   devices.
>
>[1] https://lkml.org/lkml/2015/9/11/554
>
>Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>Acked-by: Pavel Machek <pavel@ucw.cz>
>Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>

This patch had to be fixed a few times (see 015bb5e134 and 9a2a5a638f8),
we can't just take it as is.

It might be just simpler to move to a newer kernel at this point.

--
Thanks,
Sasha
