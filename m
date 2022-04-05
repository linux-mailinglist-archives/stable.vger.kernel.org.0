Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503C14F39A2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353632AbiDELgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353386AbiDEKGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:06:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6A9BF941;
        Tue,  5 Apr 2022 02:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56EA661676;
        Tue,  5 Apr 2022 09:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AFEC385A1;
        Tue,  5 Apr 2022 09:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152492;
        bh=Hbt95SH/5danOUkYPJ2tMkvAvH7esF7UJsI40QKGT9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpBURdvRebkxxRDlLKVRQDONPY7K7VGa4/RT1bUqfqfjISMSeRalxKQ9fffbVNLBK
         vh0A/GL4e+4D9FwU3uj8+1GLGPt2pmHZk2W5mMp29l/4Qs1C+yptfIGu3w84UlkvF3
         duqwZKTFsV2dB5X1FzhPyW0zv3OLD/2RHMdtUK3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joe Carnuccio <joe.carnuccio@cavium.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 5.15 797/913] scsi: qla2xxx: Fix T10 PI tag escape and IP guard options for 28XX adapters
Date:   Tue,  5 Apr 2022 09:30:59 +0200
Message-Id: <20220405070403.722507008@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

commit 4c103a802c69fca63976af6b372ccba39ed74370 upstream.

28XX adapters are capable of detecting both T10 PI tag escape values as
well as IP guard. This was missed due to the adapter type missed in the
corresponding macros. Fix this by adding support for 28xx in those macros.

Link: https://lore.kernel.org/r/20220110050218.3958-14-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4270,8 +4270,10 @@ struct qla_hw_data {
 #define QLA_ABTS_WAIT_ENABLED(_sp) \
 	(QLA_NVME_IOS(_sp) && QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
 
-#define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
-#define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
+#define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
+					 IS_QLA28XX(ha))
+#define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
+					 IS_QLA28XX(ha))
 #define IS_PI_DIFB_DIX0_CAPABLE(ha)	(0)
 #define IS_PI_SPLIT_DET_CAPABLE_HBA(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
 					IS_QLA28XX(ha))


