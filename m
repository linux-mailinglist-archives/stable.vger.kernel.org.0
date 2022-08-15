Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B6D5937FB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245311AbiHOTEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237723AbiHOTCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:02:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE0E357EB;
        Mon, 15 Aug 2022 11:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06411B8105D;
        Mon, 15 Aug 2022 18:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFB0C433D6;
        Mon, 15 Aug 2022 18:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588426;
        bh=tdcSelFG26Y1HtLRZkbyLpaO2q+Kbsv+mVSzTz4ioLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9etoUh/9Vvt9QLz7I+74KQcPHNSo3SU3/ITm9j0vx0olJzqHmKwCNDKllz0ht8nx
         WITG8TcsABWinQnr22YwZPaF43QHTPf478x66caxsLNwCb7JNSxbiyAyxrBEFnkona
         p5IwaGG7TQZJQJ3EeABcFy6fpAqxsTsI2rR3uXS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/779] scsi: qla2xxx: edif: Fix n2n discovery issue with secure target
Date:   Mon, 15 Aug 2022 20:00:44 +0200
Message-Id: <20220815180354.362622953@linuxfoundation.org>
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
index ee8e1ae2c300..8be282339fdd 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -491,6 +491,9 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
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



