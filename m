Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3605840E84C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354005AbhIPRoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354970AbhIPRkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B70561C13;
        Thu, 16 Sep 2021 16:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811116;
        bh=+5m58+xQFmCuoTRYQN3SD0DmLLnkSLmePDjsPWnD0ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKplMAbZoDpu7txKBbHNBE4yhuV7pzjkxfRhsxi7s7tmsWmENJfrujdkigrWwvDFQ
         J+ZJQZ14W0o11WVKRjlcwBCNiTR0PBBgugV+WRhviZ63XNXUkFjt/pHcSUPZsbSeAb
         v3YX+xD3y5Mb28bilb5jqAwbPqY8frs1y6u+HgJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 372/432] iwlwifi: fw: correctly limit to monitor dump
Date:   Thu, 16 Sep 2021 18:02:01 +0200
Message-Id: <20210916155823.407974945@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index df7c55e06f54..a13fe01e487b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2321,7 +2321,7 @@ static void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 		return;
 
 	if (dump_data->monitor_only)
-		dump_mask &= IWL_FW_ERROR_DUMP_FW_MONITOR;
+		dump_mask &= BIT(IWL_FW_ERROR_DUMP_FW_MONITOR);
 
 	fw_error_dump.trans_ptr = iwl_trans_dump_data(fwrt->trans, dump_mask);
 	file_len = le32_to_cpu(dump_file->file_len);
-- 
2.30.2



