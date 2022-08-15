Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01EF5940F2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348071AbiHOV3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348548AbiHOV1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:27:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AB6ED00C;
        Mon, 15 Aug 2022 12:23:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 681B960693;
        Mon, 15 Aug 2022 19:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508BAC433D6;
        Mon, 15 Aug 2022 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591429;
        bh=BXbrf2VsO7sCBorUn5KdpawL5FlbDVwfKdOkkWueWDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsW2e1laMga6zo0+sLtQpmgwQTUHEbxN47QZf5/02/6iQJndfTx8Gur9nT5krmXCB
         5BaT7OxjoFm+jC/Je0ZKlTemmagT2uyh7Bi/x7O7Bcwvy8qWmSH9GBbgcbMtP8NVks
         Ss3iqzqobe2cS+IhoNTOuqxOoJqk1rYIqjqWUQec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0575/1095] scsi: qla2xxx: edif: Reduce disruption due to multiple app start
Date:   Mon, 15 Aug 2022 19:59:34 +0200
Message-Id: <20220815180453.352026999@linuxfoundation.org>
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
index 0ead3d95f594..208a16cb54f0 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -510,8 +510,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		/* mark doorbell as active since an app is now present */
 		vha->e_dbell.db_flags |= EDB_ACTIVE;
 	} else {
-		ql_dbg(ql_dbg_edif, vha, 0x911e, "%s doorbell already active\n",
-		     __func__);
+		goto out;
 	}
 
 	if (N2N_TOPO(vha->hw)) {
@@ -578,6 +577,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		     __func__);
 	}
 
+out:
 	appreply.host_support_edif = vha->hw->flags.edif_enabled;
 	appreply.edif_enode_active = vha->pur_cinfo.enode_flags;
 	appreply.edif_edb_active = vha->e_dbell.db_flags;
-- 
2.35.1



