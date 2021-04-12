Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A18835C0A0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240737AbhDLJPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240984AbhDLJLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 257F5613AD;
        Mon, 12 Apr 2021 09:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218463;
        bh=pVA0Qb5ZTGEkOb6cYmFWkQ0YdOSVcEhyp3g8m9oOVAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qu70VD4pbWsDJPDFk3PzdQQ2Jrm1g32RUHYEGykiTi5R8KOedhpX8wzJxQmUJ3M/g
         ejFTW/Vik5epoDygBvzbq758truNYE++ES43xWhHLVvcWzmHMowbdtpszIInQdlElI
         wNovJG2iDeWE0NqN79GJ4X32QRtEjKsv/ju1vBIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 173/210] iwlwifi: fix 11ax disabled bit in the regulatory capability flags
Date:   Mon, 12 Apr 2021 10:41:18 +0200
Message-Id: <20210412084021.781886979@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 07cc40fec9a85e669ea12e161a438d2cbd76f1ed ]

When version 2 of the regulatory capability flags API was implemented,
the flag to disable 11ax was defined as bit 13, but this was later
changed and the bit remained as bit 10, like in version 1.  This was
never changed in the driver, so we were checking for the wrong bit in
newer devices.  Fix it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: e27c506a985c ("iwlwifi: regulatory: regulatory capabilities api change")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210326125611.6d28516b59cd.Id0248d5e4662695254f49ce37b0268834ed52918@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 720193d16539..7da193a12871 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -232,7 +232,7 @@ enum iwl_reg_capa_flags_v2 {
 	REG_CAPA_V2_MCS_9_ALLOWED	= BIT(6),
 	REG_CAPA_V2_WEATHER_DISABLED	= BIT(7),
 	REG_CAPA_V2_40MHZ_ALLOWED	= BIT(8),
-	REG_CAPA_V2_11AX_DISABLED	= BIT(13),
+	REG_CAPA_V2_11AX_DISABLED	= BIT(10),
 };
 
 /*
-- 
2.30.2



