Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B235A49C0
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiH2L3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiH2L2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:28:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4706A2719;
        Mon, 29 Aug 2022 04:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03E7D611B3;
        Mon, 29 Aug 2022 11:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEC5C433C1;
        Mon, 29 Aug 2022 11:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771692;
        bh=8wcWicOBd5LoPg57jDudrOyj8i8B9hcXWR7IZJ9W3BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sv0V9cLBHJTJBfvVHOZK9QN39JZpBcPjCQdotA5gMan1hO+FLTZdonL675xgefiCp
         mctkt1DfjCxjlHGUzUVeFhtVoOzhpXX02dCUtnrLm/zo7QyMTS+bdsS4hBGAQDVMmR
         4XHI8izKdQz1332dLInAkSRHHBlNvQHEntrt/Y7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 84/86] scsi: ufs: core: Enable link lost interrupt
Date:   Mon, 29 Aug 2022 12:59:50 +0200
Message-Id: <20220829105759.963958548@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

From: Kiwoong Kim <kwmad.kim@samsung.com>

commit 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269 upstream.

Link lost is treated as fatal error with commit c99b9b230149 ("scsi: ufs:
Treat link loss as fatal error"), but the event isn't registered as
interrupt source. Enable it.

Link: https://lore.kernel.org/r/1659404551-160958-1-git-send-email-kwmad.kim@samsung.com
Fixes: c99b9b230149 ("scsi: ufs: Treat link loss as fatal error")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshci.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -129,11 +129,7 @@ enum {
 
 #define UFSHCD_UIC_MASK		(UIC_COMMAND_COMPL | UFSHCD_UIC_PWR_MASK)
 
-#define UFSHCD_ERROR_MASK	(UIC_ERROR |\
-				DEVICE_FATAL_ERROR |\
-				CONTROLLER_FATAL_ERROR |\
-				SYSTEM_BUS_FATAL_ERROR |\
-				CRYPTO_ENGINE_FATAL_ERROR)
+#define UFSHCD_ERROR_MASK	(UIC_ERROR | INT_FATAL_ERRORS)
 
 #define INT_FATAL_ERRORS	(DEVICE_FATAL_ERROR |\
 				CONTROLLER_FATAL_ERROR |\


