Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA194603D14
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiJSI5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiJSI41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:56:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BA99B847;
        Wed, 19 Oct 2022 01:52:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC2D06186E;
        Wed, 19 Oct 2022 08:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9C7C433D6;
        Wed, 19 Oct 2022 08:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169485;
        bh=deb/+f+bTm4Ytyvf8OL7N3yZQGGpLOBi7QxH7ZECr8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTyS4P3y11/NrwdV3qBGEw0NotbUZiTb8vaNbWBsWrWxXOVEreptwilF5ZVan1no4
         3CK0pOgZBAONhpTXK+hH/YKYCqWkzJYpxaWgy0ReTxsq5A3IY135JmmTNpxdG0gDhP
         8qFPd52nxrqGtHoqBU2ql78pHsmVU5U+Mdd3ERcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 294/862] net: fs_enet: Fix wrong check in do_pd_setup
Date:   Wed, 19 Oct 2022 10:26:21 +0200
Message-Id: <20221019083303.002949848@linuxfoundation.org>
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

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit ec3f06b542a960806a81345042e4eee3f8c5dec4 ]

Should check of_iomap return value 'fep->fec.fecp' instead of 'fep->fcc.fccp'

Fixes: 976de6a8c304 ("fs_enet: Be an of_platform device when CONFIG_PPC_CPM_NEW_BINDING is set.")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
index 99fe2c210d0f..61f4b6e50d29 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
@@ -98,7 +98,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 		return -EINVAL;
 
 	fep->fec.fecp = of_iomap(ofdev->dev.of_node, 0);
-	if (!fep->fcc.fccp)
+	if (!fep->fec.fecp)
 		return -EINVAL;
 
 	return 0;
-- 
2.35.1



