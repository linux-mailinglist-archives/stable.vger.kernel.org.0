Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445B810BF5B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbfK0Vme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:42:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbfK0Ujy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:39:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0647320863;
        Wed, 27 Nov 2019 20:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887193;
        bh=LZp/NX6ULwok7KISCfKKkJI5x6JyKuh3DkWBM1uLWIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSg4jg9hpDb7a/W8Vk677vDoT1hkZbudjSyG/gKY96jF5qV7ubZPT24/8xseeXinF
         b0x0sZknlReAfZKaD/BH4BXcdC+hDvJKPq82+P714GB5RKUY32TddbEhPm5eM6T8Sg
         JCvvyyB+RjwK4d6ajn6wXBG9+yZSBa3SE6nk0DIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 017/151] powerpc: Fix signedness bug in update_flash_db()
Date:   Wed, 27 Nov 2019 21:30:00 +0100
Message-Id: <20191127203010.440341531@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3db53e8aff927..9b2ef76578f06 100644
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



