Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D2D694947
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjBMO6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjBMO6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E88A1CF53
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40B8661158
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D11C433D2;
        Mon, 13 Feb 2023 14:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300235;
        bh=JIu7zxAwS854SWrFOG1FGxIAQmIy/tyUzOdOHQFY4Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hF00DZgJ64ti/Uo85epdI9GiWDT0XdsZSsV3OANn+mF3YtgmfNpdemLsS4ZD5h4l3
         8q6hFBJEOntpn4jjBh4FR9jYL9IBneJCmXayT04C+v3dkl6+6DI2v0lbPqECOgwqes
         eV+ld6+mQwJL0hiU8uc4I8aZT5J0ymmkHAbvBxxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/67] nvmem: core: add error handling for dev_set_name
Date:   Mon, 13 Feb 2023 15:48:42 +0100
Message-Id: <20230213144732.405052845@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 5544e90c81261e82e02bbf7c6015a4b9c8c825ef ]

The type of return value of dev_set_name is int, which may return
wrong result, so we add error handling for it to reclaim memory
of nvmem resource, and return early when an error occurs.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220916122100.170016-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ab3428cfd9aa ("nvmem: core: fix registration vs use race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index ee86022c4f2b8..51bec9f8a3bf9 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -804,18 +804,24 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	switch (config->id) {
 	case NVMEM_DEVID_NONE:
-		dev_set_name(&nvmem->dev, "%s", config->name);
+		rval = dev_set_name(&nvmem->dev, "%s", config->name);
 		break;
 	case NVMEM_DEVID_AUTO:
-		dev_set_name(&nvmem->dev, "%s%d", config->name, nvmem->id);
+		rval = dev_set_name(&nvmem->dev, "%s%d", config->name, nvmem->id);
 		break;
 	default:
-		dev_set_name(&nvmem->dev, "%s%d",
+		rval = dev_set_name(&nvmem->dev, "%s%d",
 			     config->name ? : "nvmem",
 			     config->name ? config->id : nvmem->id);
 		break;
 	}
 
+	if (rval) {
+		ida_free(&nvmem_ida, nvmem->id);
+		kfree(nvmem);
+		return ERR_PTR(rval);
+	}
+
 	nvmem->read_only = device_property_present(config->dev, "read-only") ||
 			   config->read_only || !nvmem->reg_write;
 
-- 
2.39.0



