Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA14F6041AC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbiJSKrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiJSKpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:45:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6728A11D984;
        Wed, 19 Oct 2022 03:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 936CCB82454;
        Wed, 19 Oct 2022 09:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50F7C433D7;
        Wed, 19 Oct 2022 09:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170043;
        bh=qZLcI+C2kMZApJ2J7MvfP6RYfBi+1GyHo4kolVk2Mq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdPWLO8NskYBrV0Pw7vdMqoiUsDh8cIpRkrQjNOfdbGG3syKKPX85+1FkxHgrsbEZ
         zVry5oB3oVmO3Mv7iAzHaNbCyM6IdC7wznq/cAr7PND+W39cTxqwPSPN2QVlx8NTfl
         7b49AVfi31r7CFyaKyof2MLH5uMDUb7R/59uuWP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Xu Yilun <yilun.xu@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 505/862] fpga: prevent integer overflow in dfl_feature_ioctl_set_irq()
Date:   Wed, 19 Oct 2022 10:29:52 +0200
Message-Id: <20221019083312.305200120@linuxfoundation.org>
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
index 5498bc337f8b..b9aae85ba930 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -1866,7 +1866,7 @@ long dfl_feature_ioctl_set_irq(struct platform_device *pdev,
 		return -EINVAL;
 
 	fds = memdup_user((void __user *)(arg + sizeof(hdr)),
-			  hdr.count * sizeof(s32));
+			  array_size(hdr.count, sizeof(s32)));
 	if (IS_ERR(fds))
 		return PTR_ERR(fds);
 
-- 
2.35.1



