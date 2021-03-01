Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB9D328E57
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241631AbhCAT2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:28:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241555AbhCATYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AE0164F18;
        Mon,  1 Mar 2021 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620935;
        bh=TxXnBgku9RvRoSDFn99d3MEmBn7ZQvysst3NMhrVcBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgsJ/Snut6O5pYwdN9ZEj3BX00FxFWFpnCqOEFrWg3YWqjbxJLoHK+bvAPPYFQlr0
         BU9FvW9+xzTzrvBAzb01VtVI3uA5FL629Wk+mRkB2qWuF07wG0D/etNz69fn/cIGRj
         GIiOp2SwdXVLL4xpIHlNZ9y6nZRio51BNy4wdIRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Roy Im <roy.im.opensource@diasemi.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 303/775] Input: da7280 - protect OF match table with CONFIG_OF
Date:   Mon,  1 Mar 2021 17:07:51 +0100
Message-Id: <20210301161216.592109068@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 6d2ad82fece2f5adcafe77252614fcf7211dec28 ]

The OF match table is only used when OF is enabled.

Fixes: cd3f609823a5 ("Input: new da7280 haptic driver")
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Roy Im <roy.im.opensource@diasemi.com>
Link: https://lore.kernel.org/r/X9xRLVPt9eBi0CT6@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/da7280.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/misc/da7280.c b/drivers/input/misc/da7280.c
index 2f698a8c1d650..b08610d6e575e 100644
--- a/drivers/input/misc/da7280.c
+++ b/drivers/input/misc/da7280.c
@@ -1300,11 +1300,13 @@ static int __maybe_unused da7280_resume(struct device *dev)
 	return retval;
 }
 
+#ifdef CONFIG_OF
 static const struct of_device_id da7280_of_match[] = {
 	{ .compatible = "dlg,da7280", },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, da7280_of_match);
+#endif
 
 static const struct i2c_device_id da7280_i2c_id[] = {
 	{ "da7280", },
-- 
2.27.0



