Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2826673FA
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjALOBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjALOBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:01:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0913749167
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:01:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75510CE1E71
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D9CC433D2;
        Thu, 12 Jan 2023 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532066;
        bh=VLa1tK1QH1ISOWwngbyqgw7EdYyBJFJW0IeaZDx88Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCoqnhYB5K+URUwqV6ts12LTM15we+Dy/24X6hqNGzUFe5Wme0i2ZCUiMXesu4i3I
         ljvJs1CNdpPxG5IWHYtPfU6b/c0umhCYVIcUghp0T3IQ83TyMYrzKeyfa+/BtxLcOu
         fZ3PxjKRS4v739FySaugW4WzJ03s2Ta1K2EX+fzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Jiahao <chenjiahao16@huawei.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/783] drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static
Date:   Thu, 12 Jan 2023 14:45:27 +0100
Message-Id: <20230112135524.698691850@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 53e36d4328d1..baab7d558a69 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -67,7 +67,7 @@ static DEFINE_MUTEX(knav_dev_lock);
  * Newest followed by older ones. Search is done from start of the array
  * until a firmware file is found.
  */
-const char *knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
+static const char * const knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
 
 static bool device_ready;
 bool knav_qmss_device_ready(void)
-- 
2.35.1



