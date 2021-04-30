Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDB836FDA2
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhD3PWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 11:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhD3PWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 11:22:55 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4568CC06174A;
        Fri, 30 Apr 2021 08:22:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e2so32459301plh.8;
        Fri, 30 Apr 2021 08:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pTK2+tXKXlDNh7BndZWyfsnbTIToWlHunFXdpF9eDN4=;
        b=ooM+TPJPR5n+5ONlVr4BI4DoiNj41EIJgTRlDlafBvjIPqB1VUYcaC3DELnCdE2g0y
         HjqtCn6/48IMprlDdb86taWe4Qw9uw0xgFJtVqMSCQNgwKKcnw7RFD3WiOeYd5jwXPpd
         3H0cMz7SS3ybe9MP1xRanIOsks+uUBi22cRJIVgtLfFJgkC023YRwNHAkyvxR+SRk/f7
         pjWjb+l5uejmgYoLAoXbzInexTpuGwubbX5bmpIrSI1G1rjdPfTerj4vChXBarbF3240
         O9WpAUQRlmUw2KK1EiKjIs7fXdICLPPmH3fn9yoXVZ3ETj/ZthK+bwJGE+NG/nX1R5CR
         O82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pTK2+tXKXlDNh7BndZWyfsnbTIToWlHunFXdpF9eDN4=;
        b=j0f97/odWINZTS1l8yXUiEDfNsnbXbAAiLZrzy9hiwlS32S35JgYt7yHfcGal3Im6E
         4yZ/fkD7fXEY9Ajf9L3dwHyxGqNRGj/pMy18dmhy+YAe4j4Eg2ohdjUG9tYcWUrqCJo0
         2M3q8WzgPEMcsaq+jDlRTQCKGTyvykNpEzj/Bg7z8QFPWdG/7OAPCZPqmrsH17ZzQ45Q
         Ew6IDTGiSex65/zC8a4TDugPRXHtegYaf/ozngfy8qbhiz096DqCxmhbUt7YiHGqBaij
         TlHs7lF8+P7eEvJzP/57e5hlTibwKS3dhFR8nUMM/y8FZ8JWD+ZYOyNau0HYOFL1F4Gg
         7awQ==
X-Gm-Message-State: AOAM531xSoADqCgUYgNBWK9sgq9Z9/LlW//FrEZTopglzeeGq2O+5PqE
        VMatNlRP1eoJ6j0NttuRlIs=
X-Google-Smtp-Source: ABdhPJzm9HT86DnclS99Kv824zsCX+OC/Fjc1Oxh/mxyDmHUArj4qmeRwqbubhayouz1Id1A4kp8dw==
X-Received: by 2002:a17:90a:c903:: with SMTP id v3mr15689200pjt.13.1619796126947;
        Fri, 30 Apr 2021 08:22:06 -0700 (PDT)
Received: from stbsrv-and-01.and.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id q128sm2543034pfb.67.2021.04.30.08.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 08:22:06 -0700 (PDT)
From:   Jim Quinlan <jim2101024@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Amjad Ouled-Ameur <aouledameur@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-pci@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        bcm-kernel-feedback-list@broadcom.com, james.quinlan@broadcom.com,
        jim2101024@gmail.com
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 1/3] reset: add missing empty function reset_control_rearm()
Date:   Fri, 30 Apr 2021 11:21:54 -0400
Message-Id: <20210430152156.21162-2-jim2101024@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430152156.21162-1-jim2101024@gmail.com>
References: <20210430152156.21162-1-jim2101024@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All other functions are defined for when CONFIG_RESET_CONTROLLER
is not set.

Fixes: 557acb3d2cd9 ("reset: make shared pulsed reset controls re-triggerable")
CC: stable@vger.kernel.org # v5.11+
Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
---
 include/linux/reset.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index b9109efa2a5c..9700124affa3 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -47,6 +47,11 @@ static inline int reset_control_reset(struct reset_control *rstc)
 	return 0;
 }
 
+static inline int reset_control_rearm(struct reset_control *rstc)
+{
+	return 0;
+}
+
 static inline int reset_control_assert(struct reset_control *rstc)
 {
 	return 0;
-- 
2.17.1

