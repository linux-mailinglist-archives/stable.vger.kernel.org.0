Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E99106EBE
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbfKVLBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:01:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730365AbfKVLBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:01:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0675A2075E;
        Fri, 22 Nov 2019 11:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420466;
        bh=cIE1zYKfcZTQBUxrXx9F25efKOGTmGUOS7M5KGSXFuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=as3SWSRiUmKfpD96wD+NgEhnzYr2M/2wCUf0kLNIxqJ9YR5hFbeT20g25uFUosJdI
         fxIb7uwVRmjSn6Hk3lwsE+ondoY6gtsOR4ieuCYVwoBIFQFTbzeK0/c+PERYfRMxYJ
         pyat0Bw6YydUXa8tjr3B63mn4wByeptwR/clpyZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/220] qtnfmac: pass sgi rate info flag to wireless core
Date:   Fri, 22 Nov 2019 11:27:59 +0100
Message-Id: <20191122100920.946470538@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit d5657b709e2a92a0e581109010765d1d485580df ]

SGI should be passed to wireless core as a part of rate structure.
Otherwise wireless core performs incorrect rate calculation when
SGI is enabled in hardware but not reported to host.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index ae9e773005339..7fe22bb53bfc4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -544,6 +544,9 @@ qtnf_sta_info_parse_rate(struct rate_info *rate_dst,
 		rate_dst->flags |= RATE_INFO_FLAGS_MCS;
 	else if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_VHT_MCS)
 		rate_dst->flags |= RATE_INFO_FLAGS_VHT_MCS;
+
+	if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_SHORT_GI)
+		rate_dst->flags |= RATE_INFO_FLAGS_SHORT_GI;
 }
 
 static void
-- 
2.20.1



