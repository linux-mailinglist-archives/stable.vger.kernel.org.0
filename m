Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A37119D690
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403905AbgDCMSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51790 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403845AbgDCMSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id z7so6912055wmk.1
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u/8Oj2Ff4RNeFgOmfCdgYmb1Rv0nrDRFoL1TCNAUQ/o=;
        b=i3iz78tTwa0Wav771yX03ihSbuNrM6FG6B+vB0rxlPDllYV+JstD3gJT/+Pm3+71uL
         7Li1DT2vsk8cmQZa49lcafqtSr4Nydl2KAiVpOSvYKQmtfYf+hJ5GwIEzioi9QZxax14
         aqLdLtKRRHlmyeYXqePfFmXx7puf9IuD4oJ1IIceUMjJkDbtJLk+J6EoMqZegoH5wDUT
         cIWGhJkoWdqeLyyuOomSPeTdgtjmHZpum1gZZcqc4FjEIUWHTCERKUEDmQX063fiCIba
         0iDjeHKCvqUAkZ5e0arAmHpRfmBYdPTzK1i4TGgNX0tf/XZ6EAJEe/JgYLmgk12QFAGA
         yCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/8Oj2Ff4RNeFgOmfCdgYmb1Rv0nrDRFoL1TCNAUQ/o=;
        b=m8WpIkAKKpWu/lz7/8qZuwaLBMJyhxYq2gBkjvcm6YqnMWxhQKBjBmtJdd8C/7uo+4
         jRL36GqgubWy0Ti598A7p0SygletQrsvBfhPuFFLIFm2XebPxpx+7gSaPLIXGp3YKhIf
         7RIvPgMoGiOGS+0StpYK2fzq3PxwdHM1aEAzVnBS9J5JIuIeZGT5BDxoPTPfMECNUmns
         smbllA8q3kRg61o18A7zEgql7G2dMoKSFs9g1pFiSUAu9cIWoRR/NUbHbUzDlmprP+NP
         4oMI4PLQ+DHsr8jLuP2klkLHYalrbh98zLB4YHSG2ktDE0/F1YlKR1ZpV+Koa6ZFqkIv
         QdvA==
X-Gm-Message-State: AGi0PuaQ/uqWu9aaHSIG4lKgXZtft70XOUUINvqEXcVoe4mylmF3n+tZ
        nhnttkSux9IZcGuRIANYcZ+cdnVpWDE=
X-Google-Smtp-Source: APiQypL4+uloNWonzduk1wcqQesUTmfyQBMoFt5g0QDZDN0kMXiIdp0qBR2bYyeEaQnHcUY0rWYC6A==
X-Received: by 2002:a7b:c004:: with SMTP id c4mr8228923wmb.108.1585916310196;
        Fri, 03 Apr 2020 05:18:30 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:29 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 05/13] wil6210: check rx_buff_mgmt before accessing it
Date:   Fri,  3 Apr 2020 13:18:51 +0100
Message-Id: <20200403121859.901838-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit d6a553c0c61b0b0219764e4d4fc14e385085f374 ]

Make sure rx_buff_mgmt is initialized before accessing it.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 5fa8d6ad66482..03d0e6c550b98 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -268,6 +268,9 @@ static void wil_move_all_rx_buff_to_free_list(struct wil6210_priv *wil,
 	struct list_head *active = &wil->rx_buff_mgmt.active;
 	dma_addr_t pa;
 
+	if (!wil->rx_buff_mgmt.buff_arr)
+		return;
+
 	while (!list_empty(active)) {
 		struct wil_rx_buff *rx_buff =
 			list_first_entry(active, struct wil_rx_buff, list);
-- 
2.25.1

