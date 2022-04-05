Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ED14F4670
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382844AbiDEMRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242583AbiDEKcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:32:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E44DEB88;
        Tue,  5 Apr 2022 03:18:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA1CDB81C8A;
        Tue,  5 Apr 2022 10:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A64C385A1;
        Tue,  5 Apr 2022 10:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153929;
        bh=P+lx99Lp7U69AbCKQde0RaOqyQCfBhi3OWQvFPWm/q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csJREqMCbQNbKD2VpNgv3N3wj6hNCW8SPTehc5gNbiQGCDkIlEhZ1CtecjE/VcbxK
         UJsNvZ/i2/CYRyyXnBlV2AVUsVXIv2wxPCml0YB+JJNiDP4MUnVTbzWtXw4kt99Otk
         LVVEvX8yR5Qbox8C1pciBjRQvBWX+zwwZS3xg3xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/599] habanalabs: Add check for pci_enable_device
Date:   Tue,  5 Apr 2022 09:31:31 +0200
Message-Id: <20220405070310.645218839@linuxfoundation.org>
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
index 912ddfa360b1..9716b0728b30 100644
--- a/drivers/misc/habanalabs/common/debugfs.c
+++ b/drivers/misc/habanalabs/common/debugfs.c
@@ -859,6 +859,8 @@ static ssize_t hl_set_power_state(struct file *f, const char __user *buf,
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



