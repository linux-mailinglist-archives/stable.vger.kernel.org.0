Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C22B3393E4
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 17:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhCLQvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 11:51:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47309 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbhCLQvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 11:51:31 -0500
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKl0c-00072O-Hf
        for stable@vger.kernel.org; Fri, 12 Mar 2021 16:51:30 +0000
Received: by mail-wr1-f72.google.com with SMTP id r12so11425117wro.15
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 08:51:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qgJMb7e0L6iDhfG/tUpP60sFt9NuH2lLSYHHRGtBpt0=;
        b=LX7Ehd7mDom2rKe4CZPozC/JLbzd7GFvthKZ/2/1myFY1ZXrNGWejKo+kVxzZFvVaR
         x6ZdeTHR6jdC5dxRvPNJU8+YsNe6/LwGHJVMLhT/gjUHBCgSfx+jrZYtxgiI/e4RxkHT
         jEzvW+5yB2/TP/YaJvtDKOwK0uiRCwY3NQgBRe1gR3bueZY7EdXUEbnJ7cF5CN1vSYmg
         rkX+KafcvLszUySkwBcxZZ3QZGt45zyuBYGrMaJW1/cmhrf3lw0DNR/URo0fcYtAEcu8
         /xY/R07fMeSZqgPRWNjJXtk1cZx/Zyh32YW0I+aBwGL/RVBDD1iSJAGyGoLh/QCz/aho
         B3JA==
X-Gm-Message-State: AOAM532z89qGjP38AmoAxlYAr5QslJTKoNBcJ1HrrPY7rRK/4C0XgJjA
        r0aoGZmPVGOEDfEP3qzB9OdQ/wqGiHpuimNJEK8BWoyNpYpX39PTG17cS84OTBj4CUyaIkpZW/m
        EeO/RykZ5IGg6p3kTeyJO3akrBClv43nHNQ==
X-Received: by 2002:a1c:e18b:: with SMTP id y133mr14029159wmg.22.1615567889909;
        Fri, 12 Mar 2021 08:51:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0xo7+brGvBMfxf2ETyST8ZUezgEXTGJe7n3RK3PPXPD5K7bv6HFjQz4ArpGmlZfLkvRjbbA==
X-Received: by 2002:a1c:e18b:: with SMTP id y133mr14029148wmg.22.1615567889762;
        Fri, 12 Mar 2021 08:51:29 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id 9sm2618721wmf.13.2021.03.12.08.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:51:29 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Allen Pais <allen.pais@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH stable v4.4] libertas: fix a potential NULL pointer dereference
Date:   Fri, 12 Mar 2021 17:51:17 +0100
Message-Id: <20210312165117.15870-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Pais <allen.pais@oracle.com>

commit 7da413a18583baaf35dd4a8eb414fa410367d7f2 upstream.

alloc_workqueue is not checked for errors and as a result,
a potential NULL dereference could occur.

Signed-off-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[krzk: backport applied to different path - without marvell subdir]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/net/wireless/libertas/if_sdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 33ceda296c9c..45d68ee682f6 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1229,6 +1229,10 @@ static int if_sdio_probe(struct sdio_func *func,
 
 	spin_lock_init(&card->lock);
 	card->workqueue = create_workqueue("libertas_sdio");
+	if (unlikely(!card->workqueue)) {
+		ret = -ENOMEM;
+		goto err_queue;
+	}
 	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
 	init_waitqueue_head(&card->pwron_waitq);
 
@@ -1282,6 +1286,7 @@ err_activate_card:
 	lbs_remove_card(priv);
 free:
 	destroy_workqueue(card->workqueue);
+err_queue:
 	while (card->packets) {
 		packet = card->packets;
 		card->packets = card->packets->next;
-- 
2.25.1

