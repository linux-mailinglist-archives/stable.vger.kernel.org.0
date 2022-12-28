Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C958E657BE0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiL1P0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiL1P0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F6DBCE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81E2D61560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91404C433EF;
        Wed, 28 Dec 2022 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241177;
        bh=85iggO+a2CPYpne1AVL9xl5N9qzRpTm+0xReCj2RV4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3zYJkVJ3zkeM/6ImYpe0OCvM2y+0CoTRAWSEE4KJqtQwToCCN3yxRYGhFyKPdK5T
         +zSyviUue8665uvasymOZT4IBjxZAsrXJCew/pDq5M8CXRq40QDhfSS83oZvwHbaPo
         6xDo/0uM6ld8k3NMZRs8jfWAT4BaiIhudAzcT9fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/731] usb: typec: tipd: Cleanup resources if devm_tps6598_psy_register fails
Date:   Wed, 28 Dec 2022 15:39:16 +0100
Message-Id: <20221228144309.568846862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 19c220e9ab00f50edefb9667e3101e84a5112df2 ]

We can't just return if devm_tps6598_psy_register fails since previous
resources are not devres managed and have yet to be cleaned up.

Fixes: 10eb0b6ac63a ("usb: typec: tps6598x: Export some power supply properties")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221114174449.34634-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 23a8b9b0b1fe..dd35b3ee2c5a 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -684,7 +684,7 @@ static int tps6598x_probe(struct i2c_client *client)
 
 	ret = devm_tps6598_psy_register(tps);
 	if (ret)
-		return ret;
+		goto err_role_put;
 
 	tps->port = typec_register_port(&client->dev, &typec_cap);
 	if (IS_ERR(tps->port)) {
-- 
2.35.1



