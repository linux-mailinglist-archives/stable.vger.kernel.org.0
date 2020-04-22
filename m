Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4CA1B4289
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDVKCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgDVKCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:02:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3300820774;
        Wed, 22 Apr 2020 10:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549720;
        bh=Y07dWYO98iUZfxjOHtGujQUrOwo0N8XhAI1Ws17TqzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLafFKRIohwIKcnP3Eq7AXZhKvQayk+7DFlvQSpU373VgKwhNQQesbT88XAWX3E7L
         dtFrIJhRCDcIBlwftkMUieBnLlTcpJSQHmcfFdNLA4I7UduG/G0/YYuQJYb20iHxMf
         cAQdBVgUJ/D/X1Dt7rG/NOtgr6JZslCM4hOw+uL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 079/100] wil6210: rate limit wil_rx_refill error
Date:   Wed, 22 Apr 2020 11:56:49 +0200
Message-Id: <20200422095037.271139369@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit 3d6b72729cc2933906de8d2c602ae05e920b2122 ]

wil_err inside wil_rx_refill can flood the log buffer.
Replace it with wil_err_ratelimited.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -538,8 +538,8 @@ static int wil_rx_refill(struct wil6210_
 			v->swtail = next_tail) {
 		rc = wil_vring_alloc_skb(wil, v, v->swtail, headroom);
 		if (unlikely(rc)) {
-			wil_err(wil, "Error %d in wil_rx_refill[%d]\n",
-				rc, v->swtail);
+			wil_err_ratelimited(wil, "Error %d in rx refill[%d]\n",
+					    rc, v->swtail);
 			break;
 		}
 	}


