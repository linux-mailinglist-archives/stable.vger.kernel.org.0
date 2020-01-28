Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DEF14B796
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbgA1OPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:15:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbgA1OPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:15:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 715472070E;
        Tue, 28 Jan 2020 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220947;
        bh=SDqW5Iph+lI9dhyYY8ABmTB0TCq8uR/gTZCPBN8GEXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cR/iYU5fo3X5f80YzNJerjo31WnUquHVGcDYzRYZAkMF9sFHLPRJEQ4hXRUTEnWrh
         V7f7N4hcPwYbiQ+vroZeY3sn+KMSj9SdaISywuqZuutHrakSagDTFUcknEZGXzzM/P
         y/vQ6sEhqDcQZ3bqalk8SByE1gCx43Hq/ry9v2FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 027/271] clk: qoriq: fix refcount leak in clockgen_init()
Date:   Tue, 28 Jan 2020 15:02:56 +0100
Message-Id: <20200128135854.697426763@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cdce49f6476aa..65876ff6df411 100644
--- a/drivers/clk/clk-qoriq.c
+++ b/drivers/clk/clk-qoriq.c
@@ -1245,6 +1245,7 @@ static void __init clockgen_init(struct device_node *np)
 				pr_err("%s: Couldn't map %s regs\n", __func__,
 				       guts->full_name);
 			}
+			of_node_put(guts);
 		}
 
 	}
-- 
2.20.1



