Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB28D2267F8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733227AbgGTQQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388508AbgGTQQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:16:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D671E2176B;
        Mon, 20 Jul 2020 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261769;
        bh=yJdQ9x0NnxcJSbyMWotm4xSTdoYpqFfOHOchrswNJ7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdt+9FEhxqo9L6o73JIVjMKXd4/MB9fedHuOF8xzKqd5hlJLcGARcuA8ofkZgHIBU
         BJRZpWcSXCRgJuQPTL7IBseC/3OiXtu+AMAbIkzCDfuvqv83xe2WSmHUVMA0Hql0qm
         s25mpTfxe94WsUozxZhRPwc3Nkol3tbedSujEyIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Gong <yibin.gong@nxp.com>,
        Angelo Dureghello <angelo@sysam.it>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.7 208/244] dmaengine: fsl-edma-common: correct DSIZE_32BYTE
Date:   Mon, 20 Jul 2020 17:37:59 +0200
Message-Id: <20200720152835.743666337@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

commit e142087b15960a4e1e5932942e5abae1f49d2318 upstream.

Correct EDMA_TCD_ATTR_DSIZE_32BYTE define since it's broken by the below:
'0x0005 --> BIT(3) | BIT(0))'

Fixes: 4d6d3a90e4ac ("dmaengine: fsl-edma: fix macros")
Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Tested-by: Angelo Dureghello <angelo@sysam.it>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1593449998-32091-1-git-send-email-yibin.gong@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/fsl-edma-common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/fsl-edma-common.h
+++ b/drivers/dma/fsl-edma-common.h
@@ -33,7 +33,7 @@
 #define EDMA_TCD_ATTR_DSIZE_16BIT	BIT(0)
 #define EDMA_TCD_ATTR_DSIZE_32BIT	BIT(1)
 #define EDMA_TCD_ATTR_DSIZE_64BIT	(BIT(0) | BIT(1))
-#define EDMA_TCD_ATTR_DSIZE_32BYTE	(BIT(3) | BIT(0))
+#define EDMA_TCD_ATTR_DSIZE_32BYTE	(BIT(2) | BIT(0))
 #define EDMA_TCD_ATTR_SSIZE_8BIT	0
 #define EDMA_TCD_ATTR_SSIZE_16BIT	(EDMA_TCD_ATTR_DSIZE_16BIT << 8)
 #define EDMA_TCD_ATTR_SSIZE_32BIT	(EDMA_TCD_ATTR_DSIZE_32BIT << 8)


