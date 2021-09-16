Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCCC40E4A0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343807AbhIPREy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347306AbhIPQ6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:58:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E1306137D;
        Thu, 16 Sep 2021 16:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809919;
        bh=cp4aSFPOVoAmW7bC4hEc24SYlKqIiehUK6guMD+qXfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiU8CPPUErOFPbekf7NzoICb5vZVJ7YsJnPayBJmOjK59M3G48yxZNxAgThcIQqdJ
         Zva5kI9Mj5sOZoFO3pMb8xPGkLnORTkyBiqrY/Otx9djQhONDnD9J5Tr5hOazBVycI
         YPlAO27G498vwOnXkIX5V9yXGpDCB38FvK5e6bGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 332/380] iwlwifi: fw: correctly limit to monitor dump
Date:   Thu, 16 Sep 2021 18:01:29 +0200
Message-Id: <20210916155815.342312400@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e6344c060209ef4e970cac18adeac1676a2a73cd ]

In commit 79f033f6f229 ("iwlwifi: dbg: don't limit dump decisions
to all or monitor") we changed the code to pass around a bitmap,
but in the monitor_only case, one place accidentally used the bit
number, not the bit mask, resulting in CSR and FW_INFO getting
dumped instead of monitor data. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210805141826.774fd8729a33.Ic985a787071d1c0b127ef0ba8367da896ee11f57@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index cc4e18ca9566..a27849419d29 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2314,7 +2314,7 @@ static void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 		return;
 
 	if (dump_data->monitor_only)
-		dump_mask &= IWL_FW_ERROR_DUMP_FW_MONITOR;
+		dump_mask &= BIT(IWL_FW_ERROR_DUMP_FW_MONITOR);
 
 	fw_error_dump.trans_ptr = iwl_trans_dump_data(fwrt->trans, dump_mask);
 	file_len = le32_to_cpu(dump_file->file_len);
-- 
2.30.2



