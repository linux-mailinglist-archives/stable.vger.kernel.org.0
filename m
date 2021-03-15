Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527A733B9AE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhCOOGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233437AbhCOOBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB0964EF1;
        Mon, 15 Mar 2021 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816883;
        bh=t2kXVhCygr/Irc8LjJKIfjkulQLJyD61VWf/iS374OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irE2G8pq1tucTngCACEU17q5NrJG4t4Sp/GMUPqpHV7Rjd08o141Q8d+yVoRmcfNj
         5IuJ3TQwdCpzSw+sB1ZxZEhFft6oELMH4rZbMZasU6vki1dLhNIWk6ul4Rf7xK3Kq+
         Y0hkcTTVAfs2HbvSG1YMYhPmPV98YNprrkIjJxFw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/290] mmc: sdhci: Update firmware interface API
Date:   Mon, 15 Mar 2021 14:54:20 +0100
Message-Id: <20210315135547.545767872@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit c5b1c6dc13daec60405ecd31eaa5379a9f798fa8 ]

The device_* calls were added a few years ago to abstract
DT/ACPI/fwnode firmware interfaces. Lets convert the two
sdhci caps fields to use the generic calls rather than the OF
specific ones. This has the side effect of allowing
ACPI based devices to quirk themselves when the caps field
is broken.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Link: https://lore.kernel.org/r/20201120233831.447365-1-jeremy.linton@arm.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 3561ae8a481a..6edf9fffd934 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3994,10 +3994,10 @@ void __sdhci_read_caps(struct sdhci_host *host, const u16 *ver,
 	if (host->v4_mode)
 		sdhci_do_enable_v4_mode(host);
 
-	of_property_read_u64(mmc_dev(host->mmc)->of_node,
-			     "sdhci-caps-mask", &dt_caps_mask);
-	of_property_read_u64(mmc_dev(host->mmc)->of_node,
-			     "sdhci-caps", &dt_caps);
+	device_property_read_u64_array(mmc_dev(host->mmc),
+				       "sdhci-caps-mask", &dt_caps_mask, 1);
+	device_property_read_u64_array(mmc_dev(host->mmc),
+				       "sdhci-caps", &dt_caps, 1);
 
 	v = ver ? *ver : sdhci_readw(host, SDHCI_HOST_VERSION);
 	host->version = (v & SDHCI_SPEC_VER_MASK) >> SDHCI_SPEC_VER_SHIFT;
-- 
2.30.1



