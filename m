Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5060451E51
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349355AbhKPAfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344798AbhKOTZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C86F633DB;
        Mon, 15 Nov 2021 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003077;
        bh=P2r1svbrR0FvdhPuUQFkCzHvBD8t19nlfyexA5OxDa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ChSKKj6TZjQk4QB4Fs7+a655bZmMNmR2rL7CrD0IWiRNWIWXw+TbSWQdxOUeeJWwa
         Y3RpSwj93s5QxWIcEnDakROZtruZ5Xg80HEw0JaokbanRd3vBalgoGTIBtiYOABzwR
         pi2pVp+xwy6G4YnVXlhviL0nwb3CHmjU4p+ytkx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Song <songkai01@inspur.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 801/917] mfd: altera-sysmgr: Fix a mistake caused by resource_size conversion
Date:   Mon, 15 Nov 2021 18:04:56 +0100
Message-Id: <20211115165456.129673042@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Song <songkai01@inspur.com>

[ Upstream commit fae2570d629cdd72f0611d015fc4ba705ae5422b ]

The resource_size defines that:
	res->end - res->start + 1;
The origin original code is:
	sysmgr_config.max_register = res->end - res->start - 3;

So, the correct fix is that:
	sysmgr_config.max_register = resource_size(res) - 4;

Fixes: d12edf9661a4 ("mfd: altera-sysmgr: Use resource_size function on resource object")
Signed-off-by: Kai Song <songkai01@inspur.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211006141926.6120-1-songkai01@inspur.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/altera-sysmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/altera-sysmgr.c b/drivers/mfd/altera-sysmgr.c
index 20cb294c75122..5d3715a28b28e 100644
--- a/drivers/mfd/altera-sysmgr.c
+++ b/drivers/mfd/altera-sysmgr.c
@@ -153,7 +153,7 @@ static int sysmgr_probe(struct platform_device *pdev)
 		if (!base)
 			return -ENOMEM;
 
-		sysmgr_config.max_register = resource_size(res) - 3;
+		sysmgr_config.max_register = resource_size(res) - 4;
 		regmap = devm_regmap_init_mmio(dev, base, &sysmgr_config);
 	}
 
-- 
2.33.0



