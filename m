Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3809B501365
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348246AbiDNOCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344744AbiDNNwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:52:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541F33A5D1;
        Thu, 14 Apr 2022 06:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB9A61D7E;
        Thu, 14 Apr 2022 13:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452CDC385A5;
        Thu, 14 Apr 2022 13:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943878;
        bh=qyhaD39uXicANnbXgpb0hYkvUYQGwsqBszT6yjb4oaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S37l/i9VCXV/oU3WfLTisbnuAOqi6SAG/N6gEYX6U1QQ5yZGx2nehReps9MUHTJk+
         ex2EEKaugXytFArJemoEq77kqG+NJBTepf9URa9MRFMZvS6sqMlkdm01EIGgBQ1e/U
         66qy6VS0l6gEedrfb/ND2aRZV6bI+s/M0iAU92Bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 315/475] scsi: qla2xxx: Fix wrong FDMI data for 64G adapter
Date:   Thu, 14 Apr 2022 15:11:40 +0200
Message-Id: <20220414110903.903666629@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -2725,7 +2725,11 @@ struct ct_fdmiv2_hba_attributes {
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


