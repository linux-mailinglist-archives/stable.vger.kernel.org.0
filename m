Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19FC6CC51A
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjC1PMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjC1PMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FDAFF10
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:11:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB80A61867
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00598C433D2;
        Tue, 28 Mar 2023 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016172;
        bh=HVVtXfcA78ZJBe3W8NDeYREteQHGkVhMlf1yApDL8mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtWrs0l1PqKcRuZteLv65Es9WIk2mgfoHR1iopmAx7P5Qg10ltTspnvu0J+jHeg1q
         MNxQha4NkazKoEudRsRc8BvHpPNS/vNB7lRmMszORAOpm9yMo7mCHjMkDnG27CwkKJ
         Z2C+qU4HUdi2j0JSEUptl/COMWhTzrKwYWNBvHjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maurizio Lombardi <mlombard@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/146] scsi: target: iscsi: Fix an error message in iscsi_check_key()
Date:   Tue, 28 Mar 2023 16:43:00 +0200
Message-Id: <20230328142606.492492161@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
index 6bc3aaf655fc4..62004e3fe1ccc 100644
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



