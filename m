Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF544F31C7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353957AbiDEKJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346396AbiDEJXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:23:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2C0DA09A;
        Tue,  5 Apr 2022 02:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACAA1615E5;
        Tue,  5 Apr 2022 09:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFE0C385A2;
        Tue,  5 Apr 2022 09:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150003;
        bh=TEt6u2v2p7dI5no1Pgbez4k7Gzktp4YSlW5alzX4JkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOMgdS4Itj8oFFq2OfnLYMsHHdyA2CcW9sBIkHzheMLxMw2TouWoRHuAytFLW7Lmb
         P8L1cM823Vj8vHE2e9su1MYqTQumlweujd3kYh8CopqiCJg1Rtp/sESsDNY1tqvLvl
         dwCfNmIkCyIeD01S34yA6rf+yqJZ60s8l3NBxrZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0881/1017] scsi: qla2xxx: Fix wrong FDMI data for 64G adapter
Date:   Tue,  5 Apr 2022 09:29:54 +0200
Message-Id: <20220405070420.384917030@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Bikash Hazarika <bhazarika@marvell.com>

commit 1cfbbacbee2d6ea3816386a483e3c7a96e5bd657 upstream.

Corrected transmission speed mask values for FC.

Supported Speed: 16 32 20 Gb/s ===> Should be 64 instead of 20
Supported Speed: 16G 32G 48G   ===> Should be 64G instead of 48G

Link: https://lore.kernel.org/r/20220110050218.3958-9-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2891,7 +2891,11 @@ struct ct_fdmi2_hba_attributes {
 #define FDMI_PORT_SPEED_8GB		0x10
 #define FDMI_PORT_SPEED_16GB		0x20
 #define FDMI_PORT_SPEED_32GB		0x40
-#define FDMI_PORT_SPEED_64GB		0x80
+#define FDMI_PORT_SPEED_20GB		0x80
+#define FDMI_PORT_SPEED_40GB		0x100
+#define FDMI_PORT_SPEED_128GB		0x200
+#define FDMI_PORT_SPEED_64GB		0x400
+#define FDMI_PORT_SPEED_256GB		0x800
 #define FDMI_PORT_SPEED_UNKNOWN		0x8000
 
 #define FC_CLASS_2	0x04


