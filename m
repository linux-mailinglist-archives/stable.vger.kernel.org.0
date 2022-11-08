Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8292662146C
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiKHOBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiKHOBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:01:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C85682B9
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:01:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D7CEFCE1B9C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCCEC433C1;
        Tue,  8 Nov 2022 14:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916065;
        bh=VIOVKyNBxA5MWvPBOZt+s23mY8bDL6KfWfAk+I4ppxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGydYE9av4ycugTyUETwmNU5PlRkWQvQQ0h40rMXscyf0XnDTr7Z3wa7DHbrLCi6z
         AMfgziO43MyZx9sZ/xD/T0MRiqHkStpU9yMk8aKoL1pV/svidcgcU1dMJXbcgbYaO6
         212fOfRaPvhWRAemszbn+ltblwZRV4OxbFICS5Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nick Child <nnac123@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/144] ibmvnic: Free rwi on reset success
Date:   Tue,  8 Nov 2022 14:38:50 +0100
Message-Id: <20221108133347.508651143@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit d6dd2fe71153f0ff748bf188bd4af076fe09a0a6 ]

Free the rwi structure in the event that the last rwi in the list
processed successfully. The logic in commit 4f408e1fa6e1 ("ibmvnic:
retry reset if there are no other resets") introduces an issue that
results in a 32 byte memory leak whenever the last rwi in the list
gets processed.

Fixes: 4f408e1fa6e1 ("ibmvnic: retry reset if there are no other resets")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Link: https://lore.kernel.org/r/20221031150642.13356-1-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4a070724a8fb..8a92c6a6e764 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2621,19 +2621,19 @@ static void __ibmvnic_reset(struct work_struct *work)
 		rwi = get_next_rwi(adapter);
 
 		/*
-		 * If there is another reset queued, free the previous rwi
-		 * and process the new reset even if previous reset failed
-		 * (the previous reset could have failed because of a fail
-		 * over for instance, so process the fail over).
-		 *
 		 * If there are no resets queued and the previous reset failed,
 		 * the adapter would be in an undefined state. So retry the
 		 * previous reset as a hard reset.
+		 *
+		 * Else, free the previous rwi and, if there is another reset
+		 * queued, process the new reset even if previous reset failed
+		 * (the previous reset could have failed because of a fail
+		 * over for instance, so process the fail over).
 		 */
-		if (rwi)
-			kfree(tmprwi);
-		else if (rc)
+		if (!rwi && rc)
 			rwi = tmprwi;
+		else
+			kfree(tmprwi);
 
 		if (rwi && (rwi->reset_reason == VNIC_RESET_FAILOVER ||
 			    rwi->reset_reason == VNIC_RESET_MOBILITY || rc))
-- 
2.35.1



