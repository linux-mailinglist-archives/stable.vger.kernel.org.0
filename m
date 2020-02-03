Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0897A150D84
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgBCQaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:30:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbgBCQap (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:45 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC7620838;
        Mon,  3 Feb 2020 16:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747444;
        bh=eb1UltVrFvwiuZunsalF4EFcmZxE9toebsgbA/VaFy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cS9QQhyV93liM4J3ej31i1QDsGEQAWfwqEYN/qCDWsS7nb7sJ5b1K8B1cL0WNRinm
         hJw99DwMQR21uh2ian+tmkqz694HGhwPas2/QFjSpRpWSM9GaPBPSPnfiHb9LBAvq5
         5LeFq0lPE3pkA5+ENLj7vBRx6gXlPswG1wyIUepU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Sperling <stsp@stsp.name>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 69/89] iwlwifi: mvm: fix NVM check for 3168 devices
Date:   Mon,  3 Feb 2020 16:19:54 +0000
Message-Id: <20200203161925.499127264@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit b3f20e098293892388d6a0491d6bbb2efb46fbff ]

We had a check on !NVM_EXT and then a check for NVM_SDP in the else
block of this if.  The else block, obviously, could only be reached if
using NVM_EXT, so it would never be NVM_SDP.

Fix that by checking whether the nvm_type is IWL_NVM instead of
checking for !IWL_NVM_EXT to solve this issue.

Reported-by: Stefan Sperling <stsp@stsp.name>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index ca2d66ce84247..8f3032b7174d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -298,7 +298,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	int regulatory_type;
 
 	/* Checking for required sections */
-	if (mvm->trans->cfg->nvm_type != IWL_NVM_EXT) {
+	if (mvm->trans->cfg->nvm_type == IWL_NVM) {
 		if (!mvm->nvm_sections[NVM_SECTION_TYPE_SW].data ||
 		    !mvm->nvm_sections[mvm->cfg->nvm_hw_section_num].data) {
 			IWL_ERR(mvm, "Can't parse empty OTP/NVM sections\n");
-- 
2.20.1



