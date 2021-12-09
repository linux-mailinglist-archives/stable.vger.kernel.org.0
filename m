Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E541646EA12
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 15:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbhLIOjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 09:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbhLIOjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 09:39:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67112C061746;
        Thu,  9 Dec 2021 06:35:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33C94CE25F9;
        Thu,  9 Dec 2021 14:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C625FC004DD;
        Thu,  9 Dec 2021 14:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639060533;
        bh=VwQ1u7crT9tT2d+BvG1u1dd1ZTTVlRbYTyboOZjY+2U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XRlSUYtInzZ/0oU2tmL9L3RnBGehjLPN3akfPhmYyn+TWDOwoxOnJmvhmtKLxONr+
         B9MSL2XrYtlcOky2Q4AHIJdu78ZPyBOhnXU8e1nBWMpLTgeN+DlBHsqZg9fEn9xIer
         28+yc/qdQIzX/5BPht4AiSZmBqe90zPaFvToxgQe6sTYeVEF7bACsTV0YEcTxuM9W3
         1shsjsfStzRavL5pvVZR5xDtdYXmluIjwZp2f8tT5nWsdgjgjW10xKI4KDg+b+EYTa
         RM8wN9sIcTO788kJ/1yszTfeMzyuz8+WikXuohnep8HXXtAjybJry7DDAbymSXWTv+
         vBOjSToSXzwEA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     gregkh@linuxfoundation.org, mhi@lists.linux.dev,
        hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Pengyu Ma <mapengyu@gmail.com>
Subject: Re: [PATCH v2] bus: mhi: core: Add support for forced PM resume
References: <20211209131633.4168-1-manivannan.sadhasivam@linaro.org>
Date:   Thu, 09 Dec 2021 16:35:25 +0200
In-Reply-To: <20211209131633.4168-1-manivannan.sadhasivam@linaro.org>
        (Manivannan Sadhasivam's message of "Thu, 9 Dec 2021 18:46:33 +0530")
Message-ID: <87fsr13kya.fsf@codeaurora.org>
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
> Add an API mhi_pm_resume_force(), to force resuming irrespective of the
> current MHI state. This fixes a regression with non functional ath11k WiFi
> after suspend/resume cycle on some machines.
>
> Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=214179
>
> Fixes: 020d3b26c07a ("bus: mhi: Early MHI resume failure in non M3 state")
> Cc: stable@vger.kernel.org #5.13
> Link: https://lore.kernel.org/regressions/871r5p0x2u.fsf@codeaurora.org/
> Reported-by: Kalle Valo <kvalo@codeaurora.org>
> Reported-by: Pengyu Ma <mapengyu@gmail.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> [mani: Switched to API, added bug report, reported-by tags and CCed stable]
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>
> Changes in v2:
>
> * Switched to a new API "mhi_pm_resume_force()" instead of the "force" flag as
>   suggested by Greg. The "force" flag is now used inside the API.
>
> Greg: I'm sending this patch directly to you so that you can apply it to
> char-misc once we get an ACK from Kalle.

Thanks! I now tested this patch on top v5.16-rc4 using QCA6390 and
firmware WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1, no issues found:

Tested-by: Kalle Valo <kvalo@kernel.org>

I'm not expecting any conflicts with ath11k, so please take this via
Greg's tree. It would be really good to get this regression fixed in
v5.16, so is it possible to send this to -rc releases?

For the ath11k part:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
