Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39ACF6C07AD
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCTBAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjCTA77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:59:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100E32202F;
        Sun, 19 Mar 2023 17:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9393DB80D42;
        Mon, 20 Mar 2023 00:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2A1C4339B;
        Mon, 20 Mar 2023 00:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273777;
        bh=K+V39EeKe6iCTrbQd/BlGo1gjFZe4Ik03rVWVFz+ysk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blKawkgHnlLdegv9icv8CDXZTHQGJDmxAWL0YqrBDAhkyD/PPCsYEKNDZGAk8XeBs
         K+8vZQH3B2OyTp8egm/fXDSVRdu2F/IeiFqVhGVd1WEUguk1hw62WOSJjOdRIRa0KL
         44xyk9RBICjR//3PX++VO39cfD+Yl789s7CliwqVFSiZQYx66Dfa3vXSbICrQ7f4sS
         S9Den69IDDjmYVI/XGrfcEOYK4zvMz1lLYRvJEtF9iaaNonyrurnskHd/YjjXb4uwb
         PigvlKpwXlx4nU492GAMRj6jX+N/EO0UMUd/h3SmbERSQYSznYo+XLGqLqBt8S3ar2
         gV9goXNpjIZ0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, mgurtovoy@nvidia.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/15] scsi: target: iscsi: Fix an error message in iscsi_check_key()
Date:   Sun, 19 Mar 2023 20:55:51 -0400
Message-Id: <20230320005559.1429040-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005559.1429040-1-sashal@kernel.org>
References: <20230320005559.1429040-1-sashal@kernel.org>
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
index 7a461fbb15668..31cd3c02e5176 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1262,18 +1262,20 @@ static struct iscsi_param *iscsi_check_key(
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

