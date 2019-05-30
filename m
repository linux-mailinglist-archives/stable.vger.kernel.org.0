Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711632F45A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbfE3Eh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbfE3DMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:52 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BB7421BE2;
        Thu, 30 May 2019 03:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185971;
        bh=jRfTBW2JkF8yxRD513xsOEnLvb8aGirahpO9atWfbZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNRgOzout4uI9TXbeZxnH2w7nJgJoq6+REqjtfCTqGz7Ir7hBxq0ofSTqRRbABccv
         Rm9WFYIJEEeITsrNFpT3m5JNTGS/U5CPlnV1IJniQDMJSzCaOGmDpr02LdpapJvZOL
         TuGmV/pe4VdPHclInxcYdAmcyf0ZtZIxfqaC/fiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 403/405] ice: Put __ICE_PREPARED_FOR_RESET check in ice_prepare_for_reset
Date:   Wed, 29 May 2019 20:06:41 -0700
Message-Id: <20190530030600.929953416@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5abac9d7e1bb9a373673811154774d4c89a7f85e ]

Currently we check if the __ICE_PREPARED_FOR_RESET bit is set prior to
calling ice_prepare_for_reset in ice_reset_subtask(), but we aren't
checking that bit in ice_do_reset() before calling
ice_prepare_for_reset(). This is not consistent and can cause issues if
ice_prepare_for_reset() is called prior to ice_do_reset(). Fix this by
checking if the __ICE_PREPARED_FOR_RESET bit is set internal to
ice_prepare_for_reset().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ba9f88cd138de..6ec73864019c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -342,6 +342,10 @@ ice_prepare_for_reset(struct ice_pf *pf)
 {
 	struct ice_hw *hw = &pf->hw;
 
+	/* already prepared for reset */
+	if (test_bit(__ICE_PREPARED_FOR_RESET, pf->state))
+		return;
+
 	/* Notify VFs of impending reset */
 	if (ice_check_sq_alive(hw, &hw->mailboxq))
 		ice_vc_notify_reset(pf);
@@ -424,8 +428,7 @@ static void ice_reset_subtask(struct ice_pf *pf)
 		/* return if no valid reset type requested */
 		if (reset_type == ICE_RESET_INVAL)
 			return;
-		if (!test_bit(__ICE_PREPARED_FOR_RESET, pf->state))
-			ice_prepare_for_reset(pf);
+		ice_prepare_for_reset(pf);
 
 		/* make sure we are ready to rebuild */
 		if (ice_check_reset(&pf->hw)) {
-- 
2.20.1



