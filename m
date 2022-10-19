Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CD0603D06
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiJSI4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiJSIzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:55:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D17C9AFB3;
        Wed, 19 Oct 2022 01:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9040C6181D;
        Wed, 19 Oct 2022 08:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4324C433D6;
        Wed, 19 Oct 2022 08:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169448;
        bh=8V/2WBaxDidT9ubYw7k2req5w3xsG1WRMgg2TbhCdpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f86j4q0izFUzIqYktpMc9gBd4kRY72gnov2TxABdZBSfwuNC75SLBKhFI/ZhpMwY4
         SjkE0BpQedmLiaw5EeamVKbTiZh13O7QLyAOh28XWHWNEPwGcaoa5HjU0EJM0VtueA
         mC0g1vCC/ECkL4yns9wI7i/0anDg0EDS/oS8xoT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 281/862] wifi: mt76: mt7921: fix use after free in mt7921_acpi_read()
Date:   Wed, 19 Oct 2022 10:26:08 +0200
Message-Id: <20221019083302.440733021@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e7de4b4979bd8d313ec837931dde936653ca82ea ]

Don't dereference "sar_root" after it has been freed.

Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
index be4f07ad3af9..47e034a9b003 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
@@ -13,6 +13,7 @@ mt7921_acpi_read(struct mt7921_dev *dev, u8 *method, u8 **tbl, u32 *len)
 	acpi_handle root, handle;
 	acpi_status status;
 	u32 i = 0;
+	int ret;
 
 	root = ACPI_HANDLE(mdev->dev);
 	if (!root)
@@ -52,9 +53,11 @@ mt7921_acpi_read(struct mt7921_dev *dev, u8 *method, u8 **tbl, u32 *len)
 		*(*tbl + i) = (u8)sar_unit->integer.value;
 	}
 free:
+	ret = (i == sar_root->package.count) ? 0 : -EINVAL;
+
 	kfree(sar_root);
 
-	return (i == sar_root->package.count) ? 0 : -EINVAL;
+	return ret;
 }
 
 /* MTCL : Country List Table for 6G band */
-- 
2.35.1



