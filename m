Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B09163E04B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiK3Szh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiK3Szf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680B099F1F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 024B561D41
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F228C433D6;
        Wed, 30 Nov 2022 18:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834533;
        bh=bRLZHKh2zNHAUYhN/K+kEkdojDudkiQXqx8uEY36ZG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzrXY6HMVZeZKcSlvxe6CiH4VF9Sw1LeJjY8euAXf8B12+qnEUjUubwEaFMrZg6AF
         n1eLeekUEdx6euXe5PTXuYHxY4wIrPs+KzfNT19ljwt7kzinBdT8Jo+SMNhXry9r+0
         ZltzF/1gh1xhoR7fWi6HhCz5lw5tU9rRknrxb90E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 261/289] scsi: mpi3mr: Suppress command reply debug prints
Date:   Wed, 30 Nov 2022 19:24:06 +0100
Message-Id: <20221130180550.018070844@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 7d21fcfb409500dc9b114567f0ef8d30b3190dee ]

After it receives command reply, mpi3mr driver checks command result. If
the result is not zero, it prints out command information. This debug
information is confusing since they are printed even when the non-zero
result is expected. "Power-on or device reset occurred" is printed for Test
Unit Ready command at drive detection. Inquiry failure for unsupported VPD
page header is also printed. They are harmless but look like failures.

To avoid the confusion, print the command reply debug information only when
the module parameter logging_level has value MPI3_DEBUG_SCSI_ERROR= 64, in
same manner as mpt3sas driver.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20221111014449.1649968-1-shinichiro.kawasaki@wdc.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index bfa1165e23b6..1b4d1e562de8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2930,7 +2930,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (scmd->result != (DID_OK << 16) && (scmd->cmnd[0] != ATA_12) &&
-	    (scmd->cmnd[0] != ATA_16)) {
+	    (scmd->cmnd[0] != ATA_16) &&
+	    mrioc->logging_level & MPI3_DEBUG_SCSI_ERROR) {
 		ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
 		    scmd->result);
 		scsi_print_command(scmd);
-- 
2.35.1



