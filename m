Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B5C2E165D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgLWCSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbgLWCSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCF6F233FB;
        Wed, 23 Dec 2020 02:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689867;
        bh=Bdz7K2+IYgGhLbm1Wpd9GxL24Md95bh/X7Jqy9dm9is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoYW5MOIhhCgIHV3163sR2BNka9K13iuwJJjDh/Mo/6nGftdo7FJH1UnLJatd7WkL
         FBqGGsiBdIx1D0E67iJLusDZhMtfG9qVA/JPp5e0Q/CKhU9ZLlEKAKjs3Ff041KDao
         EsMjOZrG0yIl9IV5NWA0yJV0uHpGD4xukuhMVJ5Zc4E1dkVCpv5u3HBRnVqN1JCeTa
         tVlSeKQ3pOM+GvMAyRHMVQ1sFSCqCgJqfnrT+KEQFpCxj81/4U9huY+mwniMvjAKdV
         MM3PTkhOVvGh8ExARJONcxrKxAP96Exkc/oPUEVhy2Rk9F1rv7BJF1/gYtg3DiR5mH
         zOfpOy6H+bzZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Martijn Coenen <maco@android.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 062/217] binder: change error code from postive to negative in binder_transaction
Date:   Tue, 22 Dec 2020 21:13:51 -0500
Message-Id: <20201223021626.2790791-62-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 88f6c77927e4aee04e0193fd94e13a55753a72b0 ]

Depending on the context, the error return value
here (extra_buffers_size < added_size) should be
negative.

Acked-by: Martijn Coenen <maco@android.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201026110314.135481-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index b5117576792bc..8bbfb9124fa29 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3103,7 +3103,7 @@ static void binder_transaction(struct binder_proc *proc,
 		if (extra_buffers_size < added_size) {
 			/* integer overflow of extra_buffers_size */
 			return_error = BR_FAILED_REPLY;
-			return_error_param = EINVAL;
+			return_error_param = -EINVAL;
 			return_error_line = __LINE__;
 			goto err_bad_extra_size;
 		}
-- 
2.27.0

