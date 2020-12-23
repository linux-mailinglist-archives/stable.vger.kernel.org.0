Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E820C2E1676
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgLWCT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbgLWCT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C00802337F;
        Wed, 23 Dec 2020 02:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689929;
        bh=fRf/fdmkTF7jK4KfdRY3JEN9qMmApPMEhYWE3+jAHow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaeDX6zEzN9cFJuO2QfaCpcrMOdDfwZDTaSFP5IVEW3sfN0x2+B708z6PbjG4CUFq
         ReXZrMFS9YtLokVQuJqNuLFGhqpksZBdfj56Fxi3gG3F8IE1yo557/LxUTyZldzcy0
         ej40PByWbNbmKlYzw5ZXFbu4buBpcuYXD9YPnKzfT4lc0fYzCnjK/61rRbWsGEoWxJ
         hDWQ4TaLYiHAuFgcSCRbiabFjLxcPPQRnjuC6EkxIBgxFcmh8qqUrdcvfWQsSG6uJz
         HwQYFZjWlxAzBsWgJefMvKmTbNO4bQtS6Vn4Cz6XD5pmUIS8NYT8VxInQtmhN2vGhU
         H24X+FW/Md8gQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Martijn Coenen <maco@android.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 028/130] binder: change error code from postive to negative in binder_transaction
Date:   Tue, 22 Dec 2020 21:16:31 -0500
Message-Id: <20201223021813.2791612-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index b62b1ab6bb699..6091a3e20506d 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3107,7 +3107,7 @@ static void binder_transaction(struct binder_proc *proc,
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

