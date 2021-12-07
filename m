Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FB446BE18
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 15:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbhLGOvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 09:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbhLGOvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 09:51:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB652C061574;
        Tue,  7 Dec 2021 06:47:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 91D6CCE1B19;
        Tue,  7 Dec 2021 14:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E422C341C5;
        Tue,  7 Dec 2021 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638888467;
        bh=u4WpnIP/o6TXEfTfxB1pdkIBKTMxbE9JzDtO7Q8LGY8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BHwzZaUvYEJBPdkY29edXrrIzNxbqF3c2GIHQhelBbf0o83fviJEkGmWTcjamgyqm
         mrgcdS4nNcZdIC+5w7HVXtKw33DnoQLYytjDdEoz459JmfnOLhg7QDmxQ2AlQG4CY/
         DwucZPElGRLQMCkh936aYOUdUogaDvh+fYCKTrc9q2XLcbWr/kQKWuO5D/sRVsaf5y
         nrqvOuLYM0/r+MCq+ZgPXDgZO7y672LcoUblh1I3jiiKGbF2Mmu+fdtGRwTK0PywMe
         lGgv7c6AD40cKjRWSdIJc47ZIIEWiAhlGvc0vZxCm6MjV3EY6M9OIEndS9Gj79UJPt
         +8bvZikxOHiyQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Pengyu Ma <mapengyu@gmail.com>
Subject: Re: [PATCH] bus: mhi: core: Add support for forced PM resume
References: <20211206161059.107007-1-manivannan.sadhasivam@linaro.org>
Date:   Tue, 07 Dec 2021 16:47:42 +0200
In-Reply-To: <20211206161059.107007-1-manivannan.sadhasivam@linaro.org>
        (Manivannan Sadhasivam's message of "Mon, 6 Dec 2021 21:40:59 +0530")
Message-ID: <871r2otqsx.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:

> From: Loic Poulain <loic.poulain@linaro.org>
>
> For whatever reason, some devices like QCA6390, WCN6855 using ath11k
> are not in M3 state during PM resume, but still functional. The
> mhi_pm_resume should then not fail in those cases, and let the higher
> level device specific stack continue resuming process.
>
> Add a new parameter to mhi_pm_resume, to force resuming, whatever the
> current MHI state is. This fixes a regression with non functional
> ath11k WiFi after suspend/resume cycle on some machines.
>
> Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=214179
>
> Cc: stable@vger.kernel.org #5.13
> Fixes: 020d3b26c07a ("bus: mhi: Early MHI resume failure in non M3 state")
> Reported-by: Kalle Valo <kvalo@codeaurora.org>
> Reported-by: Pengyu Ma <mapengyu@gmail.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> [mani: Added comment, bug report, added reported-by tags and CCed stable]
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks! I now tested this patch on top v5.16-rc4 using QCA6390 and
firmware WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1, no issues found:

Tested-by: Kalle Valo <kvalo@kernel.org>

I'm not expecting any conflicts with ath11k, so please take this via the
mhi tree. It would be really good to get this regression fixed in v5.16,
so is it possible to send this to -rc releases?

For the ath11k part:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
