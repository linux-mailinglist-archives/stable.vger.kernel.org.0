Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3B9406BA4
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhIJMdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233386AbhIJMdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:33:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0365604DA;
        Fri, 10 Sep 2021 12:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277110;
        bh=MSXnt5XTo1TGkVvT62NINUnBxSUU1KpUMG3VpSJNFkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6jNavv4xyLfdclSoPkrbfg6FaaF/SNDNfcksZbIJ2HO+xdahZhtvt/5sR1EXYmJ+
         tQov9HimQMnR6gBNL5eb40nyc3RtblLK4X9lRpHO4EFrfefPgMh5nq5IhPRVn8XOsu
         LDXVmBDAVR8gIVTKGZ8xQDFWgXYrdvaBpiPjx96Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Lu <stan.lu@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.14 09/23] usb: xhci-mtk: fix issue of out-of-bounds array access
Date:   Fri, 10 Sep 2021 14:29:59 +0200
Message-Id: <20210910122916.313150654@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -575,10 +575,12 @@ static u32 get_esit_boundary(struct mu3h
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
 


