Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00992181E4B
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 17:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgCKQxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 12:53:33 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:21907 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730031AbgCKQxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 12:53:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583945612; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ubLoWCp3h01mj32RDpUyl192zHsOqVXscIZcMtW7IbI=;
 b=PZ+MybkwrX+dCcg8VO+IN7EKtAmAUJso76K5NPA0oVdzP22e85RakbZSG9/UQ3p0CmifBIlC
 X3bk0MdHdGtj467qIQvL+DHqpkRshtKN5+CWQKlZhvpZDU0sYCwRRq1YdONUEL9s2FHryn9N
 WzzxPCHP8hADWfEzsqQKIrr57R0=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e69178a.7fc3b35dc500-smtp-out-n01;
 Wed, 11 Mar 2020 16:53:30 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7184BC433D2; Wed, 11 Mar 2020 16:53:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E469BC433CB;
        Wed, 11 Mar 2020 16:53:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E469BC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Handle txpower changes even when TPC is disabled
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200229161347.31341-1-repk@triplefau.lt>
References: <20200229161347.31341-1-repk@triplefau.lt>
To:     Remi Pommarel <repk@triplefau.lt>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200311165330.7184BC433D2@smtp.codeaurora.org>
Date:   Wed, 11 Mar 2020 16:53:30 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remi Pommarel <repk@triplefau.lt> wrote:

> When TPC is disabled IEEE80211_CONF_CHANGE_POWER event can be handled to
> reconfigure HW's maximum txpower.
> 
> This fixes 0dBm txpower setting when user attaches to an interface for
> the first time with the following scenario:
> 
> ieee80211_do_open()
>     ath9k_add_interface()
>         ath9k_set_txpower() /* Set TX power with not yet initialized
>                                sc->hw->conf.power_level */
> 
>     ieee80211_hw_config() /* Iniatilize sc->hw->conf.power_level and
>                              raise IEEE80211_CONF_CHANGE_POWER */
> 
>     ath9k_config() /* IEEE80211_CONF_CHANGE_POWER is ignored */
> 
> This issue can be reproduced with the following:
> 
>   $ modprobe -r ath9k
>   $ modprobe ath9k
>   $ wpa_supplicant -i wlan0 -c /tmp/wpa.conf &
>   $ iw dev /* Here TX power is either 0 or 3 depending on RF chain */
>   $ killall wpa_supplicant
>   $ iw dev /* TX power goes back to calibrated value and subsequent
>               calls will be fine */
> 
> Fixes: 283dd11994cde ("ath9k: add per-vif TX power capability")
> Cc: stable@vger.kernel.org
> Signed-off-by: Remi Pommarel <repk@triplefau.lt>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

968ae2caad07 ath9k: Handle txpower changes even when TPC is disabled

-- 
https://patchwork.kernel.org/patch/11413917/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
