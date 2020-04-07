Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FB81A0B8F
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgDGK0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729194AbgDGK0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:26:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBC172074B;
        Tue,  7 Apr 2020 10:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255200;
        bh=zMvRv1xvSRez/I8XS6dOdstcuN71d0iQj0e9cGUUUMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhELqkAKWyxkbtg4eJLLL6suLYt/WA/PaTJakdEXw+P5dVtmyT0kj5zo36g3m2rFs
         Vnzd5rVbbne1Asz1z8wUOQhiYmZcnczrEqqgvQJl5bgfaDAZZew/VQclI2QijYZsp9
         D0RY9gOWccFQpZSGEXpa5syai0d3bieWfxB7KE5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Freeman Liu <freeman.liu@unisoc.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.6 23/29] nvmem: sprd: Fix the block lock operation
Date:   Tue,  7 Apr 2020 12:22:20 +0200
Message-Id: <20200407101454.889747276@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Freeman Liu <freeman.liu@unisoc.com>

commit c66ebde4d988b592e8f0008e04c47cc4950a49d3 upstream.

According to the Spreadtrum eFuse specification, we should write 0 to
the block to trigger the lock operation.

Fixes: 096030e7f449 ("nvmem: sprd: Add Spreadtrum SoCs eFuse support")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Freeman Liu <freeman.liu@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200323150007.7487-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvmem/sprd-efuse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvmem/sprd-efuse.c
+++ b/drivers/nvmem/sprd-efuse.c
@@ -239,7 +239,7 @@ static int sprd_efuse_raw_prog(struct sp
 		ret = -EBUSY;
 	} else {
 		sprd_efuse_set_prog_lock(efuse, lock);
-		writel(*data, efuse->base + SPRD_EFUSE_MEM(blk));
+		writel(0, efuse->base + SPRD_EFUSE_MEM(blk));
 		sprd_efuse_set_prog_lock(efuse, false);
 	}
 


