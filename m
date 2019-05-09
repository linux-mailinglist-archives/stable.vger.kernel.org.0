Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCAF18EE9
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfEIRYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:24:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37267 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfEIRYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 13:24:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id g3so1668146pfi.4
        for <stable@vger.kernel.org>; Thu, 09 May 2019 10:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wx8gaoHC5MOYV389XtnYNdY7stPe/BwS11WRGJ3X0jU=;
        b=NLbenTRuAo/KwttyYdSfiYeHTl8s02uccdxHkJwJLM2aY7TwvWQqlzRs0z8yANQP8R
         khMAKyxuFZJpgqgeNYGcHLqu5JE1xjX9RHiBh3YBz9oyDSgkjkxUuCIXX01cR7/10nQI
         rodbcT1oFhD5khMY98DrmTSlWUYOKTkyTYnlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wx8gaoHC5MOYV389XtnYNdY7stPe/BwS11WRGJ3X0jU=;
        b=Nrw0z5eDIFiQmlH2DIxZIOepq7L0Bk2niCc2WMRZdPnbS0L4ObRAm59O6QQcZEaw20
         odxBDbisxPcrncAJkGVnfnTmuUVfPanr02joCt62Y8f1eiLaOtSlNzQND5ebtrZXYOMs
         ANaWntQ90hgJOVCc1vlo4waOiZPwi7XVg4KnzF2Mtnov7/23qSUDKY+MypxyUZ7rOlTg
         aq7JMpWdYmwEr9SNrEAkWrdsuOmCnJaf2APSCcn9ZBs10lUFTw0wyZ1W9Ld3d4011dAK
         5uo3xZ6ttSvvnmloPNKOFF7o+PCtmZTFlQU4KYYoZEWDnHG3l7vLPTdrh76y2+sC7aL7
         i2Kw==
X-Gm-Message-State: APjAAAVzc0cxTj8XuncHDCI4rnUScmI25VAnOCMFQimGN7Pgn4bwbmKv
        f4p2HQq1kgsx/PnaoCbCG7sV+A==
X-Google-Smtp-Source: APXvYqwYqy8L9x/EoYgEU/4wY9WEr7lylwmLPU9640H1GKytWxa+mGBeQ/ZgM4Ryo2yw8qrfa7yERw==
X-Received: by 2002:aa7:9116:: with SMTP id 22mr6898551pfh.165.1557422679753;
        Thu, 09 May 2019 10:24:39 -0700 (PDT)
Received: from lbrmn-lnxub113.broadcom.net ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id m8sm3989699pgn.59.2019.05.09.10.24.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 10:24:39 -0700 (PDT)
From:   Scott Branden <scott.branden@broadcom.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc:     BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Trac Hoang <trac.hoang@broadcom.com>,
        stable@vger.kernel.org, Scott Branden <scott.branden@broadcom.com>
Subject: [PATCH v3 2/2] mmc: sdhci-iproc: Set NO_HISPD bit to fix HS50 data hold time problem
Date:   Thu,  9 May 2019 10:24:27 -0700
Message-Id: <20190509172427.17835-3-scott.branden@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190509172427.17835-1-scott.branden@broadcom.com>
References: <20190509172427.17835-1-scott.branden@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trac Hoang <trac.hoang@broadcom.com>

The iproc host eMMC/SD controller hold time does not meet the
specification in the HS50 mode.  This problem can be mitigated
by disabling the HISPD bit; thus forcing the controller output
data to be driven on the falling clock edges rather than the
rising clock edges.

Stable tag (v4.12+) chosen to assist stable kernel maintainers so that
the change does not produce merge conflicts backporting to older kernel
versions. In reality, the timing bug existed since the driver was first
introduced but there is no need for this driver to be supported in kernel
versions that old.

Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Trac Hoang <trac.hoang@broadcom.com>
Signed-off-by: Scott Branden <scott.branden@broadcom.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/mmc/host/sdhci-iproc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
index 9d4071c41c94..2feb4ef32035 100644
--- a/drivers/mmc/host/sdhci-iproc.c
+++ b/drivers/mmc/host/sdhci-iproc.c
@@ -220,7 +220,8 @@ static const struct sdhci_iproc_data iproc_cygnus_data = {
 
 static const struct sdhci_pltfm_data sdhci_iproc_pltfm_data = {
 	.quirks = SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
-		  SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
+		  SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
+		  SDHCI_QUIRK_NO_HISPD_BIT,
 	.quirks2 = SDHCI_QUIRK2_ACMD23_BROKEN,
 	.ops = &sdhci_iproc_ops,
 };
-- 
2.17.1

