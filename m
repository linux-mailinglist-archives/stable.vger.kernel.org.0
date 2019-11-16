Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7173EFF3CF
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfKPPlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbfKPPlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:20 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C33820730;
        Sat, 16 Nov 2019 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918879;
        bh=uWZClTrsqmEFx8byq1mK09fgpItzYGHhc8KLTIkX/1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HE/rOSQzwYjhIJpIj6M2ykxTXZuh5t+0d8DsU4R1oH8lifnaJ5J8nrSOhr5ifxBo/
         sLlciVkJtFvRGa7vy07LaqaIbxPww3lkZ0YGFTNkbBHme/LouxZTyyeTj6m+piSODK
         +QCVt51DRL2/wDmH3DrFf/48dcCou/MugiEOnXc4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 010/237] powerpc: Fix signedness bug in update_flash_db()
Date:   Sat, 16 Nov 2019 10:37:25 -0500
Message-Id: <20191116154113.7417-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 014704e6f54189a203cc14c7c0bb411b940241bc ]

The "count < sizeof(struct os_area_db)" comparison is type promoted to
size_t so negative values of "count" are treated as very high values
and we accidentally return success instead of a negative error code.

This doesn't really change runtime much but it fixes a static checker
warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/ps3/os-area.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/ps3/os-area.c b/arch/powerpc/platforms/ps3/os-area.c
index cdbfc5cfd6f38..f5387ad822798 100644
--- a/arch/powerpc/platforms/ps3/os-area.c
+++ b/arch/powerpc/platforms/ps3/os-area.c
@@ -664,7 +664,7 @@ static int update_flash_db(void)
 	db_set_64(db, &os_area_db_id_rtc_diff, saved_params.rtc_diff);
 
 	count = os_area_flash_write(db, sizeof(struct os_area_db), pos);
-	if (count < sizeof(struct os_area_db)) {
+	if (count < 0 || count < sizeof(struct os_area_db)) {
 		pr_debug("%s: os_area_flash_write failed %zd\n", __func__,
 			 count);
 		error = count < 0 ? count : -EIO;
-- 
2.20.1

