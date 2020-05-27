Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37891E427F
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 14:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgE0Mim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 08:38:42 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26866 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728964AbgE0Mim (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 08:38:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590583121; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=kremWLpwNVoshp5MuXTuJc1IhfiAX5UdwZNQOMJb8yA=; b=M/f1VVE1X7ltngUnsphVwWi7nF5RXpQ4Os7wnJ+rEHqQ5yG8isA2Fl7t+Lb4uZ0hiKpbVgGK
 10WwgFxipVrBijzkGTt41H36uAc2BjklnYl+X3Ij5Q8xRBzGJs8ySiFdqjgbyk0zQ0T6Ahde
 1smyHG2xMSK+s7o5ZsZvYLNhBgk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5ece5f4876fccbb4c8d33e94 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 May 2020 12:38:32
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 848DBC433A1; Wed, 27 May 2020 12:38:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 86DC6C433C6;
        Wed, 27 May 2020 12:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 86DC6C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] b43: Fix connection problem with WPA3
References: <20200526155909.5807-1-Larry.Finger@lwfinger.net>
        <20200526155909.5807-2-Larry.Finger@lwfinger.net>
Date:   Wed, 27 May 2020 15:38:26 +0300
In-Reply-To: <20200526155909.5807-2-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Tue, 26 May 2020 10:59:08 -0500")
Message-ID: <87eer5v9h9.fsf@codeaurora.org>
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
> b43 did not report that it could handle them. By setting MFP_CAPABLE using
> ieee80211_set_hw(), the problem is fixed.
>
> With this change, b43 will handle the ciohers it knows in hardare,

I'll change this to:

"ciphers it knows in hardware"

> and let mac80211 handle the others in software. It is not necessary to
> use the module parameter NOHWCRYPT to turn hardware encryption off.
> Although this change essentially eliminates that module parameter,
> I am choosing to keep it for cases where the hardware is broken,
> and software encryption is required for all ciphers.
>
> This patch fixes a prooblem that has been in the driver since it was first
> merged with commit e4d6b7951812 ("[B43]: add mac80211-based driver for
> modern BCM43xx devices").
>
> Fixes e4d6b7951812 ("[B43]: add mac80211-based driver for modern BCM43xx devices")

I consider this as a new feature, not a bugfix. So I'll remove the Fixes
line and the paragraph above it. Ok?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
