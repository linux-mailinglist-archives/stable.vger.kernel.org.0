Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30457ABD9
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 17:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbfG3PCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 11:02:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfG3PCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 11:02:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D15ED60735; Tue, 30 Jul 2019 15:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564498936;
        bh=9y/8la5mIDvXXyg82RZC1NJc79+uacylZpte2rTqNt0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dDOWa3JgzIulliA0voY5YSHTbQfoI8ZcAehI+vb3dBIWZ3JRzmN1kg4X2kJog6dUh
         gVAZqqD4J4ZBQXkjalxdmEQf8cfPtSBv5WVMQpwYQaEwsyHnN/AjApmmPyu0WYzHc0
         n/oBxERpaLCBjuotAA1M8od+8nOGtqQpX5G1heUU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 37A12606FC;
        Tue, 30 Jul 2019 15:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564498932;
        bh=9y/8la5mIDvXXyg82RZC1NJc79+uacylZpte2rTqNt0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=J9IKLMSV+SjiI+77CSw6uXrmbORJWMZ6axkxnC0mtkkUmayB1GXAm9+uApWMrZdTw
         l+ChaoClpmFR5YWruj0RlMgTuVe9qWBLoBHVWaxukaHy9TXB+YSqPx+0ViBOPmOgBc
         ECyub6bP4gEnhJHudlBd/EaV+ipgjXU4mcJ8EyPk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 37A12606FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.3] mwifiex: fix 802.11n/WPA detection
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724194634.205718-1-briannorris@chromium.org>
References: <20190724194634.205718-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190730150215.D15ED60735@smtp.codeaurora.org>
Date:   Tue, 30 Jul 2019 15:02:13 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

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

Patch applied to wireless-drivers.git, thanks.

df612421fe25 mwifiex: fix 802.11n/WPA detection

-- 
https://patchwork.kernel.org/patch/11057585/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

