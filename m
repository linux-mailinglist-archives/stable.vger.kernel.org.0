Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0544F2B0E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238285AbiDEJzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343853AbiDEJOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:14:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09184C436;
        Tue,  5 Apr 2022 02:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BF9EB81A22;
        Tue,  5 Apr 2022 09:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB067C385A3;
        Tue,  5 Apr 2022 09:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149258;
        bh=suba1xzXWvaIbJzsfonGz0DLngK0q0zBAS7BYPJhF/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ohgeqwbv+GwVrCPgEMW44K+gwoPPqkkyG4pccR+x29l4y+ryXi0d8s2ibyI+m7+Cx
         YfvqSL5qJhDDlgC3PTWVPo0TcAT4SX5QG75ulx2aF+bQ5hAhDzgjJMHyCXjZh+ktK3
         9ZfFUA7GvfLeEcjk3GsPzgkzz+TH9YvqbuzW2gqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0651/1017] cpufreq: qcom-cpufreq-nvmem: fix reading of PVS Valid fuse
Date:   Tue,  5 Apr 2022 09:26:04 +0200
Message-Id: <20220405070413.607090574@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



