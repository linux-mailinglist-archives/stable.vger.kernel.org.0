Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09C657AEA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiL1PQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiL1PQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:16:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03386D80
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:16:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE5E2B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A91C433EF;
        Wed, 28 Dec 2022 15:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240574;
        bh=35wUNQA3z0odziUalHmDpCk9+LKaQ4zeghy4IUYunuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgEDcoULUZatqATinH7yB6wg+yh7hQWG3vkGc1qV5+4kXfeHAMUskhSjuvPGk3fcB
         GSpseApSgoIuqCsfqJXr9HFb08EIEWAkgZ4+h26/7HKlBVeE8UC7UYMBvNTnYPZc60
         M1W59atX3oPUd681qLRffBy0Nv1JMlZmgJ1xFJn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0141/1146] perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()
Date:   Wed, 28 Dec 2022 15:28:00 +0100
Message-Id: <20221228144333.976568448@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 1ff9dd6e7071a561f803135c1d684b13c7a7d01d ]

pci_get_device() will increase the reference count for the returned
'dev'. We need to call pci_dev_put() to decrease the reference count.
Since 'dev' is only used in pci_read_config_dword(), let's add
pci_dev_put() right after it.

Fixes: 9d480158ee86 ("perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20221118063137.121512-3-wangxiongfeng2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 76fedc8e12dd..f5d89d06c66a 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -2891,6 +2891,7 @@ static bool hswep_has_limit_sbox(unsigned int device)
 		return false;
 
 	pci_read_config_dword(dev, HSWEP_PCU_CAPID4_OFFET, &capid4);
+	pci_dev_put(dev);
 	if (!hswep_get_chop(capid4))
 		return true;
 
-- 
2.35.1



