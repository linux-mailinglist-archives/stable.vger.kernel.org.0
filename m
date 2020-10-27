Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0329BCD3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802407AbgJ0QhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801888AbgJ0Po6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB82921D42;
        Tue, 27 Oct 2020 15:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813476;
        bh=7KqA2J9W8RGKJt94qEu1gpm998jLuhzpZ7QPmerkb9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0sjhDB7idpJCaGYBgkSZ4w8hol1MPcNE1ZrCiPEa4RZAgYpulooJekz/ixDEYaLn
         kq1hlDClVtB97RrWzPsuAx9c8eJV7CPItm/83tLH6Bwx1YV42o2hP/mo58Hz9VHr5F
         PRCOUhMnWznWo6VOc8oejDAbHJ4LUncWAkcwYtOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 564/757] Input: stmfts - fix a & vs && typo
Date:   Tue, 27 Oct 2020 14:53:34 +0100
Message-Id: <20201027135516.956855734@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit d04afe14b23651e7a8bc89727a759e982a8458e4 ]

In stmfts_sysfs_hover_enable_write(), we should check value and
sdata->hover_enabled is all true.

Fixes: 78bcac7b2ae1 ("Input: add support for the STMicroelectronics FingerTip touchscreen")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20200916141941.16684-1-yuehaibing@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/stmfts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/stmfts.c b/drivers/input/touchscreen/stmfts.c
index df946869d4cd1..9a64e1dbc04ad 100644
--- a/drivers/input/touchscreen/stmfts.c
+++ b/drivers/input/touchscreen/stmfts.c
@@ -479,7 +479,7 @@ static ssize_t stmfts_sysfs_hover_enable_write(struct device *dev,
 
 	mutex_lock(&sdata->mutex);
 
-	if (value & sdata->hover_enabled)
+	if (value && sdata->hover_enabled)
 		goto out;
 
 	if (sdata->running)
-- 
2.25.1



