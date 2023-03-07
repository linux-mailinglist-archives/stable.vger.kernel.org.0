Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022DB6AF436
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbjCGTOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjCGTOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:14:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8BA43471
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:58:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C04E9B819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA09C433D2;
        Tue,  7 Mar 2023 18:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215487;
        bh=yQs/cC66x/roXnEUE44zDOMy4AyrU6EqQoh3T6TabmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQguzGdR+blTlHdzEOKHg+VQyybdOzB1D44cHg04LxEMboGQI6fUeftUvYfKm/Z3m
         PLyHAvoMKuPCZSB54p6esvzpxCzHo9COEhdY4iuNgyhtlikp8QtKov1Ij2HbB5IWn3
         eWZq+ZQCnsXSDCS8x6QqWzQ0lE/3mxj4Tl/kJtGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hanna Hawa <hhhawa@amazon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/567] i2c: designware: fix i2c_dw_clk_rate() return size to be u32
Date:   Tue,  7 Mar 2023 18:00:13 +0100
Message-Id: <20230307165917.902691981@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanna Hawa <hhhawa@amazon.com>

[ Upstream commit f2e1fa99550dd7a882229e2c2cd9ecab4ce773d0 ]

Make i2c_dw_clk_rate() to return u32 instead of unsigned long, as the
function return the value of get_clk_rate_khz() which returns u32.

Fixes: b33af11de236 ("i2c: designware: Do not require clock when SSCN and FFCN are provided")
Signed-off-by: Hanna Hawa <hhhawa@amazon.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-common.c | 2 +-
 drivers/i2c/busses/i2c-designware-core.h   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 4af65f101dac4..4e752321b95e0 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -465,7 +465,7 @@ void __i2c_dw_disable(struct dw_i2c_dev *dev)
 	dev_warn(dev->dev, "timeout in disabling adapter\n");
 }
 
-unsigned long i2c_dw_clk_rate(struct dw_i2c_dev *dev)
+u32 i2c_dw_clk_rate(struct dw_i2c_dev *dev)
 {
 	/*
 	 * Clock is not necessary if we got LCNT/HCNT values directly from
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 9be81dbebede7..59b36e0644f31 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -310,7 +310,7 @@ int i2c_dw_init_regmap(struct dw_i2c_dev *dev);
 u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset);
 u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset);
 int i2c_dw_set_sda_hold(struct dw_i2c_dev *dev);
-unsigned long i2c_dw_clk_rate(struct dw_i2c_dev *dev);
+u32 i2c_dw_clk_rate(struct dw_i2c_dev *dev);
 int i2c_dw_prepare_clk(struct dw_i2c_dev *dev, bool prepare);
 int i2c_dw_acquire_lock(struct dw_i2c_dev *dev);
 void i2c_dw_release_lock(struct dw_i2c_dev *dev);
-- 
2.39.2



