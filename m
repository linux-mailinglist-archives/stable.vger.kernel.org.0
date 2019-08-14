Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCFE8DA4D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbfHNRQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbfHNRQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:16:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAD0E20665;
        Wed, 14 Aug 2019 17:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565803005;
        bh=Me0Rrf4PSyXYOBq0Wu8UuRbZu7Y90ejQdA93Qf1OWa8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lgf+/mc2ZHSHAHhYktC9As1iU5LDag7lQyxn9JodT2mVUSa5FkDOAAYdwVMnNanK/
         S7C1EWEWZjnfu7qV2NRHLeAoveLrAWufa8WtxZa8U0GZU0exFMxk+/uxPGoJx1RbhG
         aD3kdwXFGJF5KXwaCMmr0aASmVhpgWjLKGhvBmKg=
Date:   Wed, 14 Aug 2019 19:13:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     stable@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 4.4] mwifiex: fix 802.11n/WPA detection
Message-ID: <20190814171344.GA1564@kroah.com>
References: <20190814165914.143238-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814165914.143238-1-briannorris@chromium.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 09:59:14AM -0700, Brian Norris wrote:
> [ Upstream commit df612421fe2566654047769c6852ffae1a31df16 ]
> 
> Commit 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant
> vendor IEs") adjusted the ieee_types_vendor_header struct, which
> inadvertently messed up the offsets used in
> mwifiex_is_wpa_oui_present(). Add that offset back in, mirroring
> mwifiex_is_rsn_oui_present().
> 
> As it stands, commit 63d7ef36103d breaks compatibility with WPA (not
> WPA2) 802.11n networks, since we hit the "info: Disable 11n if AES is
> not supported by AP" case in mwifiex_is_network_compatible().
> 
> Fixes: 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant vendor IEs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>  drivers/net/wireless/mwifiex/main.h | 1 +
>  drivers/net/wireless/mwifiex/scan.c | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)

Now queued up, thanks for the backport.

greg k-h
