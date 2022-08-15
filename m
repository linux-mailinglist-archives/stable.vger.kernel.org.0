Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB4593993
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245010AbiHOTGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343508AbiHOTG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:06:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF364E86F;
        Mon, 15 Aug 2022 11:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F026B81072;
        Mon, 15 Aug 2022 18:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FE7C433D6;
        Mon, 15 Aug 2022 18:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588495;
        bh=TerHaN3ULsneVuFYUiA0zlYmlhU/YrtLSc3KhLzTd38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyhKuI/3mNcREr5HbdX5gzDoYZnQvl8KWkGPaGU2cF2OwkMpnXM063rCl9RtOdutG
         mL2n4TwogcekqfEpErYuhhLlSSZLqQ56M5C4ueyOjK4a9XaoU4cMG2cGqkUsiYONCC
         AqMRX261IS3q5ZBaPfP82gFGy7P1hHhr5ZVPP2e8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 420/779] scsi: qla2xxx: edif: Reduce disruption due to multiple app start
Date:   Mon, 15 Aug 2022 20:01:04 +0200
Message-Id: <20220815180355.218496980@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit 0dbfce5255fe8d069a1a3b712a25b263264cfa58 ]

Multiple app start can trigger a session bounce. Make driver skip over
session teardown if app start is seen more than once.

Link: https://lore.kernel.org/r/20220608115849.16693-4-njavali@marvell.com
Fixes: 7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 69f8d16effa6..f7953ce17678 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -486,8 +486,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		/* mark doorbell as active since an app is now present */
 		vha->e_dbell.db_flags |= EDB_ACTIVE;
 	} else {
-		ql_dbg(ql_dbg_edif, vha, 0x911e, "%s doorbell already active\n",
-		     __func__);
+		goto out;
 	}
 
 	if (N2N_TOPO(vha->hw)) {
@@ -555,6 +554,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		     __func__);
 	}
 
+out:
 	appreply.host_support_edif = vha->hw->flags.edif_enabled;
 	appreply.edif_enode_active = vha->pur_cinfo.enode_flags;
 	appreply.edif_edb_active = vha->e_dbell.db_flags;
-- 
2.35.1



