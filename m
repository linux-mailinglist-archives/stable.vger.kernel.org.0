Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86DB4691C7
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 09:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbhLFIxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 03:53:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57690 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbhLFIxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 03:53:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96F8EB81015
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 08:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2513C341C7;
        Mon,  6 Dec 2021 08:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638780623;
        bh=nwm2Ma7JD7hNspj+0Jf2JjVW4AIhToUcQRhlfECsYoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VxUJXzDuRRpNwkjLBdu5peIHPmSxMGKxTM28O963a7B85jpZiVyWHhOFBF3FvwE4J
         zlOJh4qvpecyxmS1136J1gmPxOcyzHs31M5Fps+O4k17pZaml1wLmOhtEIGJmLkV6j
         t3ko4TwXX37SEnFLZ6RioprGD0AnH3VweWEj9drY=
Date:   Mon, 6 Dec 2021 09:50:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     stable@vger.kernel.org, kvalo@codeaurora.org,
        mordechay.goodstein@intel.com
Subject: Re: [PATCH 5.10] iwlwifi: mvm: retry init flow if failed
Message-ID: <Ya3Oxz+d8OuCUsIO@kroah.com>
References: <1638613822160117@kroah.com>
 <20211204110202.837370-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211204110202.837370-1-luca@coelho.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 04, 2021 at 01:02:02PM +0200, Luca Coelho wrote:
> From: Mordechay Goodstein <mordechay.goodstein@intel.com>
> 
> commit 5283dd677e52af9db6fe6ad11b2f12220d519d0c upstream.
> 
> In some very rare cases the init flow may fail.  In many cases, this is
> recoverable, so we can retry.  Implement a loop to retry two more times
> after the first attempt failed.
> 
> This can happen in two different situations, namely during probe and
> during mac80211 start.  For the first case, a simple loop is enough.
> For the second case, we need to add a flag to prevent mac80211 from
> trying to restart it as well, leaving full control with the driver.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Link: https://lore.kernel.org/r/iwlwifi.20211110150132.57514296ecab.I52a0411774b700bdc7dedb124d8b59bf99456eb2@changeid
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 22 +++++++++++------
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.h  |  3 +++
>  .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 24 ++++++++++++++++++-
>  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 +++
>  drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  3 +++
>  5 files changed, 47 insertions(+), 8 deletions(-)

Both backports now queued up, thanks.

greg k-h
