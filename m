Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6324B4948
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiBNKWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:22:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347635AbiBNKVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:21:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9627DE14;
        Mon, 14 Feb 2022 01:55:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D766160F25;
        Mon, 14 Feb 2022 09:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C59C340E9;
        Mon, 14 Feb 2022 09:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832548;
        bh=cfXOxnZgcPdfoYQeHM0c0yyXmHPUq5UCgsWsGd9TXlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zre4T3VLD53RdA8dVh1rOC6B9bolWTIyL/vwKp73MiXzaBblYwsFpprvuq3j0GapC
         IMR8AL7eZt2+i15Qd2FEesPsB8z3DxZoIIa0FBuyIOI/hLqLTF0RB8QIAjjzQ+lD/g
         tmAflhqK3ozt+SF+tSgY0Yu2t7Zy8cibxvwWvDBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 050/203] scsi: ufs: Treat link loss as fatal error
Date:   Mon, 14 Feb 2022 10:24:54 +0100
Message-Id: <20220214092511.919563337@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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
index 6a295c88d850f..a7ff0e5b54946 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -142,7 +142,8 @@ static inline u32 ufshci_version(u32 major, u32 minor)
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



