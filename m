Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A551E4288
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 14:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbgE0Mj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 08:39:26 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:43035 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729919AbgE0MjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 08:39:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590583165; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=k+wLv6pKXT7nlyf+aOv3Skb3ZTtkuUFqJ25fOD4zXVQ=; b=E3FLi2G/dBg3UBVpxcqHAT9X6OPsyF4mBmfyhazjTsZSaYWDSABzrmcNs4cHhmceQOOW8+EW
 s9wS92F+Our0MWuZA7Qjr2Kz6/3q8Xic28fG7VU6jYQ1zJdIHIwv3ow6zcrDtDAESdAB4z3i
 t64Sm6qRxMPgLvpmCSHtObA0hyo=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5ece5f6d44a25e0052246b26 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 May 2020 12:39:09
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8F20DC43387; Wed, 27 May 2020 12:39:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E1B89C433CA;
        Wed, 27 May 2020 12:39:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E1B89C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] b43_legacy: Fix connection problem with WPA3
References: <20200526155909.5807-1-Larry.Finger@lwfinger.net>
        <20200526155909.5807-3-Larry.Finger@lwfinger.net>
Date:   Wed, 27 May 2020 15:39:05 +0300
In-Reply-To: <20200526155909.5807-3-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Tue, 26 May 2020 10:59:09 -0500")
Message-ID: <87a71tv9g6.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Since the driver was first introduced into the kernel, it has only
> handled the ciphers associated with WEP, WPA, and WPA2. It fails with
> WPA3 even though mac80211 can handle those additional ciphers in software,
> b43legacy did not report that it could handle them. By setting MFP_CAPABLE using
> ieee80211_set_hw(), the problem is fixed.
>
> With this change, b43legacy will handle the ciohers it knows in hardare,
> and let mac80211 handle the others in software. It is not necessary to
> use the module parameter NOHWCRYPT to turn hardware encryption off.
> Although this change essentially eliminates that module parameter,
> I am choosing to keep it for cases where the hardware is broken,
> and software encryption is required for all ciphers.
>
> This patch fixes a problem that has been in b43legacy since commit
> 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx
> devices").
>
> Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

I'll do the same changes here as in patch 1.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
