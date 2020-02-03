Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC95150C14
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgBCQdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:33:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730531AbgBCQdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:10 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F7882051A;
        Mon,  3 Feb 2020 16:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747589;
        bh=GzBI8V60FUYu9RM7Xn8K/45VI8KK+rbKc8M7kGcisDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDKQTNgahB5ZNOgkhCh/eE53/dSyhkp345KE4+zwE5lE1Ejvt9UFqJvy9am9Setu0
         /zQFkJAXFePJac9UElRzySzkuKvW3GcE8ENMzhdekKoOSGbAZfgjDr9KBF25aQqsx4
         hHoLNdg4and+c3OTHB5vf/q+rp4SzmjfdfdGmcQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Sperling <stsp@stsp.name>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/70] iwlwifi: mvm: fix NVM check for 3168 devices
Date:   Mon,  3 Feb 2020 16:20:02 +0000
Message-Id: <20200203161919.566332299@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
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



