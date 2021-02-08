Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205703137E4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhBHPcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233765AbhBHPVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:21:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3264564F03;
        Mon,  8 Feb 2021 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797225;
        bh=57RCI6Z38s/Q0YH42kPR67PV4aWHjxJJRUY8Gs6Iu2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swzRrMNp5PYstx8Z2hx7vciN+2yq62uLCF3DdQ4wEVtfjI1GsM9aV+J5YEq1dNIYc
         brmhjhtK4CMPzakJ/DCel4T9Vm2OeIid6lHY97t35gNHKakgAK619U7WPCIV0DPx5e
         KOWXVwVuy4B7whqEsM4LNofTG+ktyGJrl/1nZ1VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Lo <kevlo@kevlo.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/120] igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr
Date:   Mon,  8 Feb 2021 16:00:23 +0100
Message-Id: <20210208145819.841261458@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Lo <kevlo@kevlo.org>

[ Upstream commit ebc8d125062e7dccb7922b2190b097c20d88ad96 ]

This patch sets the default return value to -IGC_ERR_NVM in
igc_write_nvm_srwr. Without this change it wouldn't lead to a shadow RAM
write EEWR timeout.

Fixes: ab4056126813 ("igc: Add NVM support")
Signed-off-by: Kevin Lo <kevlo@kevlo.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index 8b67d9b49a83a..7ec04e48860c6 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -219,9 +219,9 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 			      u16 *data)
 {
 	struct igc_nvm_info *nvm = &hw->nvm;
+	s32 ret_val = -IGC_ERR_NVM;
 	u32 attempts = 100000;
 	u32 i, k, eewr = 0;
-	s32 ret_val = 0;
 
 	/* A check for invalid values:  offset too large, too many words,
 	 * too many words for the offset, and not enough words.
@@ -229,7 +229,6 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 	if (offset >= nvm->word_size || (words > (nvm->word_size - offset)) ||
 	    words == 0) {
 		hw_dbg("nvm parameter(s) out of bounds\n");
-		ret_val = -IGC_ERR_NVM;
 		goto out;
 	}
 
-- 
2.27.0



