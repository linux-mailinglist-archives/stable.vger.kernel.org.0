Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9745E594FD3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiHPEd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiHPEcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:32:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA06E18B07;
        Mon, 15 Aug 2022 13:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66DDD61072;
        Mon, 15 Aug 2022 20:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E0DC433D6;
        Mon, 15 Aug 2022 20:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594984;
        bh=fFljOQNloyO/qfGLcVLELB2aDek7yeS4/gMF84dZj8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cj2fDLlB+1u69nzfP7aXu3Vsyvx2i5OpoJulB/u6jp1g+uI9ZVuje8ChYlUTxtkAP
         +IBCad7C0jN232W9o8/Ia+YVyWz6Q5qkvTZTakm5NErEFeRRYszVCA0OVxX3q5WeIk
         knJ18O4vrte+OhzojC0P1lWijtBOyPlnNTnARxvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0589/1157] scsi: qla2xxx: edif: Fix n2n login retry for secure device
Date:   Mon, 15 Aug 2022 19:59:05 +0200
Message-Id: <20220815180503.226669190@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 5f077f9217e5..177ce45b76a6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2123,6 +2123,13 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
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



