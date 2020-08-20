Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9302C24B406
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgHTJzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbgHTJzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:55:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C6592173E;
        Thu, 20 Aug 2020 09:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917339;
        bh=SriRrDedMudRpYmWo2kpmKuWSF9BDf4K95kArhbHnPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPpDSE+BpKbDIp5dMdmz9ew8r3lsmsZvV1KwEbH8xLOTG367A777DIC1UztT1rnjv
         Fh3wMaksUX8fgcWPT/UTh/qNXYuQ+0+vw+r499AfeLe/FmvNS1ktwaTe04mECd23Tn
         LaSFa1IM7nYxL+7Nk5DKlNE4Htwyz7QlPL5cgYuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 90/92] drm/radeon: fix fb_div check in ni_init_smc_spll_table()
Date:   Thu, 20 Aug 2020 11:22:15 +0200
Message-Id: <20200820091542.324851351@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit f29aa08852e1953e461f2d47ab13c34e14bc08b3 upstream.

clk_s is checked twice in a row in ni_init_smc_spll_table().
fb_div should be checked instead.

Fixes: 69e0b57a91ad ("drm/radeon/kms: add dpm support for cayman (v5)")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni_dpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -2123,7 +2123,7 @@ static int ni_init_smc_spll_table(struct
 		if (p_div & ~(SMC_NISLANDS_SPLL_DIV_TABLE_PDIV_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_PDIV_SHIFT))
 			ret = -EINVAL;
 
-		if (clk_s & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_SHIFT))
+		if (fb_div & ~(SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_SHIFT))
 			ret = -EINVAL;
 
 		if (fb_div & ~(SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_SHIFT))


