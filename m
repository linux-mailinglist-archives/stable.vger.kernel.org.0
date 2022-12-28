Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065D4657AB4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiL1POX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbiL1PNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:13:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AF813EAD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:13:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D81016155E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB579C433D2;
        Wed, 28 Dec 2022 15:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240433;
        bh=4FC6jk3ntqI5H7ME6PgtFQUY/Yig9Gf7EsmELbq0Vfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clv+HNnnYsvxMkmY4EiqeBb8trL/NcKebI/OunndYciv/thgMTZ/4wrKhzffnoTvi
         0HzdIp4gmtrqrlvFGoBOtBIajWf9Z2sCo6mIBZVXy5EXYbsLCHAEd2tekwTobWnGph
         SKKJ3H9HY54ulMTkPQ/iUi7Bdq89jUJEROQtVg84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0129/1073] perf/x86/intel/uncore: Fix reference count leak in sad_cfg_iio_topology()
Date:   Wed, 28 Dec 2022 15:28:37 +0100
Message-Id: <20221228144331.540116086@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit c508eb042d9739bf9473526f53303721b70e9100 ]

pci_get_device() will increase the reference count for the returned
pci_dev, and also decrease the reference count for the input parameter
*from* if it is not NULL.

If we break the loop in sad_cfg_iio_topology() with 'dev' not NULL. We
need to call pci_dev_put() to decrease the reference count. Since
pci_dev_put() can handle the NULL input parameter, we can just add one
pci_dev_put() right before 'return ret'.

Fixes: c1777be3646b ("perf/x86/intel/uncore: Enable I/O stacks to IIO PMON mapping on SNR")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20221118063137.121512-2-wangxiongfeng2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index ed869443efb2..76fedc8e12dd 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4492,6 +4492,8 @@ static int sad_cfg_iio_topology(struct intel_uncore_type *type, u8 *sad_pmon_map
 		type->topology = NULL;
 	}
 
+	pci_dev_put(dev);
+
 	return ret;
 }
 
-- 
2.35.1



