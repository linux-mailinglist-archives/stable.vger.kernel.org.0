Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA53593F2A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiHOU4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346763AbiHOUzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:55:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4623B96B;
        Mon, 15 Aug 2022 12:11:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EFC66069E;
        Mon, 15 Aug 2022 19:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607BBC433D6;
        Mon, 15 Aug 2022 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590678;
        bh=7R7XRJk9VX5l9JuQ7DA+8HY+77GdZP4j+qwtfoEEtrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmuvr6vYJa5iJo5+wL8n30+aJjMHr+gDSCyPsb/ujDhOH+mJRPf5E7AoPKGk3OWpr
         cBx/Q6z0c177qh8TVxNtLVK8AcZcRlzSHHb8qY5qDD1bfY8PMQhFLiZUQXa1UIgIMg
         M9E/n1yAS8SbWSYDx79isaaL1Zum5nrcjA6vhlLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0329/1095] i2c: mxs: Silence a clang warning
Date:   Mon, 15 Aug 2022 19:55:28 +0200
Message-Id: <20220815180443.399753755@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 3d43273d7d1e1a5374d531e901d3c537b4c97bbf ]

Change the of_device_get_match_data() cast to (uintptr_t)
to silence the following clang warning:

drivers/i2c/busses/i2c-mxs.c:802:18: warning: cast to smaller integer type 'enum mxs_i2c_devtype' from 'const void *' [-Wvoid-pointer-to-enum-cast]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c32abd8b5691 ("i2c: mxs: Remove unneeded platform_device_id")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mxs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 864a3f1bd4e1..68f67d084c63 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -799,7 +799,7 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	if (!i2c)
 		return -ENOMEM;
 
-	i2c->dev_type = (enum mxs_i2c_devtype)of_device_get_match_data(&pdev->dev);
+	i2c->dev_type = (uintptr_t)of_device_get_match_data(&pdev->dev);
 
 	i2c->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(i2c->regs))
-- 
2.35.1



