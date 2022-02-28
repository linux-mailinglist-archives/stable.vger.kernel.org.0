Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E474C75D0
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbiB1R4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238939AbiB1Ryq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB88185;
        Mon, 28 Feb 2022 09:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4364B81085;
        Mon, 28 Feb 2022 17:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE69C340E7;
        Mon, 28 Feb 2022 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070259;
        bh=syIQldVdX7I9vkT6zF0HEwnuMxLsFBKjlVxG6GEJKu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02rxw8IiMEio/YykV64XcFrTGiD5pZg09vAb/KYLfu7rMJX0RhyVIHsiwV6Kc8Hpg
         HQRVE8At/zhR+1RPhHgJqIz/71JcFY9ClcbQc5dF5J000W/98nMuL8/HqKlLxJh0rp
         0BPf8LPKrTGRc89jGeJjqvM+5HRVMmafp1x7hUXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikas Gupta <vikas.gupta@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 043/164] bnxt_en: Fix devlink fw_activate
Date:   Mon, 28 Feb 2022 18:23:25 +0100
Message-Id: <20220228172404.168604422@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

commit 1278d17a1fb860e7eab4bc3ff4b026a87cbf5105 upstream.

To install a livepatch, first flash the package to NVM, and then
activate the patch through the "HWRM_FW_LIVEPATCH" fw command.
To uninstall a patch from NVM, flash the removal package and then
activate it through the "HWRM_FW_LIVEPATCH" fw command.

The "HWRM_FW_LIVEPATCH" fw command has to consider following scenarios:

1. no patch in NVM and no patch active. Do nothing.
2. patch in NVM, but not active. Activate the patch currently in NVM.
3. patch is not in NVM, but active. Deactivate the patch.
4. patch in NVM and the patch active. Do nothing.

Fix the code to handle these scenarios during devlink "fw_activate".

To install and activate a live patch:
devlink dev flash pci/0000:c1:00.0 file thor_patch.pkg
devlink -f dev reload pci/0000:c1:00.0 action fw_activate limit no_reset

To remove and deactivate a live patch:
devlink dev flash pci/0000:c1:00.0 file thor_patch_rem.pkg
devlink -f dev reload pci/0000:c1:00.0 action fw_activate limit no_reset

Fixes: 3c4153394e2c ("bnxt_en: implement firmware live patching")
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |   39 +++++++++++++++++-----
 1 file changed, 31 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -366,6 +366,16 @@ bnxt_dl_livepatch_report_err(struct bnxt
 	}
 }
 
+/* Live patch status in NVM */
+#define BNXT_LIVEPATCH_NOT_INSTALLED	0
+#define BNXT_LIVEPATCH_INSTALLED	FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_INSTALL
+#define BNXT_LIVEPATCH_REMOVED		FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_ACTIVE
+#define BNXT_LIVEPATCH_MASK		(FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_INSTALL | \
+					 FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_ACTIVE)
+#define BNXT_LIVEPATCH_ACTIVATED	BNXT_LIVEPATCH_MASK
+
+#define BNXT_LIVEPATCH_STATE(flags)	((flags) & BNXT_LIVEPATCH_MASK)
+
 static int
 bnxt_dl_livepatch_activate(struct bnxt *bp, struct netlink_ext_ack *extack)
 {
@@ -373,8 +383,9 @@ bnxt_dl_livepatch_activate(struct bnxt *
 	struct hwrm_fw_livepatch_query_input *query_req;
 	struct hwrm_fw_livepatch_output *patch_resp;
 	struct hwrm_fw_livepatch_input *patch_req;
+	u16 flags, live_patch_state;
+	bool activated = false;
 	u32 installed = 0;
-	u16 flags;
 	u8 target;
 	int rc;
 
@@ -393,7 +404,6 @@ bnxt_dl_livepatch_activate(struct bnxt *
 		hwrm_req_drop(bp, query_req);
 		return rc;
 	}
-	patch_req->opcode = FW_LIVEPATCH_REQ_OPCODE_ACTIVATE;
 	patch_req->loadtype = FW_LIVEPATCH_REQ_LOADTYPE_NVM_INSTALL;
 	patch_resp = hwrm_req_hold(bp, patch_req);
 
@@ -406,12 +416,20 @@ bnxt_dl_livepatch_activate(struct bnxt *
 		}
 
 		flags = le16_to_cpu(query_resp->status_flags);
-		if (~flags & FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_INSTALL)
+		live_patch_state = BNXT_LIVEPATCH_STATE(flags);
+
+		if (live_patch_state == BNXT_LIVEPATCH_NOT_INSTALLED)
 			continue;
-		if ((flags & FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_ACTIVE) &&
-		    !strncmp(query_resp->active_ver, query_resp->install_ver,
-			     sizeof(query_resp->active_ver)))
+
+		if (live_patch_state == BNXT_LIVEPATCH_ACTIVATED) {
+			activated = true;
 			continue;
+		}
+
+		if (live_patch_state == BNXT_LIVEPATCH_INSTALLED)
+			patch_req->opcode = FW_LIVEPATCH_REQ_OPCODE_ACTIVATE;
+		else if (live_patch_state == BNXT_LIVEPATCH_REMOVED)
+			patch_req->opcode = FW_LIVEPATCH_REQ_OPCODE_DEACTIVATE;
 
 		patch_req->fw_target = target;
 		rc = hwrm_req_send(bp, patch_req);
@@ -423,8 +441,13 @@ bnxt_dl_livepatch_activate(struct bnxt *
 	}
 
 	if (!rc && !installed) {
-		NL_SET_ERR_MSG_MOD(extack, "No live patches found");
-		rc = -ENOENT;
+		if (activated) {
+			NL_SET_ERR_MSG_MOD(extack, "Live patch already activated");
+			rc = -EEXIST;
+		} else {
+			NL_SET_ERR_MSG_MOD(extack, "No live patches found");
+			rc = -ENOENT;
+		}
 	}
 	hwrm_req_drop(bp, query_req);
 	hwrm_req_drop(bp, patch_req);


