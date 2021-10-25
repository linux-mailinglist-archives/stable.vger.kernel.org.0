Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75044439774
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 15:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhJYN03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 09:26:29 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:45701 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230344AbhJYN00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 09:26:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635168244; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=+muA5H/c8o94UBoZrsufaSb9pSNYGta0xgTyu25kIyY=;
 b=F6/Ysj+5D5lDFjqXeS4Wmm9xOSmL/42yRU9WXpl71XP8VO72+eNLff2OwnX169q97qMl6QLm
 QaV7Ho2ykjPAlmKOa2Z/YY7b649VxfEHbugkltx+vGeyPqg+OsdSnkWpOTXmgOxktWIieo15
 Ixbh1vS6f0AmuDDpvFl7KkjBTBQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6176afc8b03398c06c9cb718 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Oct 2021 13:23:20
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C4B59C43616; Mon, 25 Oct 2021 13:23:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF503C4338F;
        Mon, 25 Oct 2021 13:23:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org EF503C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: Fix (QoS) null data frame bitrate/modulation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1634560399-15290-1-git-send-email-loic.poulain@linaro.org>
References: <1634560399-15290-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        bryan.odonoghue@linaro.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163516819581.10163.12878239371445987189.kvalo@codeaurora.org>
Date:   Mon, 25 Oct 2021 13:23:19 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> wrote:

> We observe unexpected connection drops with some APs due to
> non-acked mac80211 generated null data frames (keep-alive).
> After debugging and capture, we noticed that null frames are
> submitted at standard data bitrate and that the given APs are
> in trouble with that.
> 
> After setting the null frame bitrate to control bitrate, all
> null frames are acked as expected and connection is maintained.
> 
> Not sure if it's a requirement of the specification, but it seems
> the right thing to do anyway, null frames are mostly used for control
> purpose (power-saving, keep-alive...), and submitting them with
> a slower/simpler bitrate/modulation is more robust.
> 
> Cc: stable@vger.kernel.org
> Fixes: 512b191d9652 ("wcn36xx: Fix TX data path")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d3fd2c95c1c1 wcn36xx: Fix (QoS) null data frame bitrate/modulation

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1634560399-15290-1-git-send-email-loic.poulain@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

