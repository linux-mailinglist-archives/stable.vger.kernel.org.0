Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF6D50F622
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiDZIw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346485AbiDZIuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:50:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D413C672;
        Tue, 26 Apr 2022 01:38:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8CE1DCE1BB0;
        Tue, 26 Apr 2022 08:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E90C385A4;
        Tue, 26 Apr 2022 08:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962296;
        bh=dI4Xk1fyAX6wbNw/beUqTsvwcMn0SxWUnzr0b0qBVtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8z+LpG0R84XoZqZ3oS40X7zCauD4FgqV+W77YpTXe8pigLPCWbqZyeANrkFJPKOK
         YvAnYOS92KmcnEaKKD/kll20eF3IJfIKiWZeOwgaSvlKd0SWnPDDdWNZjVztQPTCSz
         xipH3KIJTP/IN5vZozGraKFbjOEFVZqyk8GZxvVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Zhu <tony.zhu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/124] dmaengine: idxd: skip clearing device context when device is read-only
Date:   Tue, 26 Apr 2022 10:20:51 +0200
Message-Id: <20220426081748.723423013@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 1cd8e751d96c43ece3f6842ac2244a37d9332c3a ]

If the device shows up as read-only configuration, skip the clearing of the
state as the context must be preserved for device re-enable after being
disabled.

Fixes: 0dcfe41e9a4c ("dmanegine: idxd: cleanup all device related bits after disabling device")
Reported-by: Tony Zhu <tony.zhu@intel.com>
Tested-by: Tony Zhu <tony.zhu@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/164971479479.2200566.13980022473526292759.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index a67bafc596b7..e622245c9380 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -730,6 +730,9 @@ static void idxd_device_wqs_clear_state(struct idxd_device *idxd)
 
 void idxd_device_clear_state(struct idxd_device *idxd)
 {
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return;
+
 	idxd_groups_clear_state(idxd);
 	idxd_engines_clear_state(idxd);
 	idxd_device_wqs_clear_state(idxd);
-- 
2.35.1



