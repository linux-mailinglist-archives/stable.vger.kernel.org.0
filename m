Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E377C4F3836
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376431AbiDELV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349447AbiDEJtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D516527B07;
        Tue,  5 Apr 2022 02:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EC97B817D3;
        Tue,  5 Apr 2022 09:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D96C385A1;
        Tue,  5 Apr 2022 09:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151967;
        bh=G9FVdtdJd+SQe71GKHlVvftx16eoviFsChCzeAQD3Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EIEr5/nU/fRdMDJSq8ZdLhq7fcceVmjerhEFTTzjZj1HZ71Rg2h7hiQBUT1Qw4p5
         3Xiyqt8z8R8ORoO2o5tGdaeyrMlWgqHzUwWtLUuCg/f/C7u9icKHkCcMBwH+7yZfFH
         kXD4xFo9G5Up6jDnqNXvrfuNArcbynnFD99wLOto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 605/913] habanalabs: Add check for pci_enable_device
Date:   Tue,  5 Apr 2022 09:27:47 +0200
Message-Id: <20220405070357.976671039@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 9c27896ac1bb83ea5c461ce6f7089d02102a2b21 ]

As the potential failure of the pci_enable_device(),
it should be better to check the return value and return
error if fails.

Fixes: 70b2f993ea4a ("habanalabs: create common folder")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/common/debugfs.c b/drivers/misc/habanalabs/common/debugfs.c
index 985f1f3dbd20..0b46fd22c411 100644
--- a/drivers/misc/habanalabs/common/debugfs.c
+++ b/drivers/misc/habanalabs/common/debugfs.c
@@ -856,6 +856,8 @@ static ssize_t hl_set_power_state(struct file *f, const char __user *buf,
 		pci_set_power_state(hdev->pdev, PCI_D0);
 		pci_restore_state(hdev->pdev);
 		rc = pci_enable_device(hdev->pdev);
+		if (rc < 0)
+			return rc;
 	} else if (value == 2) {
 		pci_save_state(hdev->pdev);
 		pci_disable_device(hdev->pdev);
-- 
2.34.1



