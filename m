Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBD95944A6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbiHOWTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350040AbiHOWRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:17:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73303FA35;
        Mon, 15 Aug 2022 12:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1A62611F6;
        Mon, 15 Aug 2022 19:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDE4C433D6;
        Mon, 15 Aug 2022 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592429;
        bh=0rSuf08xxpAs4juZrf9DdyilhYifmFUsrkyHzwVov84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7hDHTbfErnEOTcMeRb+qLK6UgQR10OORmiB6UM3yZs1bRjq4nDphHUsKuk7cj31k
         VPf3J/2xMQU1ogCWfpLZEshZwJbeF/rlmPxkBAj9qYHnDV/kLdUJQY4r4PmJ0AZgO4
         JlpG/8CcGVdec570Cf2ICWVKbi40PytOhdPMlZKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Robert Richter <rric@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0785/1095] mmc: cavium-octeon: Add of_node_put() when breaking out of loop
Date:   Mon, 15 Aug 2022 20:03:04 +0200
Message-Id: <20220815180501.735590717@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 19bbb49acf8d7a03cb83e05624363741a4c3ec6f ]

In octeon_mmc_probe(), we should call of_node_put() when breaking
out of for_each_child_of_node() which has increased and decreased
the refcount during each iteration.

Fixes: 01d95843335c ("mmc: cavium: Add MMC support for Octeon SOCs.")
Signed-off-by: Liang He <windhl@126.com>
Acked-by: Robert Richter <rric@kernel.org>
Link: https://lore.kernel.org/r/20220719095216.1241601-1-windhl@126.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/cavium-octeon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/cavium-octeon.c b/drivers/mmc/host/cavium-octeon.c
index 2c4b2df52adb..12dca91a8ef6 100644
--- a/drivers/mmc/host/cavium-octeon.c
+++ b/drivers/mmc/host/cavium-octeon.c
@@ -277,6 +277,7 @@ static int octeon_mmc_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(&pdev->dev, "Error populating slots\n");
 			octeon_mmc_set_shared_power(host, 0);
+			of_node_put(cn);
 			goto error;
 		}
 		i++;
-- 
2.35.1



