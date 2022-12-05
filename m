Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3D26432A1
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiLET1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbiLET0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CA1B495
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:23:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46227612D8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAF4C433D6;
        Mon,  5 Dec 2022 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268227;
        bh=7byHlP5ufhy761TVqmwuLgFBxPP3Cgr0AZESwIy16cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJvLkVKZe34ExJWnZABX/LdThFGdRGgF6S4Bp/v5Kf9sfakxo3qdXu7wpUbGBOq08
         2wJj74Fouzj4MIZ8si8qQIFACwOkl3CiN4AA3DyWeM8W0JbOdwNYBl/vhRAKkXuT/y
         wAr3JOwXnmLZt3nswU8EqdqE6y9hOhACr2Nr/6iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 026/124] nvmem: rmem: Fix return value check in rmem_read()
Date:   Mon,  5 Dec 2022 20:08:52 +0100
Message-Id: <20221205190809.194305629@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 58e92c4a496b27156020a59a98c7f4a92c2b1533 ]

In case of error, the function memremap() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Fixes: 5a3fa75a4d9c ("nvmem: Add driver to expose reserved memory as nvmem")
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221118063840.6357-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/rmem.c b/drivers/nvmem/rmem.c
index b11c3c974b3d..80cb187f1481 100644
--- a/drivers/nvmem/rmem.c
+++ b/drivers/nvmem/rmem.c
@@ -37,9 +37,9 @@ static int rmem_read(void *context, unsigned int offset,
 	 * but as of Dec 2020 this isn't possible on arm64.
 	 */
 	addr = memremap(priv->mem->base, available, MEMREMAP_WB);
-	if (IS_ERR(addr)) {
+	if (!addr) {
 		dev_err(priv->dev, "Failed to remap memory region\n");
-		return PTR_ERR(addr);
+		return -ENOMEM;
 	}
 
 	count = memory_read_from_buffer(val, bytes, &off, addr, available);
-- 
2.35.1



