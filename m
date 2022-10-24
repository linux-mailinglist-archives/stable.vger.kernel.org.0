Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D0160AC11
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiJXOC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbiJXOBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:01:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984BDBECC1;
        Mon, 24 Oct 2022 05:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8948A61325;
        Mon, 24 Oct 2022 12:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D91BC433C1;
        Mon, 24 Oct 2022 12:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615568;
        bh=1i8zogkR9T6NCoZU+5CHCQYY7T+Jg21kj+WmzzdA27o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zf9qic1hMXJn58boWXkiebvNZpnxqzgGqh3sRfCoE1u6XZd4E4G+XNSd3GyzM3Ljt
         okTxBZ/M+LaBK4rgtvvXJYNyPc50+iIddn9iCQalfXDCC4/h1OLduXYA+l1SPXgq1O
         IjF87lvNbyf4idv9FwG2gHf7SW9Isyvu4h+HvUHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Xu Yilun <yilun.xu@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/530] fpga: prevent integer overflow in dfl_feature_ioctl_set_irq()
Date:   Mon, 24 Oct 2022 13:30:37 +0200
Message-Id: <20221024113058.328763973@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 939bc5453b8cbdde9f1e5110ce8309aedb1b501a ]

The "hdr.count * sizeof(s32)" multiplication can overflow on 32 bit
systems leading to memory corruption.  Use array_size() to fix that.

Fixes: 322b598be4d9 ("fpga: dfl: introduce interrupt trigger setting API")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/YxBAtYCM38dM7yzI@kili
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/dfl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index f86666cf2c6a..c38143ef23c6 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -1864,7 +1864,7 @@ long dfl_feature_ioctl_set_irq(struct platform_device *pdev,
 		return -EINVAL;
 
 	fds = memdup_user((void __user *)(arg + sizeof(hdr)),
-			  hdr.count * sizeof(s32));
+			  array_size(hdr.count, sizeof(s32)));
 	if (IS_ERR(fds))
 		return PTR_ERR(fds);
 
-- 
2.35.1



