Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06713CAB93
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242834AbhGOTUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244308AbhGOTSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:18:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 483CD613E7;
        Thu, 15 Jul 2021 19:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376409;
        bh=6dYphgOo2THbfEUnJoMnC1dpOKDYDO6E0Xo8s0leiS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wQq9baZUpqO0agj1mvnXsbcVn/xGa7ByJhwVxD3DSWke3VFejkGY14/KHA8qpWQB
         aZVAXkPpaHPvlylToZ0lPWkSuusOA7XUXJwhckMRLa/bxQ0iU8xuz+K1b3V+sCQH5U
         6821JlCSBXRIby4S6aYxWlm7QAfDw+sdINkHLQcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.13 260/266] pinctrl: mcp23s08: Fix missing unlock on error in mcp23s08_irq()
Date:   Thu, 15 Jul 2021 20:40:15 +0200
Message-Id: <20210715182653.081207078@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

commit 884af72c90016cfccd5717439c86b48702cbf184 upstream.

Add the missing unlock before return from function mcp23s08_irq()
in the error handling case.

v1-->v2:
   remove the "return IRQ_HANDLED" line

Fixes: 897120d41e7a ("pinctrl: mcp23s08: fix race condition in irq handler")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1623134048-56051-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-mcp23s08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -353,7 +353,7 @@ static irqreturn_t mcp23s08_irq(int irq,
 
 	if (intf == 0) {
 		/* There is no interrupt pending */
-		return IRQ_HANDLED;
+		goto unlock;
 	}
 
 	if (mcp_read(mcp, MCP_INTCAP, &intcap))


