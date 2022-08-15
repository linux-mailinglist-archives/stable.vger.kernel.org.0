Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE446593EDF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344317AbiHOV2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347665AbiHOV0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:26:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9277CE8320;
        Mon, 15 Aug 2022 12:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6AF960FDA;
        Mon, 15 Aug 2022 19:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE19DC433D6;
        Mon, 15 Aug 2022 19:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591359;
        bh=EpI4s0rZZlvhdv4EB9lnUgtUdH7otxTdlujJi/PPPfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNIRlgljrtXuk2X9mxXe8jlm18rzuT1SEjhhoncdeeDUSXBIf3QI2GYfNsKBkXcGC
         X/SbgogDcE3aoouFbF4Ec+qIzSGi2HCF73I1/QGfemaZ3rq2MdiapZ6pSEKtIsXZWw
         eoWHcGm6pOtuydO9GaTwywymgb0ODnyiAV55zTnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0554/1095] scsi: qla2xxx: edif: Fix n2n discovery issue with secure target
Date:   Mon, 15 Aug 2022 19:59:13 +0200
Message-Id: <20220815180452.472169540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 789d54a4178634850e441f60c0326124138e7269 ]

User failed to see disk via n2n topology. Driver used up all login retries
before authentication application started. When authentication application
started, driver did not have enough login retries to connect securely. On
app_start, driver will reset the login retry attempt count.

Link: https://lore.kernel.org/r/20220607044627.19563-10-njavali@marvell.com
Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ce893ddb13df..c17e177864d3 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -515,6 +515,9 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	}
 
 	if (N2N_TOPO(vha->hw)) {
+		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list)
+			fcport->n2n_link_reset_cnt = 0;
+
 		if (vha->hw->flags.n2n_fw_acc_sec)
 			set_bit(N2N_LINK_RESET, &vha->dpc_flags);
 		else
-- 
2.35.1



