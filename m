Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF8157C3B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgBJNf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:35:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgBJMfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:16 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDADD21569;
        Mon, 10 Feb 2020 12:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338114;
        bh=GzBI8V60FUYu9RM7Xn8K/45VI8KK+rbKc8M7kGcisDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBjVw2pYMfn3SYgx2I22NFlhtuRxHDQaCjLgSDsCZgZpfa3UVDNzc/LuhvJcRtqB8
         Qo7E1kevNYr0HXFjis9lYMwgm3ysmCb2e8Ovc+5IObUpbFwabSqydISmUnt7MVbJlW
         qzr9uW9+nbhb2xH2bXLY847MLPzfl9q0JS1z3de4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Sperling <stsp@stsp.name>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/195] iwlwifi: mvm: fix NVM check for 3168 devices
Date:   Mon, 10 Feb 2020 04:31:07 -0800
Message-Id: <20200210122306.693499498@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
index f2579c94ffdbc..3270faafe0bc3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -286,7 +286,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	int regulatory_type;
 
 	/* Checking for required sections */
-	if (mvm->trans->cfg->nvm_type != IWL_NVM_EXT) {
+	if (mvm->trans->cfg->nvm_type == IWL_NVM) {
 		if (!mvm->nvm_sections[NVM_SECTION_TYPE_SW].data ||
 		    !mvm->nvm_sections[mvm->cfg->nvm_hw_section_num].data) {
 			IWL_ERR(mvm, "Can't parse empty OTP/NVM sections\n");
-- 
2.20.1



