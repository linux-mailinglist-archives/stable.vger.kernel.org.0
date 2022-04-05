Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502594F312B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241604AbiDEIee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239458AbiDEIUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8572E972FF;
        Tue,  5 Apr 2022 01:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20C3A60B0B;
        Tue,  5 Apr 2022 08:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA16C385A0;
        Tue,  5 Apr 2022 08:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146421;
        bh=suba1xzXWvaIbJzsfonGz0DLngK0q0zBAS7BYPJhF/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d53G3+hzxr1cfzZfVZ9y1YSq4tOnpe7gVIM3yWub3H3njFUqo7BXNUF36YD/qvu84
         CQXDzmK4o/WupmqNMR7LvGDvDCagubHQxxffJOIHB0I6ptkkF0WnMz1yKNO5BYsUY6
         Oz1DArzpqhOdF/SLlJAwm5vT+qcISWE8T/+a93Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0720/1126] cpufreq: qcom-cpufreq-nvmem: fix reading of PVS Valid fuse
Date:   Tue,  5 Apr 2022 09:24:27 +0200
Message-Id: <20220405070428.726816359@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit 4a8a77abf0e2b6468ba0281e33384cbec5fb476a ]

The fuse consists of 64 bits, with this statement we're supposed to get
the upper 32 bits but it actually read out of bounds and got 0 instead
of the desired value which lead to the "PVS bin not set." codepath being
run resetting our pvs value.

Fixes: a8811ec764f9 ("cpufreq: qcom: Add support for krait based socs")
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-nvmem.c b/drivers/cpufreq/qcom-cpufreq-nvmem.c
index d1744b5d9619..6dfa86971a75 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -130,7 +130,7 @@ static void get_krait_bin_format_b(struct device *cpu_dev,
 	}
 
 	/* Check PVS_BLOW_STATUS */
-	pte_efuse = *(((u32 *)buf) + 4);
+	pte_efuse = *(((u32 *)buf) + 1);
 	pte_efuse &= BIT(21);
 	if (pte_efuse) {
 		dev_dbg(cpu_dev, "PVS bin: %d\n", *pvs);
-- 
2.34.1



