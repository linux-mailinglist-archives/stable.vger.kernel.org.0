Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD52F2F236
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbfE3DPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729421AbfE3DPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F0E224559;
        Thu, 30 May 2019 03:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186122;
        bh=dUEoD5pI6IaWmByjfL+gkmeK+LsuNk9JL1SYnLz9FQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Deuu4FB7/w3dfUFy7sFMs0deE8jJGa1q+3chFxWIB63VF64c737piUw5JfipIu9a9
         Q9pzktxJuyR3bdZ0XT6eGDN5MyUntjtPGIciJe7SA3deuNMXTj1tgAfBuYJG+kfd3G
         FnGSMYQ7VkQ3GziVO7+2c2zXok2WBqdcHeiJFfak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 279/346] ice: Prevent unintended multiple chain resets
Date:   Wed, 29 May 2019 20:05:52 -0700
Message-Id: <20190530030555.063328053@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2ebd4428d93a2f6ce0c813b10a1a43b6a8241fe5 ]

In the current implementation of ice_reset_subtask, if multiple reset
types are set in the pf->state, the most intrusive one is meant to be
performed only, but the bits requesting the other types are not being
cleared. This would lead to another reset being performed the next time
the service task is scheduled.

Change the flow of ice_reset_subtask so that all reset request bits in
pf->state are cleared, and we still perform the most intrusive of the
resets requested.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d083979acc22c..43064b4176d38 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -416,8 +416,14 @@ static void ice_reset_subtask(struct ice_pf *pf)
 	 * for the reset now), poll for reset done, rebuild and return.
 	 */
 	if (test_bit(__ICE_RESET_OICR_RECV, pf->state)) {
-		clear_bit(__ICE_GLOBR_RECV, pf->state);
-		clear_bit(__ICE_CORER_RECV, pf->state);
+		/* Perform the largest reset requested */
+		if (test_and_clear_bit(__ICE_CORER_RECV, pf->state))
+			reset_type = ICE_RESET_CORER;
+		if (test_and_clear_bit(__ICE_GLOBR_RECV, pf->state))
+			reset_type = ICE_RESET_GLOBR;
+		/* return if no valid reset type requested */
+		if (reset_type == ICE_RESET_INVAL)
+			return;
 		if (!test_bit(__ICE_PREPARED_FOR_RESET, pf->state))
 			ice_prepare_for_reset(pf);
 
-- 
2.20.1



