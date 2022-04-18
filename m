Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08EF5057FD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbiDRN7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244333AbiDRN44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:56:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EB62A73F;
        Mon, 18 Apr 2022 06:05:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26E02B80EC4;
        Mon, 18 Apr 2022 13:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7732BC385A7;
        Mon, 18 Apr 2022 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287141;
        bh=Uq4rzu+iYVCiYvKLAPyXV0+epEToMfF5Hp3/zPfFeMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHITx5H0skqUvgHMvvxcw5FOB2TGQVmCGKca41fN2He03VpfTkTcE0NcpBK4fjnjv
         l9Wl+XY1c43dUxfddQRFPN5LOJQTBQgvlx8fgdEDmJzj2yb7dW1J4XcKA3AZGBHBWT
         3iZ4KBmCrIxgw0N3HcJqEeSr/6WSZUqf72+T0u0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 068/218] memory: emif: check the pointer temp in get_device_details()
Date:   Mon, 18 Apr 2022 14:12:14 +0200
Message-Id: <20220418121201.557111104@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 5b5ab1bfa1898c6d52936a57c25c5ceba2cb2f87 ]

The pointer temp is allocated by devm_kzalloc(), so it should be
checked for error handling.

Fixes: 7ec944538dde ("memory: emif: add basic infrastructure for EMIF driver")
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20220225132552.27894-1-baijiaju1990@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index ed6c5fcb136f..9f293b931144 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1425,7 +1425,7 @@ static struct emif_data *__init_or_module get_device_details(
 	temp	= devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 	dev_info = devm_kzalloc(dev, sizeof(*dev_info), GFP_KERNEL);
 
-	if (!emif || !pd || !dev_info) {
+	if (!emif || !temp || !dev_info) {
 		dev_err(dev, "%s:%d: allocation error\n", __func__, __LINE__);
 		goto error;
 	}
-- 
2.34.1



