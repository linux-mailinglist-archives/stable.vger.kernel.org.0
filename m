Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C176D4774
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbjDCOUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjDCOUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E5D31282
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 155B461D18
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A055C433D2;
        Mon,  3 Apr 2023 14:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531588;
        bh=K+V39EeKe6iCTrbQd/BlGo1gjFZe4Ik03rVWVFz+ysk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ib3jNCv/zdJOsA/vysJtpuICsdwhmdO7xO5ipsiESOBgbctBUzBR7eg2zGqu0hE6s
         JfW0OWalybrfiBnPDPkOuZuMNiE/IQyGu+2RjPrqkvziqwtJtg0EAXEda2xB1Y6Hhv
         UnhgnnV/LTbPCMWY4FrX0Upc2jpA+2rJxBxqE1Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maurizio Lombardi <mlombard@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/104] scsi: target: iscsi: Fix an error message in iscsi_check_key()
Date:   Mon,  3 Apr 2023 16:08:28 +0200
Message-Id: <20230403140405.769042838@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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



