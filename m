Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7797E6AEACB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjCGRhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbjCGRhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:37:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A1D233F8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:33:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B97961519
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024FDC433EF;
        Tue,  7 Mar 2023 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210383;
        bh=cnmknNZZQxhnfER+yEBtT6u1lp4kFhvlt3kXrosONVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRqKBJLLzjIWnKM1VBYYjzWHFTp0esZupLWEzKnLVN2Io0fxc+SiQnfurr805S0GE
         JlfDjMcvigRi2zhLpNjidpaQuAmkMto+PTVwyJc1m527Wh7TOo1wcCqqqlRB/FnwCn
         VmBlJSXDHcJZs+Fb+qlbSwZ+1/3cGlFXYXhGp2EM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hanna Hawa <hhhawa@amazon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0492/1001] i2c: designware: fix i2c_dw_clk_rate() return size to be u32
Date:   Tue,  7 Mar 2023 17:54:24 +0100
Message-Id: <20230307170042.730453689@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 581e02cc979a0..2f2e99882b011 100644
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
index 95ebc5eaa5d12..6bc2edec14f2f 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -320,7 +320,7 @@ int i2c_dw_init_regmap(struct dw_i2c_dev *dev);
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



