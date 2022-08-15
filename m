Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA130593650
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245270AbiHOTD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245707AbiHOTCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC8A3718D;
        Mon, 15 Aug 2022 11:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57AA260F7A;
        Mon, 15 Aug 2022 18:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600BDC433D6;
        Mon, 15 Aug 2022 18:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588429;
        bh=b1vhEVSzLT806KV0vZY9uvNMldcF7FVJvXU+LO0wV90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDP2R12R+TLQCdb7+TbwM6YgeVwZft9KyuxLI3Bgq3b3t4460Hwif9T/7lKD2magi
         H7u7X9q1FIkFbvMEcjEDSC0dp1vqBPY4yD1AbyeO8LX082bJ0kOyGG7HHUN0Fwc7ji
         M7hEn4C15YHRAePn2fEma8mFMNGQ9Tyq+Ld2/7iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 401/779] scsi: qla2xxx: edif: Fix n2n login retry for secure device
Date:   Mon, 15 Aug 2022 20:00:45 +0200
Message-Id: <20220815180354.412093581@linuxfoundation.org>
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

[ Upstream commit aec55325ddec975216119da000092cb8664a3399 ]

After initiator has burned up all login retries, target authentication
application begins to run. This triggers a link bounce on target side.
Initiator will attempt another login. Due to N2N, the PRLI [nvme | fcp] can
fail because of the mode mismatch with target. This patch add a few more
login retries to revive the connection.

Link: https://lore.kernel.org/r/20220607044627.19563-11-njavali@marvell.com
Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2bed5050bcaf..49cfe8c9f3bb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2125,6 +2125,13 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		}
 
 		if (N2N_TOPO(vha->hw)) {
+			if (ea->fcport->n2n_link_reset_cnt ==
+			    vha->hw->login_retry_count &&
+			    ea->fcport->flags & FCF_FCSP_DEVICE) {
+				/* remote authentication app just started */
+				ea->fcport->n2n_link_reset_cnt = 0;
+			}
+
 			if (ea->fcport->n2n_link_reset_cnt <
 			    vha->hw->login_retry_count) {
 				ea->fcport->n2n_link_reset_cnt++;
-- 
2.35.1



