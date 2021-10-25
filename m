Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F2C439776
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 15:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhJYN1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 09:27:00 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:10138 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhJYN07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 09:26:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635168277; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=rFPpdhO36riHLMbK56Jbllxq+eIQQRnsZLDJ1p3HIH8=;
 b=UpBWHBJYIsDmB0pWB2HVY1tBoFPCmsTacuSuTSXvODWa49cW4tpIKeCIYt2ZepRSgLaREaTJ
 cYUSWVJ1pg0ktsIcjA+5QdgHsP/2P9U+8tpMXnQxmRVv5zQbtJyL4lRjoc044aZlTVKYmptB
 irYBSNF9vO3BJK02Z53oZcK/6iY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6176b0075baa84c77b7a97a5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Oct 2021 13:24:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EAE8FC43460; Mon, 25 Oct 2021 13:24:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 19AA7C4360D;
        Mon, 25 Oct 2021 13:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 19AA7C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wcn36xx: Fix tx_status mechanism
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1634567281-28997-1-git-send-email-loic.poulain@linaro.org>
References: <1634567281-28997-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        bryan.odonoghue@linaro.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163516825893.10163.17036044541624913571.kvalo@codeaurora.org>
Date:   Mon, 25 Oct 2021 13:24:22 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> wrote:

> This change fix the TX ack mechanism in various ways:
> 
> - For NO_ACK tagged packets, we don't need to wait for TX_ACK indication
> and so are not subject to the single packet ack limitation. So we don't
> have to stop the tx queue, and can call the tx status callback as soon
> as DMA transfer has completed.
> 
> - Fix skb ownership/reference. Only start status indication timeout
> once the DMA transfer has been completed. This avoids the skb to be
> both referenced in the DMA tx ring and by the tx_ack_skb pointer,
> preventing any use-after-free or double-free.
> 
> - This adds a sanity (paranoia?) check on the skb tx ack pointer.
> 
> - Resume TX queue if TX status tagged packet TX fails.
> 
> Cc: stable@vger.kernel.org
> Fixes: fdf21cc37149 ("wcn36xx: Add TX ack support")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

a9e79b116cc4 wcn36xx: Fix tx_status mechanism

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1634567281-28997-1-git-send-email-loic.poulain@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

