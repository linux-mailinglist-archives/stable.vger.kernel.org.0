Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA4166CA45
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbjAPRBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjAPRAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:00:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8286638B7B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:43:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33F40B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8976DC433EF;
        Mon, 16 Jan 2023 16:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887391;
        bh=stfLp0VE0MjbuLvjoOMGI/QFcV5Jj4/z25k0KZeamrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MM/zfamPXWJULD4EmCVSA0GJlqOh61INnNab4Nr7PjuKfYUpvAFQTjkdi7HBIiiJs
         rLuMmTp9sal7bPpdSuKp+pl245RkvD04FLZpfq/J6SHIlkO5PCWydWrYYs9851vcjt
         +NyggBV0mcCwcFQyoTmc1FQuASo0TIMs7fdUkSsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/521] wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails
Date:   Mon, 16 Jan 2023 16:46:32 +0100
Message-Id: <20230116154853.081504263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 833a9fd28c9b7ccb39a334721379e992dc1c0c89 ]

In regulatory_init_db(), when it's going to return a error, reg_pdev
should be unregistered. When load_builtin_regdb_keys() fails it doesn't
do it and makes cfg80211 can't be reload with report:

sysfs: cannot create duplicate filename '/devices/platform/regulatory.0'
 ...
 <TASK>
 dump_stack_lvl+0x79/0x9b
 sysfs_warn_dup.cold+0x1c/0x29
 sysfs_create_dir_ns+0x22d/0x290
 kobject_add_internal+0x247/0x800
 kobject_add+0x135/0x1b0
 device_add+0x389/0x1be0
 platform_device_add+0x28f/0x790
 platform_device_register_full+0x376/0x4b0
 regulatory_init+0x9a/0x4b2 [cfg80211]
 cfg80211_init+0x84/0x113 [cfg80211]
 ...

Fixes: 90a53e4432b1 ("cfg80211: implement regdb signature checking")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221109090237.214127-1-chenzhongjin@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 07d053603e3a..beba41f8a178 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3918,8 +3918,10 @@ static int __init regulatory_init_db(void)
 		return -EINVAL;
 
 	err = load_builtin_regdb_keys();
-	if (err)
+	if (err) {
+		platform_device_unregister(reg_pdev);
 		return err;
+	}
 
 	/* We always try to get an update for the static regdomain */
 	err = regulatory_hint_core(cfg80211_world_regdom->alpha2);
-- 
2.35.1



