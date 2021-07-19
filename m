Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1CD3CE362
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241446AbhGSPhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347299AbhGSPfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2261E61464;
        Mon, 19 Jul 2021 16:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711137;
        bh=6oussey0HRECi3hSQKZL9JXBsdu6U9bASLIFinatFVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hU+G1ycxHXGSnU+xUoLUpg0b0XzItw2DDsCGbXJuBa082rGOWhCfMefYIc6a+gLkT
         1JG3l8xGe0SVGPri9FQwoWGs1I9h5wWO9oEJWstIIVcuAMbzyH23Dv7MSC2KbJrpMt
         K7Mk3TRsBDvhnSptgEw5F/DfyVIbpKQDJVY0Rugs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 208/351] remoteproc: stm32: fix phys_addr_t format string
Date:   Mon, 19 Jul 2021 16:52:34 +0200
Message-Id: <20210719144951.850159163@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3e25e407a1c93b53a87a7743ea0cd4703d3985b7 ]

A phys_addr_t may be wider than an int or pointer:

drivers/remoteproc/stm32_rproc.c: In function 'stm32_rproc_da_to_pa':
drivers/remoteproc/stm32_rproc.c:583:30: error: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'phys_addr_t' {aka 'long long unsigned int'} [-Werror=format=]
  583 |                 dev_dbg(dev, "da %llx to pa %#x\n", da, *pa);

Print it by reference using the special %pap format string.

Reviewed-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Fixes: 8a471396d21c ("remoteproc: stm32: Move resource table setup to rproc_ops")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210421140053.3727528-1-arnd@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/stm32_rproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/stm32_rproc.c b/drivers/remoteproc/stm32_rproc.c
index 0e8203a432ab..b643efcf995a 100644
--- a/drivers/remoteproc/stm32_rproc.c
+++ b/drivers/remoteproc/stm32_rproc.c
@@ -576,7 +576,7 @@ static int stm32_rproc_da_to_pa(struct rproc *rproc,
 			continue;
 
 		*pa = da - p_mem->dev_addr + p_mem->bus_addr;
-		dev_dbg(dev, "da %llx to pa %#x\n", da, *pa);
+		dev_dbg(dev, "da %llx to pa %pap\n", da, pa);
 
 		return 0;
 	}
-- 
2.30.2



