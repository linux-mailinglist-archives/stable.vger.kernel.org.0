Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D76657D8F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiL1Po2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiL1PoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6448017409
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:44:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0197761542
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19987C433D2;
        Wed, 28 Dec 2022 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242264;
        bh=4D5mQ6goGwcec4+foq5xSItBup7/X+41QmEMPozvQdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zBVVME7Hx9qSpnaerMLiFZ9hvXkmCH66DHmHYA4twpv1k/WCuXEmGoFC2g6o8FC2m
         aXLcozWs+AqDQcUIw7mlzzASBOQsJhT8sEaBTya+htEQ99Lur6KYSBbVg8Nyd59SQy
         s6LezpkZc+docpwsd94vE1eLFHNeBleZ04tQP+ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ZhangPeng <zhangpeng362@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0386/1073] pinctrl: pinconf-generic: add missing of_node_put()
Date:   Wed, 28 Dec 2022 15:32:54 +0100
Message-Id: <20221228144338.494326939@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: ZhangPeng <zhangpeng362@huawei.com>

[ Upstream commit 5ead93289815a075d43c415e35c8beafafb801c9 ]

of_node_put() needs to be called when jumping out of the loop, since
for_each_available_child_of_node() will increase the refcount of node.

Fixes: c7289500e29d ("pinctrl: pinconf-generic: scan also referenced phandle node")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Link: https://lore.kernel.org/r/20221125070156.3535855-1-zhangpeng362@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinconf-generic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 415d1df8f46a..365c4b0ca465 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -395,8 +395,10 @@ int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
 	for_each_available_child_of_node(np_config, np) {
 		ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
 					&reserved_maps, num_maps, type);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(np);
 			goto exit;
+		}
 	}
 	return 0;
 
-- 
2.35.1



