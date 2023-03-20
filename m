Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490076C0890
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCTBcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjCTBcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:32:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABE71C7F5;
        Sun, 19 Mar 2023 18:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA9E9B80D4E;
        Mon, 20 Mar 2023 00:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9043DC433D2;
        Mon, 20 Mar 2023 00:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273865;
        bh=RxUOKQnkZ51m0C4w7P7Mc8ot7XLDQpDTuCM0VAoHUxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpCNVph5UHEgjAgLtUF3Ez0Qh10lsjyDCtL4F8qLjb6nVf4BL/peKsNE7zHTIwRzj
         B+bsBemwjEuvpjcOoKDALFpQj0kDP0uWlbiskAFlqr7OIpICUsIGdPtJ2KcOz0OJbq
         iZpxbsCiNbzq2e+eJOAhS9NRqDOZoV/LQitgHI6xE5a0aOlqliFqQCl1/dUscnoIbW
         dtxqMIb/ylr11LFSpXFL/U3MC/2Xl6U8QF1nbJCRjhj9eDHVPtRuIm2BiOOkjX/HPF
         Fc8g6LagZtOWxJ89qQ8OnX+aT8k5qGCM6/ZIbMY3++gJR5S7lvJEYssHglbUtvbY5B
         p2MHdv7CR0cqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, mgurtovoy@nvidia.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/9] scsi: target: iscsi: Fix an error message in iscsi_check_key()
Date:   Sun, 19 Mar 2023 20:57:28 -0400
Message-Id: <20230320005732.1429533-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005732.1429533-1-sashal@kernel.org>
References: <20230320005732.1429533-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 6cc55c969b7ce8d85e09a636693d4126c3676c11 ]

The first half of the error message is printed by pr_err(), the second half
is printed by pr_debug(). The user will therefore see only the first part
of the message and will miss some useful information.

Link: https://lore.kernel.org/r/20230214141556.762047-1-mlombard@redhat.com
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index caab1045742df..d2c8c4929f93a 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1270,18 +1270,20 @@ static struct iscsi_param *iscsi_check_key(
 		return param;
 
 	if (!(param->phase & phase)) {
-		pr_err("Key \"%s\" may not be negotiated during ",
-				param->name);
+		char *phase_name;
+
 		switch (phase) {
 		case PHASE_SECURITY:
-			pr_debug("Security phase.\n");
+			phase_name = "Security";
 			break;
 		case PHASE_OPERATIONAL:
-			pr_debug("Operational phase.\n");
+			phase_name = "Operational";
 			break;
 		default:
-			pr_debug("Unknown phase.\n");
+			phase_name = "Unknown";
 		}
+		pr_err("Key \"%s\" may not be negotiated during %s phase.\n",
+				param->name, phase_name);
 		return NULL;
 	}
 
-- 
2.39.2

