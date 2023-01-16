Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE2F66C636
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbjAPQQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbjAPQPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:15:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2452D149
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:09:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C339CB8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B0EC433EF;
        Mon, 16 Jan 2023 16:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885361;
        bh=z+fvUpmj38j8B1IpJQB5YzQydRPN0lvlSgn0iSJlb/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InxBv330L26Qr3O9avQM1ViuYsuJ6YMyoXo2IbUG72rPG/ffzCfXhQufK1/igS4yN
         xYdAKe/ke47LhoNyS/tHfGNbQgONyYpKXk1+veUkndzlEQA6ADYk/hQfU3+ohTEcEQ
         +lewHKd09I93we/9plPJE6GYMBsMpMtKgcEWKbJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Jiahao <chenjiahao16@huawei.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/658] drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static
Date:   Mon, 16 Jan 2023 16:41:50 +0100
Message-Id: <20230116154910.651793528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Chen Jiahao <chenjiahao16@huawei.com>

[ Upstream commit adf85adc2a7199b41e7a4da083bd17274a3d6969 ]

There is a sparse warning shown below:

drivers/soc/ti/knav_qmss_queue.c:70:12: warning: symbol
'knav_acc_firmwares' was not declared. Should it be static?

Since 'knav_acc_firmwares' is only called within knav_qmss_queue.c,
mark it as static to fix the warning.

Fixes: 96ee19becc3b ("soc: ti: add firmware file name as part of the driver")
Signed-off-by: Chen Jiahao <chenjiahao16@huawei.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20221019153212.72350-1-chenjiahao16@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index b8210479ec99..d5fc00979628 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -64,7 +64,7 @@ static DEFINE_MUTEX(knav_dev_lock);
  * Newest followed by older ones. Search is done from start of the array
  * until a firmware file is found.
  */
-const char *knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
+static const char * const knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
 
 static bool device_ready;
 bool knav_qmss_device_ready(void)
-- 
2.35.1



