Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD494F2A1A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245432AbiDEIzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240354AbiDEIby (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8976FA21;
        Tue,  5 Apr 2022 01:24:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B9FC60FFB;
        Tue,  5 Apr 2022 08:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EF0C385A0;
        Tue,  5 Apr 2022 08:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147045;
        bh=gKjV3QLPv6TeU0BZhoxIGrkmjtEcGY8pEsjKlh+Y7xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMmmA1kbMLWccjQJkW4E2Ci/gZHkrt96z7JRKv77cbYrlQjIMY6muNThVnFj+Bofp
         mc4hiROlnChCbe8BcjeMhd7aDIQAVyw4FXjk1MW6RjnT5T73MO9vjXk9n2comORmMc
         Wnzv6I4Ny7sX7x7OFghtdzsJLyLBiRpwHPAk54EQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Carnuccio <joe.carnuccio@cavium.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.17 0982/1126] scsi: qla2xxx: Check for firmware dump already collected
Date:   Tue,  5 Apr 2022 09:28:49 +0200
Message-Id: <20220405070436.323124241@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Joe Carnuccio <joe.carnuccio@cavium.com>

commit cfbafad7c6032d449a5a07f2d273acd2437bbc6a upstream.

While allocating firmware dump, check if dump is already collected and do
not re-allocate the buffer.

Link: https://lore.kernel.org/r/20220110050218.3958-17-njavali@marvell.com
Cc: stable@vger.kernel.org
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3482,6 +3482,14 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *v
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 	struct qla2xxx_fw_dump *fw_dump;
 
+	if (ha->fw_dump) {
+		ql_dbg(ql_dbg_init, vha, 0x00bd,
+		    "Firmware dump already allocated.\n");
+		return;
+	}
+
+	ha->fw_dumped = 0;
+	ha->fw_dump_cap_flags = 0;
 	dump_size = fixed_size = mem_size = eft_size = fce_size = mq_size = 0;
 	req_q_size = rsp_q_size = 0;
 


