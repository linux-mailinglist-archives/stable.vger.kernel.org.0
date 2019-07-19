Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939B06DCBA
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389391AbfGSENt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389375AbfGSENt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:13:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25FFD21872;
        Fri, 19 Jul 2019 04:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509628;
        bh=8ZI5KHIikTg8AUBhIZ0V00NlYlYYAULFOpP7aV3KTBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjqbAk0hy+qlG+8lFQEs4ZstNV1Km+Ne5Yyp0ehWeRFjZhndW5jl49wl6tz74f2l0
         qCa6K3pZ6uQOwKA94IEml8Y4eh9h5V6vUNNoZltDuGzKOar9bf7uykRoIgxNuonVoz
         b15enSRALng9sLzAa0NPPRZJMgUh2M3BM/U88Kro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 26/45] mfd: arizona: Fix undefined behavior
Date:   Fri, 19 Jul 2019 00:12:45 -0400
Message-Id: <20190719041304.18849-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041304.18849-1-sashal@kernel.org>
References: <20190719041304.18849-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5da6cbcd2f395981aa9bfc571ace99f1c786c985 ]

When the driver is used with a subdevice that is disabled in the
kernel configuration, clang gets a little confused about the
control flow and fails to notice that n_subdevs is only
uninitialized when subdevs is NULL, and we check for that,
leading to a false-positive warning:

drivers/mfd/arizona-core.c:1423:19: error: variable 'n_subdevs' is uninitialized when used here
      [-Werror,-Wuninitialized]
                              subdevs, n_subdevs, NULL, 0, NULL);
                                       ^~~~~~~~~
drivers/mfd/arizona-core.c:999:15: note: initialize the variable 'n_subdevs' to silence this warning
        int n_subdevs, ret, i;
                     ^
                      = 0

Ideally, we would rearrange the code to avoid all those early
initializations and have an explicit exit in each disabled case,
but it's much easier to chicken out and add one more initialization
here to shut up the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 41767f7239bb..0556a9749dbe 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1038,7 +1038,7 @@ int arizona_dev_init(struct arizona *arizona)
 	unsigned int reg, val, mask;
 	int (*apply_patch)(struct arizona *) = NULL;
 	const struct mfd_cell *subdevs = NULL;
-	int n_subdevs, ret, i;
+	int n_subdevs = 0, ret, i;
 
 	dev_set_drvdata(arizona->dev, arizona);
 	mutex_init(&arizona->clk_lock);
-- 
2.20.1

