Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FD8566D47
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiGEMV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237160AbiGEMSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:18:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246A81A810;
        Tue,  5 Jul 2022 05:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A99EA61988;
        Tue,  5 Jul 2022 12:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73B7C341C7;
        Tue,  5 Jul 2022 12:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023242;
        bh=xL9dQRPN4zdH0w5rxZ6Brj37J5MkQpsogia5Wn8fOkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ae3CEmg7b/Y+og6Vd8l4K+QZFRtXMjvu92RJQOTUsy0LxUUwTpnft2nj/M8sonbTX
         nWj6yUlTpaMkG49ygEpXewJjPhfqAJo7TV91VVE+K3M6gsPDOn2JL/pLbuzILk+9Tc
         FSSGCgQMJgU4HEWWUodhQZgYIWYYULSsXTWeLwV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 89/98] drivers: cpufreq: Add missing of_node_put() in qoriq-cpufreq.c
Date:   Tue,  5 Jul 2022 13:58:47 +0200
Message-Id: <20220705115620.096287667@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
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



