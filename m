Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F095EA2F2
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237586AbiIZLQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbiIZLQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:16:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F2A6524A;
        Mon, 26 Sep 2022 03:37:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C59A60A55;
        Mon, 26 Sep 2022 10:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32045C433C1;
        Mon, 26 Sep 2022 10:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188642;
        bh=d0NGvshIdLgsFhFa/UwAVgqQUXbygA154sf3xuY/DGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEHT+KCLuXGalUiUREMJxUjmcMr+9jGwkwaxoWuGgIo0OEwf/I+sM4iX4tbalXxS/
         xIrxMTlQ8E1Xh2F0Cggyx0KcWKJSfBWA4JACdyMJotw3miJmAyOYS1c+NDnlJWDXFA
         ZcLnx5Q8anWKKlA4a7hgG9S5UEe6QNvOIfpJArQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Rafael Mendonca <rafaelmendsr@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/148] scsi: qla2xxx: Fix memory leak in __qlt_24xx_handle_abts()
Date:   Mon, 26 Sep 2022 12:11:48 +0200
Message-Id: <20220926100758.808496532@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit 601be20fc6a1b762044d2398befffd6bf236cebf ]

Commit 8f394da36a36 ("scsi: qla2xxx: Drop TARGET_SCF_LOOKUP_LUN_FROM_TAG")
made the __qlt_24xx_handle_abts() function return early if
tcm_qla2xxx_find_cmd_by_tag() didn't find a command, but it missed to clean
up the allocated memory for the management command.

Link: https://lore.kernel.org/r/20220914024924.695604-1-rafaelmendsr@gmail.com
Fixes: 8f394da36a36 ("scsi: qla2xxx: Drop TARGET_SCF_LOOKUP_LUN_FROM_TAG")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b86f6e1f21b5..4b4ca2a9524d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2166,8 +2166,10 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 
 	abort_cmd = ha->tgt.tgt_ops->find_cmd_by_tag(sess,
 				le32_to_cpu(abts->exchange_addr_to_abort));
-	if (!abort_cmd)
+	if (!abort_cmd) {
+		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
 		return -EIO;
+	}
 	mcmd->unpacked_lun = abort_cmd->se_cmd.orig_fe_lun;
 
 	if (abort_cmd->qpair) {
-- 
2.35.1



