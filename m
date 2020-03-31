Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C262199E2F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 20:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgCaSi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 14:38:56 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33611 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbgCaSiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 14:38:55 -0400
Received: by mail-lf1-f66.google.com with SMTP id x200so11040990lff.0
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 11:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KW3Lbde0NrLlMFOPBVL9VFr/xqlRRv5C9s8T2uV/EC8=;
        b=YAzpmToCHjPKwhVBcWenpASCnFKvzdesYgGqqYMRCP6llJmlm7Y0lj5BXG7cxcVRIl
         1fQhsBHrIpdVSutqQJVbpCEti0sA06lsT2dwQTcMRT/nIwMMC4O94hZhauz+WI9GJO6p
         12WAtAAApshg2SASKYHsA3S/db71nblcaq3R52IYHCxiGj7rIDzrt1M+tKgLtq7iTSFU
         aODeaHftNj89LL0xeI0W+Hei2+iJIAT2joCgO2P38SQDfWP6+Ktk5uEgbg+CJVvx4E49
         ZrGqhnUVONAeEWgjWrVaZ3BhXiqrh+R/IFaUyAlqH2Zjkgh2qY9Z0AkIAL6AblS6MrhU
         Y3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KW3Lbde0NrLlMFOPBVL9VFr/xqlRRv5C9s8T2uV/EC8=;
        b=etLSRzyL+VR25pB26ZAym4W8f+0NYzT+99naJepYhTXuytWtoK8sxPlMXQgCI2t9nS
         cBbg/i9wvVsAHqM16ACg56a4YEI6w5rbojBarU7xlycY4POwukuWRa94zhwWg60tJWD0
         FOAAnjyz1sWoz7Cw55Lerj2qgrum22zqHIMqxRTSMPTfez67qSuKgwtIrXqWtVZlVfPZ
         yn1R5eo5T3DjaPExRB217yz/GvE6w4w/Z1VKMNkHBSsazc2M3vLViZOz8m+6QDgnXLF+
         4DdaxZlghjZNe2R6iHaKI1Q5KEO6TCoStv95pYQOTVfafdjGeKlHAsvjbKIqO9fJdbO1
         gxKA==
X-Gm-Message-State: AGi0PuZDpb+f8tDfYCE3mnFzQy2S1zAfYhS0dvMN/kq3dh7hYHdJ9yWT
        hUPJzYcpdBixs8slBB/HbMmrnw==
X-Google-Smtp-Source: APiQypJ8E6I5iZxeoPH0TWIB8ALP7NCLvCUGTgJRpQtCJG/xvf6AdHVA3ceds7R25cl2FPBp6aBIHA==
X-Received: by 2002:a05:6512:3091:: with SMTP id z17mr12711035lfd.42.1585679932325;
        Tue, 31 Mar 2020 11:38:52 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id b28sm10331849ljp.90.2020.03.31.11.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 11:38:51 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Vinod Koul <vkoul@kernel.org>, Haibo Chen <haibo.chen@nxp.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] amba: Initialize dma_parms for amba devices
Date:   Tue, 31 Mar 2020 20:38:44 +0200
Message-Id: <20200331183844.30488-3-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200331183844.30488-1-ulf.hansson@linaro.org>
References: <20200331183844.30488-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's currently the amba driver's responsibility to initialize the pointer,
dma_parms, for its corresponding struct device. The benefit with this
approach allows us to avoid the initialization and to not waste memory for
the struct device_dma_parameters, as this can be decided on a case by case
basis.

However, it has turned out that this approach is not very practical. Not
only does it lead to open coding, but also to real errors. In principle
callers of dma_set_max_seg_size() doesn't check the error code, but just
assumes it succeeds.

For these reasons, let's do the initialization from the common amba bus at
the device registration point. This also follows the way the PCI devices
are being managed, see pci_device_add().

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---

Changes in v2:
	- Move initialization to amba_device_initialize() to be more consistent
	with how we manage platform devices.

---
 drivers/amba/bus.c       | 1 +
 include/linux/amba/bus.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index fe1523664816..8558b629880b 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -645,6 +645,7 @@ static void amba_device_initialize(struct amba_device *dev, const char *name)
 	dev->dev.release = amba_device_release;
 	dev->dev.bus = &amba_bustype;
 	dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
+	dev->dev.dma_parms = &dev->dma_parms;
 	dev->res.name = dev_name(&dev->dev);
 }
 
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 26f0ecf401ea..0bbfd647f5c6 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -65,6 +65,7 @@ struct amba_device {
 	struct device		dev;
 	struct resource		res;
 	struct clk		*pclk;
+	struct device_dma_parameters dma_parms;
 	unsigned int		periphid;
 	unsigned int		cid;
 	struct amba_cs_uci_id	uci;
-- 
2.20.1

