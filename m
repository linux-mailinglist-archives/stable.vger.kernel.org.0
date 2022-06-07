Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BB0541B25
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380983AbiFGVmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381329AbiFGVk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9761318FF18;
        Tue,  7 Jun 2022 12:06:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFF5D61846;
        Tue,  7 Jun 2022 19:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E73C341D3;
        Tue,  7 Jun 2022 19:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628805;
        bh=o2wbFfEQvs2eiY4N0Y272HxREAh16iSWwNULUjZBAAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ut2oZ1PyvOy77mRkIebEpifkzaHXJQQai0720S7jQBo3Rl3D3OWlIPKLBPwL0szC4
         R0NE0j5fgBxek64XsYs0pAPk4MB55qsyGSpedqdPA4UPaJwLaV25pHkRssIJeODH83
         j5qpqTOMYp+DC9xr98qzgFH/M4GG6uTkCKyB1Kjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Pierre Gondois <pierre.gondois@arm.com>,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 421/879] PM: EM: Decrement policy counter
Date:   Tue,  7 Jun 2022 18:58:59 +0200
Message-Id: <20220607165015.084278018@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre Gondois <Pierre.Gondois@arm.com>

[ Upstream commit c9d8923bfbcb63f15ea6cb2b5c8426fc3d96f643 ]

In commit e458716a92b57 ("PM: EM: Mark inefficiencies in CPUFreq"),
cpufreq_cpu_get() is called without a cpufreq_cpu_put(), permanently
increasing the reference counts of the policy struct.

Decrement the reference count once the policy struct is not used
anymore.

Fixes: e458716a92b57 ("PM: EM: Mark inefficiencies in CPUFreq")
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 0153b0ca7b23..6219aaa454b5 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -259,6 +259,8 @@ static void em_cpufreq_update_efficiencies(struct device *dev)
 			found++;
 	}
 
+	cpufreq_cpu_put(policy);
+
 	if (!found)
 		return;
 
-- 
2.35.1



