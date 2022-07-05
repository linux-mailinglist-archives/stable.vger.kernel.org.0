Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAFB566E33
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbiGEMcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiGEM0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9E919286;
        Tue,  5 Jul 2022 05:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46C5561AC8;
        Tue,  5 Jul 2022 12:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514FCC341C7;
        Tue,  5 Jul 2022 12:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023570;
        bh=xL9dQRPN4zdH0w5rxZ6Brj37J5MkQpsogia5Wn8fOkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bvEyUY3KHSzO920eMEJjYu8BqfzN9YLfzyPzUXZO25RaQudphuqgjmFOFvbHX6ji
         x4z/EC2KcAGIaVxQdMXRII6BSc6ilUODko7rVeqqUnK3whOhuitIxd3VSp+K2ra1/I
         1VcTHtY0052LCS/klQ5MP6v21C3uPNcchUuPgEHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 087/102] drivers: cpufreq: Add missing of_node_put() in qoriq-cpufreq.c
Date:   Tue,  5 Jul 2022 13:58:53 +0200
Message-Id: <20220705115620.882729590@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 4ff5a9b6d95f3524bf6d27147df497eb21968300 ]

In qoriq_cpufreq_probe(), of_find_matching_node() will return a
node pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Fixes: 157f527639da ("cpufreq: qoriq: convert to a platform driver")
[ Viresh: Fixed Author's name in commit log ]
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qoriq-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/qoriq-cpufreq.c b/drivers/cpufreq/qoriq-cpufreq.c
index 6b6b20da2bcf..573b417e1483 100644
--- a/drivers/cpufreq/qoriq-cpufreq.c
+++ b/drivers/cpufreq/qoriq-cpufreq.c
@@ -275,6 +275,7 @@ static int qoriq_cpufreq_probe(struct platform_device *pdev)
 
 	np = of_find_matching_node(NULL, qoriq_cpufreq_blacklist);
 	if (np) {
+		of_node_put(np);
 		dev_info(&pdev->dev, "Disabling due to erratum A-008083");
 		return -ENODEV;
 	}
-- 
2.35.1



