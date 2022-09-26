Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9013B5EA102
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbiIZKpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236445AbiIZKnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:43:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A463B4B;
        Mon, 26 Sep 2022 03:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F037B80682;
        Mon, 26 Sep 2022 10:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4295DC433C1;
        Mon, 26 Sep 2022 10:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187894;
        bh=14LOge9ZT3P4ZiqBhc7nTzeEF/5VcYCWhsD0HB6YN1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/va6fZu7wJDI5oZMEJFc9H1dlnuyK3nLFxwrghBaoYKVPGbkQXgeeIjNt/AlAMOe
         vPV/3xY5mMuVLPdtnONnXizrZGr/cAzjGy6P6o4p6Hffhiy1VPrdcdfqVoe89M4Wy4
         VAYMZUwhMk6NrSBaADxmkyk/101LDtfh3RJoV4lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Lu <stan.lu@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.4 094/120] usb: xhci-mtk: fix issue of out-of-bounds array access
Date:   Mon, 26 Sep 2022 12:12:07 +0200
Message-Id: <20220926100754.444731153@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
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

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit de5107f473190538a65aac7edea85209cd5c1a8f upstream.

Bus bandwidth array access is based on esit, increase one
will cause out-of-bounds issue; for example, when esit is
XHCI_MTK_MAX_ESIT, will overstep boundary.

Fixes: 7c986fbc16ae ("usb: xhci-mtk: get the microframe boundary for ESIT")
Cc: <stable@vger.kernel.org>
Reported-by: Stan Lu <stan.lu@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1629189389-18779-5-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -539,10 +539,12 @@ static u32 get_esit_boundary(struct mu3h
 	u32 boundary = sch_ep->esit;
 
 	if (sch_ep->sch_tt) { /* LS/FS with TT */
-		/* tune for CS */
-		if (sch_ep->ep_type != ISOC_OUT_EP)
-			boundary++;
-		else if (boundary > 1) /* normally esit >= 8 for FS/LS */
+		/*
+		 * tune for CS, normally esit >= 8 for FS/LS,
+		 * not add one for other types to avoid access array
+		 * out of boundary
+		 */
+		if (sch_ep->ep_type == ISOC_OUT_EP && boundary > 1)
 			boundary--;
 	}
 


