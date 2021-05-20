Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9BB38A6D4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhETKbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235683AbhETK2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:28:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2036361492;
        Thu, 20 May 2021 09:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504248;
        bh=wuEv9uLP2+8BvOM9r0lSZMHS1SSZLXzGGyT9AoTcsCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPVESW81hd3oikIZVOIAC847scCFTBwzXlEcO4tvKSkzQDssdxxlTwg4hRk+pgrFF
         55wW+gx/6PszULNsv3ZDxqmp/hbD7jdBF0zKaQGlTVzNtFGItgr80s7fqaILVa4zPY
         s/lbVHAP3e7/lWf6DakphJxbfZA34U/tGP3auOmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Pan Bian <bianpan2016@163.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 158/323] bus: qcom: Put child node before return
Date:   Thu, 20 May 2021 11:20:50 +0200
Message-Id: <20210520092125.515547331@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit ac6ad7c2a862d682bb584a4bc904d89fa7721af8 ]

Put child node before return to fix potential reference count leak.
Generally, the reference count of child is incremented and decremented
automatically in the macro for_each_available_child_of_node() and should
be decremented manually if the loop is broken in loop body.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: 335a12754808 ("bus: qcom: add EBI2 driver")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121114907.109267-1-bianpan2016@163.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/qcom-ebi2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/qcom-ebi2.c b/drivers/bus/qcom-ebi2.c
index a6444244c411..bfb67aa00bec 100644
--- a/drivers/bus/qcom-ebi2.c
+++ b/drivers/bus/qcom-ebi2.c
@@ -357,8 +357,10 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 
 		/* Figure out the chipselect */
 		ret = of_property_read_u32(child, "reg", &csindex);
-		if (ret)
+		if (ret) {
+			of_node_put(child);
 			return ret;
+		}
 
 		if (csindex > 5) {
 			dev_err(dev,
-- 
2.30.2



