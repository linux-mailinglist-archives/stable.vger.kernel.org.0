Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3452F13E653
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391400AbgAPRSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:18:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391394AbgAPRSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:18:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 670E0246BB;
        Thu, 16 Jan 2020 17:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195090;
        bh=IJdBW9s7P6muCDiCPH/9soWE1t/hJIAxQmIkypLgALw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXhlplOLVmrttep9BnH4R/B5mwNxNBPyA+Ottwo9y9z0UtaclBU6aftVO7kz0C3hV
         tXIJKbYY1wk7NkZ7QIsy9bf3kjb1fagj6v6tdvgR4FTac5Ivw75eeoRkVP/5RRGu2a
         IEdy2hRP0aIaPviQYChbXHoPITcFvaO+EJeIAzBo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 037/371] clk: qoriq: fix refcount leak in clockgen_init()
Date:   Thu, 16 Jan 2020 12:11:45 -0500
Message-Id: <20200116171719.16965-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 70af6c5b5270e8101f318c4b69cc98a726edfab9 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: 0dfc86b3173f ("clk: qoriq: Move chip-specific knowledge into driver")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-qoriq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-qoriq.c b/drivers/clk/clk-qoriq.c
index 1a292519d84f..999a90a16609 100644
--- a/drivers/clk/clk-qoriq.c
+++ b/drivers/clk/clk-qoriq.c
@@ -1382,6 +1382,7 @@ static void __init clockgen_init(struct device_node *np)
 				pr_err("%s: Couldn't map %pOF regs\n", __func__,
 				       guts);
 			}
+			of_node_put(guts);
 		}
 
 	}
-- 
2.20.1

