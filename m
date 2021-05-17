Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABFE38335A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbhEQO5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242312AbhEQOzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9982E613CD;
        Mon, 17 May 2021 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261495;
        bh=Jrv9Yp2QvwLMgW8cv6Bp0zXQBBKYoSWxv5Rz4fxudts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RudhLZo3Fl5GKoUwpuhbKeDf7x9aPO98ARUGd5A67xtcG1nKQ4SU54XzrMUPiWETR
         /Mowx7vYNOrDJqwuaCSO0Lh7QEBaGbbwyIFewNMX4E/69MqGDxyU8+c09Zgd8KvMDh
         gJ0AbqGmZTDwtBpMjGHG+kboG0vgue6A9w7w/mgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/141] thermal: thermal_of: Fix error return code of thermal_of_populate_bind_params()
Date:   Mon, 17 May 2021 16:01:44 +0200
Message-Id: <20210517140244.519069398@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
 drivers/thermal/of-thermal.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index dc5093be553e..68d0c181ec7b 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -712,14 +712,17 @@ static int thermal_of_populate_bind_params(struct device_node *np,
 
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



