Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29EE38EDDB
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhEXPnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233691AbhEXPk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:40:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6168961440;
        Mon, 24 May 2021 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870466;
        bh=camBSRbpkDb7ZdGiXRKDQ5VA9nbY2heBx7g4NdR8c7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbdGoIr53gb/BSrfbH21vOeoREOx8BvaGAun0lpc2FdfmFoXs+ErXeJ7NPSa05sPE
         M2eVKUhrL94HXCTLGA9u37ACKYifwn6MlhvyJbkQcIuutL3Ly/Mz8/54kmlKOubMlD
         FibRBgoywZlwO8bPdll/y+wQ/JrI4a+VJGHlYMis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/49] firmware: arm_scpi: Prevent the ternary sign expansion bug
Date:   Mon, 24 May 2021 17:25:12 +0200
Message-Id: <20210524152324.429513626@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d9cd78edb2e6b7e26747c0ec312be31e7ef196fe ]

How the type promotion works in ternary expressions is a bit tricky.
The problem is that scpi_clk_get_val() returns longs, "ret" is a int
which holds a negative error code, and le32_to_cpu() is an unsigned int.
We want the negative error code to be cast to a negative long.  But
because le32_to_cpu() is an u32 then "ret" is type promoted to u32 and
becomes a high positive and then it is promoted to long and it is still
a high positive value.

Fix this by getting rid of the ternary.

Link: https://lore.kernel.org/r/YIE7pdqV/h10tEAK@mwanda
Fixes: 8cb7cf56c9fe ("firmware: add support for ARM System Control and Power Interface(SCPI) protocol")
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[sudeep.holla: changed to return 0 as clock rate on error]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index c7d06a36b23a..baa7280eccb3 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -563,8 +563,10 @@ static unsigned long scpi_clk_get_val(u16 clk_id)
 
 	ret = scpi_send_message(CMD_GET_CLOCK_VALUE, &le_clk_id,
 				sizeof(le_clk_id), &rate, sizeof(rate));
+	if (ret)
+		return 0;
 
-	return ret ? ret : le32_to_cpu(rate);
+	return le32_to_cpu(rate);
 }
 
 static int scpi_clk_set_val(u16 clk_id, unsigned long rate)
-- 
2.30.2



