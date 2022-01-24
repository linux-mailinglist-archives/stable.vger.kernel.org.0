Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954EC498884
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiAXSmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiAXSmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:42:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC02C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 10:42:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47872B81213
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 18:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BFAC340E5;
        Mon, 24 Jan 2022 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643049757;
        bh=pOs6L2aSbdFfdamiwL1SPWJeUhI9GOknCXRJvvP+Svw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ijx2fX8HFGEZPOX+ymM6rs6kTq5qLpx9Ve2ocGqeSmgybl96vyGoBuS1JrdrI7X3C
         04Jr1TBjrwSO2xp/qlgE0uqx1xJBX1Ts4sX8Qg/uoW9dAfvwBMPU1C8PBriV58uV/k
         DpuNu+DlFZZ9iRYTwipCzCtjVfF00JtrvcLT2bzA=
Date:   Mon, 24 Jan 2022 19:31:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Dennis Cagle <d-cagle@codeaurora.org>,
        Patrick Daly <pdaly@codeaurora.org>
Subject: Re: [PATCH 4.9 1/3] ion: Fix use after free during ION_IOC_ALLOC
Message-ID: <Ye7wcqssa5RuvwQe@kroah.com>
References: <20220124161243.1029417-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124161243.1029417-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 04:12:41PM +0000, Lee Jones wrote:
> From: Daniel Rosenberg <drosen@google.com>
> 
> If a user happens to call ION_IOC_FREE during an ION_IOC_ALLOC
> on the just allocated id, and the copy_to_user fails, the cleanup
> code will attempt to free an already freed handle.
> 
> This adds a wrapper for ion_alloc that adds an ion_handle_get to
> avoid this.
> 
> Signed-off-by: Daniel Rosenberg <drosen@google.com>
> Signed-off-by: Dennis Cagle <d-cagle@codeaurora.org>
> Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/staging/android/ion/ion-ioctl.c | 14 +++++++++-----
>  drivers/staging/android/ion/ion.c       | 15 ++++++++++++---
>  drivers/staging/android/ion/ion.h       |  4 ++++
>  3 files changed, 25 insertions(+), 8 deletions(-)

What is the git commit id of this in Linus's tree (same for the other
2)?

And why just 4.9?  What about 4.14 and newer kernels?

thanks,

greg k-h
