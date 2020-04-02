Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D4819C999
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbgDBTNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33089 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388710AbgDBTNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id a25so5640963wrd.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aCe1QZjmaMyeP77BfjlfNyliRZWqjMuk0JjgiLARwG8=;
        b=aA3ijYEK4U6Ao/FzdM9nmN6VO6VO5t5L/6o867zw29MtYnzKN9iEuiXnmIoDSGRaYK
         NGLWZaGB7GSRuMBJ9QT8TUbBj8Drj+/x6p4mLi5V6T3s04WC+PXY9w3KcCyhDN0nBSIq
         vOu83AiN8OvHDInehC5apTBaHWhZ+PP0zOU9hzs1JWn51h0G9u/WiuMuCeyfbVBHY9yb
         mq8VFmcNTlqk/Vzf61hiTewvkN50IL0vlaVz3KISSWBOnqYzqItzz3Zn2lFrh8Nnys2L
         Qdtj4CDa+TrSgsxTcShNdNVvUAvan+NYWKiMO7LnR7DNiEJfe9ToEYoPy1ZZ0e/AL5OG
         t5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aCe1QZjmaMyeP77BfjlfNyliRZWqjMuk0JjgiLARwG8=;
        b=EVMMwnGM7UC4vjA1t60zxGel+ab1c9SiaqAJlvpGHRVJ1F6Ab6sTGJo8ZEL0sLswp4
         K6J3QAw5Lvo7MJtvhF6rEs9Kr19swVW6NNwZmaRT3ofFDa6xoSa2wUNVuK5t+aiMdWG1
         /Endyo87yumCE7rzH4crB3xEuW4HyOOH1WUr1Mwd92y5szx9tlgjbzUw93owoQr5ZjUq
         CAn5ebdj55PBsUj0y2v0mx5mV4oY9gfPX07zC0kXyz7OVC9tNXoUzYBfpDXAH+ksYd5K
         vE61a4lyNu9dvjg9wxiCvxIRLCLKK15YKgnB7soRLIeT6BpcHBdIW6Tk2eI9hvbjdhdi
         G9YQ==
X-Gm-Message-State: AGi0PubnPmOM7fOofktg4Kufg7DnAEcAVJv3EwJL6ifCRXQL36vlHI1s
        kn4k2n+1HmPfpnZuLJmz0hJ3dv5PXJINEA==
X-Google-Smtp-Source: APiQypLADF0yXsWEEOynOzYJfQL0dYvFRRXFh1OUY7h3+MK4nJh6FiKTgdjmeme7Z8II489pshbHrQ==
X-Received: by 2002:a5d:6605:: with SMTP id n5mr4837176wru.303.1585854797171;
        Thu, 02 Apr 2020 12:13:17 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 18/33] wil6210: rate limit wil_rx_refill error
Date:   Thu,  2 Apr 2020 20:13:38 +0100
Message-Id: <20200402191353.787836-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
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
---
 drivers/net/wireless/ath/wil6210/txrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 16750056b8b52..b483c42660971 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -636,8 +636,8 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
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
-- 
2.25.1

