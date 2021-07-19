Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00D83CD8DA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243521AbhGSOZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243536AbhGSOYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA17D61241;
        Mon, 19 Jul 2021 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707029;
        bh=a7ElmD7wZI9lOu+MZe4CT5jva9ULf70XZAAOLBNtVmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYLTQVTRLMiDaLjLsshsIMusfRO1LVwGu+eRcbMO3yK8tyEt16/1A27u77LDUOlvr
         3RESoFSL/bg21v3Etz9TCB6twSlDX9FjbaSpsRDKoFj5OyXvlunw3IpoT0oESKnc4O
         zQLWbGL6HnAW8lMUBOsPYIAO6Co8sVIegGbjQDmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 185/188] memory: fsl_ifc: fix leak of private memory on probe failure
Date:   Mon, 19 Jul 2021 16:52:49 +0200
Message-Id: <20210719144942.538876607@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 8e0d09b1232d0538066c40ed4c13086faccbdff6 ]

On probe error the driver should free the memory allocated for private
structure.  Fix this by using resource-managed allocation.

Fixes: a20cbdeffce2 ("powerpc/fsl: Add support for Integrated Flash Controller")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210527154322.81253-2-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/fsl_ifc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/fsl_ifc.c b/drivers/memory/fsl_ifc.c
index 040be4638140..65b984d64350 100644
--- a/drivers/memory/fsl_ifc.c
+++ b/drivers/memory/fsl_ifc.c
@@ -107,7 +107,6 @@ static int fsl_ifc_ctrl_remove(struct platform_device *dev)
 	iounmap(ctrl->regs);
 
 	dev_set_drvdata(&dev->dev, NULL);
-	kfree(ctrl);
 
 	return 0;
 }
@@ -218,7 +217,8 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 
 	dev_info(&dev->dev, "Freescale Integrated Flash Controller\n");
 
-	fsl_ifc_ctrl_dev = kzalloc(sizeof(*fsl_ifc_ctrl_dev), GFP_KERNEL);
+	fsl_ifc_ctrl_dev = devm_kzalloc(&dev->dev, sizeof(*fsl_ifc_ctrl_dev),
+					GFP_KERNEL);
 	if (!fsl_ifc_ctrl_dev)
 		return -ENOMEM;
 
-- 
2.30.2



