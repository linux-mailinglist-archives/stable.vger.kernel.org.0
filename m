Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A191829B69F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797440AbgJ0PXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797437AbgJ0PXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5451820657;
        Tue, 27 Oct 2020 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812213;
        bh=biHJM8C+ItQFetRuYpsBSWjkyDAu9VvbvfyiUyE33Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3Qh2uH3636FwI9p7MGi/jN6rlX3Caas4Ek6KtJbjLBKI26CNy23dWlQqnhkZUuQq
         RrarJ7iXxlDOdOiMBMeMRA5UUDgJH0xN+S5zNrSdcJgXWaKOyQ/MOY7SEBn8FVXMoN
         igleeZ6CBYVXy2hA92eRFAxAbNlYaq+Oa+IX+7mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 131/757] media: m5mols: Check function pointer in m5mols_sensor_power
Date:   Tue, 27 Oct 2020 14:46:21 +0100
Message-Id: <20201027135456.729465706@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

[ Upstream commit 52438c4463ac904d14bf3496765e67750766f3a6 ]

clang static analysis reports this error

m5mols_core.c:767:4: warning: Called function pointer
  is null (null dereference) [core.CallAndMessage]
    info->set_power(&client->dev, 0);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In other places, the set_power ptr is checked.
So add a check.

Fixes: bc125106f8af ("[media] Add support for M-5MOLS 8 Mega Pixel camera ISP")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index de295114ca482..21666d705e372 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -764,7 +764,8 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 
 		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
 		if (ret) {
-			info->set_power(&client->dev, 0);
+			if (info->set_power)
+				info->set_power(&client->dev, 0);
 			return ret;
 		}
 
-- 
2.25.1



