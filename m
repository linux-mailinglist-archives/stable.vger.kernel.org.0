Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410E9383331
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbhEQOz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240325AbhEQOwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:52:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E936198C;
        Mon, 17 May 2021 14:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261434;
        bh=KhNrqEckrBWrYbxQW5GdiVG9iEMlzpG4HJaVP3aEKtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrCN/YjM8VcgDO1x5m857xz92m8imDH5e+YKGzFgFmEKX+cejBXE6O3pMaz5hghav
         zN9Ohpj75d6vW7s8SZFMfArJlKPGcB04hRQOLrRzmk7p+VKhv0G6GptTIvzgXL37l+
         cho9rmbek7n0TyP79YqrleX0e3Iq1px2jU4bDSik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 113/329] thermal: thermal_of: Fix error return code of thermal_of_populate_bind_params()
Date:   Mon, 17 May 2021 16:00:24 +0200
Message-Id: <20210517140305.930107320@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 45c7eaeb29d67224db4ba935deb575586a1fda09 ]

When kcalloc() returns NULL to __tcbp or of_count_phandle_with_args()
returns zero or -ENOENT to count, no error return code of
thermal_of_populate_bind_params() is assigned.
To fix these bugs, ret is assigned with -ENOMEM and -ENOENT in these
cases, respectively.

Fixes: a92bab8919e3 ("of: thermal: Allow multiple devices to share cooling map")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210310122423.3266-1-baijiaju1990@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 69ef12f852b7..5b76f9a1280d 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -704,14 +704,17 @@ static int thermal_of_populate_bind_params(struct device_node *np,
 
 	count = of_count_phandle_with_args(np, "cooling-device",
 					   "#cooling-cells");
-	if (!count) {
+	if (count <= 0) {
 		pr_err("Add a cooling_device property with at least one device\n");
+		ret = -ENOENT;
 		goto end;
 	}
 
 	__tcbp = kcalloc(count, sizeof(*__tcbp), GFP_KERNEL);
-	if (!__tcbp)
+	if (!__tcbp) {
+		ret = -ENOMEM;
 		goto end;
+	}
 
 	for (i = 0; i < count; i++) {
 		ret = of_parse_phandle_with_args(np, "cooling-device",
-- 
2.30.2



