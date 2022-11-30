Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE6D63DF23
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiK3SoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbiK3SoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFFF93A55
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A602161D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F97C433C1;
        Wed, 30 Nov 2022 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833838;
        bh=3zNwnR+6qwxjKhSPOed61h4gjhKgLCovu/E6R7K48/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XC+hIcnJcw9XlqlLRwIvio12P4V5zMKQwg3bJLgB761qLbxsybd+B5DNl2XJEZ31o
         X/0dR5FAdn7ZmmStDrcC48NHqpYqr47Aehhj/lAJrRXvze2VNwqbI/wBM69ke+/s+s
         DL9/VykUO3rr+Gj19e3F4DNg5b/IrevZ8GqJy7Gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 033/289] net: wwan: iosm: fix kernel test robot reported errors
Date:   Wed, 30 Nov 2022 19:20:18 +0100
Message-Id: <20221130180544.883901038@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit 980ec04a88c9f0046c1da65833fb77b2ffa34b04 ]

Include linux/vmalloc.h in iosm_ipc_coredump.c &
iosm_ipc_devlink.c to resolve kernel test robot errors.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_coredump.c | 1 +
 drivers/net/wwan/iosm/iosm_ipc_devlink.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_coredump.c b/drivers/net/wwan/iosm/iosm_ipc_coredump.c
index 9acd87724c9d..26ca30476f40 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_coredump.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_coredump.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020-2021 Intel Corporation.
  */
+#include <linux/vmalloc.h>
 
 #include "iosm_ipc_coredump.h"
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_devlink.c b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
index 17da85a8f337..2fe724d623c0 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_devlink.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020-2021 Intel Corporation.
  */
+#include <linux/vmalloc.h>
 
 #include "iosm_ipc_chnl_cfg.h"
 #include "iosm_ipc_coredump.h"
-- 
2.35.1



