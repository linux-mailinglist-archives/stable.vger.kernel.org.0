Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288AD69CDA9
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjBTNv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjBTNv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:51:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE25E1E2BB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AFB3B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D434CC433D2;
        Mon, 20 Feb 2023 13:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901085;
        bh=cPrTXOixXNlXzQjvmoHKk3/430NvEe6M0hbeedBPQPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZr9YrmZt9YaNR5cfxcMjzZ0WCZNaQSI5q/Y1zX+RCpupOuXZc6VGlgaimwbKmXNc
         DamtTdRdpPBc5GnLP5ef8SR7YrNoBhAT4YAhT2U1CNckPvYKDG2pBj1Y54tPW6kmM3
         QMtYvHgu8T4rHqfD6phSFxv3L2RtyEXRC13Tiykc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/83] nvmem: core: fix return value
Date:   Mon, 20 Feb 2023 14:35:56 +0100
Message-Id: <20230220133554.506411228@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 0c4862b1c1465e473bc961a02765490578bf5c20 ]

Dan Carpenter points out that the return code was not set in commit
60c8b4aebd8e ("nvmem: core: fix cleanup after dev_set_name()"), but
this is not the only issue - we also need to zero wp_gpio to prevent
gpiod_put() being called on an error value.

Fixes: 560181d3ace6 ("nvmem: core: fix cleanup after dev_set_name()")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-10-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 6a74e38746057..47c1487dcf8cc 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -779,6 +779,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
 		rval = PTR_ERR(nvmem->wp_gpio);
+		nvmem->wp_gpio = NULL;
 		goto err_put_device;
 	}
 
-- 
2.39.0



