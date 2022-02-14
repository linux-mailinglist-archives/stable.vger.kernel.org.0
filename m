Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F370F4B47EF
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244885AbiBNJsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:48:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343747AbiBNJq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA816B0A0;
        Mon, 14 Feb 2022 01:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4859DB80DC6;
        Mon, 14 Feb 2022 09:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81185C340E9;
        Mon, 14 Feb 2022 09:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831592;
        bh=Oj7NXyw/WsaA4MVF4fR5lEQedQrm6KIDPdBManiDg4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsAQwlaGbAP2n4NhOsv0uTcblJzM0uw4WCW5Z86i3gjTFozvFgl32AZbQHJGKZtcG
         QUtNp990jTMwv6cTGsCy8UOnu7Mq/g6SWl4Qm7hnKP2dTiGhDExS3tQc9gt1UNjr0F
         lesAy8DPPKc3+MXccWpX2qJvzbISSkw6ba1CDsf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/116] scsi: ufs: Treat link loss as fatal error
Date:   Mon, 14 Feb 2022 10:25:29 +0100
Message-Id: <20220214092459.730608870@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiwoong Kim <kwmad.kim@samsung.com>

[ Upstream commit c99b9b2301492b665b6e51ba6c06ec362eddcd10 ]

This event is raised when link is lost as specified in UFSHCI spec and that
means communication is not possible. Thus initializing UFS interface needs
to be done.

Make UFS driver considers Link Lost as fatal in the INT_FATAL_ERRORS
mask. This will trigger a host reset whenever a link lost interrupt occurs.

Link: https://lore.kernel.org/r/1642743475-54275-1-git-send-email-kwmad.kim@samsung.com
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshci.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 6795e1f0e8f8c..1d999228efc85 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -138,7 +138,8 @@ enum {
 #define INT_FATAL_ERRORS	(DEVICE_FATAL_ERROR |\
 				CONTROLLER_FATAL_ERROR |\
 				SYSTEM_BUS_FATAL_ERROR |\
-				CRYPTO_ENGINE_FATAL_ERROR)
+				CRYPTO_ENGINE_FATAL_ERROR |\
+				UIC_LINK_LOST)
 
 /* HCS - Host Controller Status 30h */
 #define DEVICE_PRESENT				0x1
-- 
2.34.1



