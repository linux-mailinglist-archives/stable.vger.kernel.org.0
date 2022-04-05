Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B134F2DC9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350585AbiDEJ67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344110AbiDEJSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B5E37A38;
        Tue,  5 Apr 2022 02:04:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55791B81B75;
        Tue,  5 Apr 2022 09:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B128FC385A0;
        Tue,  5 Apr 2022 09:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149448;
        bh=wCS0KzKr4oLP5q/Kgg4TSGoEWXx2RJU1a3UmIAGtzOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLWkBkHRkM+s9P/VbqidAGoB6i1ZKF+StVZfOP5p3E3F/Yvw9aOUK6QXSfJaTSMh4
         fjvdPIDK28ESIfzNDOx+TJn4PFuYoRyPQbtxdea68hgz+hMceS2QAFCgCsFtw8mA/C
         jeJKIahB4Gde1PSk316XzKMkWYncSX3678wWoZn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0670/1017] habanalabs: Add check for pci_enable_device
Date:   Tue,  5 Apr 2022 09:26:23 +0200
Message-Id: <20220405070414.169016092@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 1f2a3dc6c4e2..78a6789ef7cc 100644
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



