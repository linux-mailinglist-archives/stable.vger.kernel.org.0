Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434BC2E687E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437378AbgL1QhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:37:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729851AbgL1NBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:01:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3947C22573;
        Mon, 28 Dec 2020 13:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160467;
        bh=jxrjnqIMyw4tF0dbRn8yKHdCEljgt65L9YbVWa44q3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11inM8qXW/iwVHi1fLCdaP8AKEZa4woZ/CQujPq/IQFTASohdDo96PsFcI1+x0ccP
         kA6avLqL5/nH6SbHh7SoH88vIhgfYVLuB1EwVgJgzxuXgPfBt8+WOSZfejJ22vj9xL
         Qz7Fsjvl5kvlsl97tO8C7tsats4pkR+lpeZZ/Rt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 054/175] spi: img-spfi: fix reference leak in img_spfi_resume
Date:   Mon, 28 Dec 2020 13:48:27 +0100
Message-Id: <20201228124855.874677417@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit ee5558a9084584015c8754ffd029ce14a5827fa8 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in img_spfi_resume, so we should fix it.

Fixes: deba25800a12b ("spi: Add driver for IMG SPFI controller")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201102145651.3875-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-img-spfi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index 2e65b70c78792..2a340234c85c1 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -771,8 +771,10 @@ static int img_spfi_resume(struct device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_noidle(dev);
 		return ret;
+	}
 	spfi_reset(spfi);
 	pm_runtime_put(dev);
 
-- 
2.27.0



