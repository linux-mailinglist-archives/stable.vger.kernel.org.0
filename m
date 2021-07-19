Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACFD3CDE5E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245757AbhGSPCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345254AbhGSPA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5868F6023D;
        Mon, 19 Jul 2021 15:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709265;
        bh=B6+XWZXA+bQiRmX2fdIQY8tXieVWOpTLaUqOfFmMmnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGVuuDO8BCsOcFNUb5CvyPcBbQ/N1NDpMaZfkK8xOyCFIqfl4qDjrKQTEmGJTm3cw
         LMvIrrQJPs3qzqVPRBYSTCeUC+PG1f+xL+QXxYf5lcnM4XuYN7TrTY9kqc+UeWmftp
         5EobdlGelX/kaDfnyD+WyY8+30+2Ci3sSq31RyTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 314/421] pinctrl: mcp23s08: Fix missing unlock on error in mcp23s08_irq()
Date:   Mon, 19 Jul 2021 16:52:05 +0200
Message-Id: <20210719144957.199050521@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
@@ -460,7 +460,7 @@ static irqreturn_t mcp23s08_irq(int irq,
 
 	if (intf == 0) {
 		/* There is no interrupt pending */
-		return IRQ_HANDLED;
+		goto unlock;
 	}
 
 	if (mcp_read(mcp, MCP_INTCAP, &intcap))


