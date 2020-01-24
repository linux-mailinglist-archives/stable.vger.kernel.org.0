Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8930C147BC9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbgAXJqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:46:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbgAXJqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:46:14 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F323208C4;
        Fri, 24 Jan 2020 09:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859173;
        bh=VRI51U4My+NHimQqeufLmriJGYRrA9IeEFOwnyyLVlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kt2qV8knQnuAREJjqw9u5WqXgU/L4Z5vO66Xg6PT0q4969tfzqxlleQoAqIwFw0mz
         yQMN+OG0jk0QTPvf6PImm7b/qVEl/FzV6uFbXOOkgijp0QHnRiNc/ZEPxQqSijHzSP
         HvMDZhCiSm02eVUiuDswsL0faNVawtcdq2/McllY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 046/343] clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()
Date:   Fri, 24 Jan 2020 10:27:44 +0100
Message-Id: <20200124092925.802707075@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit cee82eb9532090cd1dc953e845d71f9b1445c84e ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: e062b571777f ("clk: exynos4: register clocks using common clock framework")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index d8d3cb67b4029..3d30262219275 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1240,6 +1240,7 @@ static unsigned long __init exynos4_get_xom(void)
 			xom = readl(chipid_base + 8);
 
 		iounmap(chipid_base);
+		of_node_put(np);
 	}
 
 	return xom;
-- 
2.20.1



