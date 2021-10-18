Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E096E4319CA
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhJRMtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 08:49:52 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:60978 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229644AbhJRMtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 08:49:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634561260; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=0j+IfNmIKl8RYC/I1HBAehhfSRQaJld1SDjqTOGGquk=;
 b=jLYm1VeTPeddSDPy62M6pd5LODJUIpyuPotx93xRANbk9vIAuItY+4pUTI7db5JeptNd+c2X
 yMYXkj11dHrxYzfJvVtgVAzL8btCgzK4a+UyRIw133B9i8W0CM2HGvM1zsh0HrzZkTRcvWqw
 TD5Zdk3Df/vDwQVOCVO6WlSERcU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 616d6ceaab9da96e64ed0d90 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 12:47:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DB14BC43460; Mon, 18 Oct 2021 12:47:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 89CC0C4338F;
        Mon, 18 Oct 2021 12:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 89CC0C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: Fix tx_status mechanism
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1634560260-15056-1-git-send-email-loic.poulain@linaro.org>
References: <1634560260-15056-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        bryan.odonoghue@linaro.org, Loic Poulain <loic.poulain@linaro.org>,
        stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163456125238.11105.17236254354491324059.kvalo@codeaurora.org>
Date:   Mon, 18 Oct 2021 12:47:37 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> wrote:

> This change fix the TX ack mechanism in various ways:
> 
> - For NO_ACK tagged packets, we don't need to way for TX_ACK indication
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

Fails to build:

drivers/net/wireless/ath/wcn36xx/txrx.c: In function 'wcn36xx_start_tx':
drivers/net/wireless/ath/wcn36xx/txrx.c:611:23: error: unused variable 'flags' [-Werror=unused-variable]
  611 |         unsigned long flags;
      |                       ^~~~~
cc1: all warnings being treated as errors
make[5]: *** [scripts/Makefile.build:277: drivers/net/wireless/ath/wcn36xx/txrx.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [scripts/Makefile.build:540: drivers/net/wireless/ath/wcn36xx] Error 2
make[3]: *** [scripts/Makefile.build:540: drivers/net/wireless/ath] Error 2
make[2]: *** [scripts/Makefile.build:540: drivers/net/wireless] Error 2
make[1]: *** [scripts/Makefile.build:540: drivers/net] Error 2
make: *** [Makefile:1874: drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1634560260-15056-1-git-send-email-loic.poulain@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

