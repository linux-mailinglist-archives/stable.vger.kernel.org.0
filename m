Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E4829BF56
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793689AbgJ0PHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783122AbgJ0PBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:01:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D53122281;
        Tue, 27 Oct 2020 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810880;
        bh=6yKgwq8e8HHq/+1ESZe2uSaLfiZHyPcJfeyMHTAD5qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neuKJWM2+13mJDK/VV0ABbAosu/rNwR6fDjmeBKL4IM8s65alSW2+8Rwx+huUzDTq
         926xg/Kagxpbjgc+r1zQEtid5YWxtYAmRWtdxGA3hkpbRYQMHI1IQobBS53nPsfrWz
         +QsA4CW85CerHoAnJaQ+XiLT5pvICs12/tie9Yic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 296/633] iwlwifi: dbg: run init_cfg function once per driver load
Date:   Tue, 27 Oct 2020 14:50:39 +0100
Message-Id: <20201027135536.554247155@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 42f8a2735cc218b6b372134684d4cd3c1423f123 ]

Every time we call init_cfg driver appends the enabled triggers
to the active triggers while this should be done only once per
driver load.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: 14124b25780d ("iwlwifi: dbg_ini: implement monitor allocation flow")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200930161256.79bd622e604a.Ie0f79d2ea90ca5cdf363f56194ead81b0a2c6202@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 641da49b1b86e..48269a4cf8964 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -1011,6 +1011,9 @@ static void iwl_dbg_tlv_init_cfg(struct iwl_fw_runtime *fwrt)
 	enum iwl_fw_ini_buffer_location *ini_dest = &fwrt->trans->dbg.ini_dest;
 	int ret, i;
 
+	if (*ini_dest != IWL_FW_INI_LOCATION_INVALID)
+		return;
+
 	IWL_DEBUG_FW(fwrt,
 		     "WRT: Generating active triggers list, domain 0x%x\n",
 		     fwrt->trans->dbg.domains_bitmap);
-- 
2.25.1



