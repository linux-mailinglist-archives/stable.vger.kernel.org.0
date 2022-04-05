Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0834F3E26
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiDEMUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343763AbiDEKjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:39:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F26C5FC5;
        Tue,  5 Apr 2022 03:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02075B81B18;
        Tue,  5 Apr 2022 10:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C123C385A1;
        Tue,  5 Apr 2022 10:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154272;
        bh=Ew4sFXFJL9/Fob+RXWFLC70dMuNHv4n2jRil1FCn0DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFDKT16G0/Y7VMl9VYM7py5hphKz5Ur/drh/gqk3PBortRwo5ey8XiB5eIJwNamJl
         o8qZA131Av402/bnC/C7tDVn3yOVTpbLbJWiXyFTDrtxOEYGkvsnXWlw5T6Nb2PbcO
         HSuqzXaLV1EobQddGg4hjoWzhwJrisWxQ26c08eY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 519/599] scsi: qla2xxx: Fix wrong FDMI data for 64G adapter
Date:   Tue,  5 Apr 2022 09:33:33 +0200
Message-Id: <20220405070314.283919431@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
@@ -2796,7 +2796,11 @@ struct ct_fdmi2_hba_attributes {
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


