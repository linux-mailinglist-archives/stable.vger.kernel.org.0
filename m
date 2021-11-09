Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB2544B6AD
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343703AbhKIW3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:29:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344377AbhKIW0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:26:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D25876108C;
        Tue,  9 Nov 2021 22:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496383;
        bh=wUtuqPafkjHuIBSa8o+gQLFE+TdhXk32F5NW/Iv+NVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRj+lozdHJWEAMq0KvOwyGZvJfb+CnRhqx5FkI375EKwx+nRaL9I23lC0ypmV470t
         Gg5LiqR7nXBJA+VdeSJPLRlai9C+SU7RY/XerNQWFVXyNOrDmXhl8W1BNmOOsMoUyv
         kcXUd/vTH50mHiTQQ2k79Ie6Cni6dAWRoakzDPhP7ckxaUyHm3/FyRVYRsMcaw62jM
         5wkvjUAI5TjiJ+MG7+FfyOMfn9GSwCbMhi4stJBMvJTzJI88mIrOeku9O1sEn9/qTt
         3F7ZCL/LQikGl8YDp1Pg7VOMNuBxtaCXNJcl16+iZqVYXL4UMK2yqANMFdZlBtdkxv
         Q0s8Qz4fElxIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 21/75] usb: typec: tipd: Remove WARN_ON in tps6598x_block_read
Date:   Tue,  9 Nov 2021 17:18:11 -0500
Message-Id: <20211109221905.1234094-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit b7a0a63f3fed57d413bb857de164ea9c3984bc4e ]

Calling tps6598x_block_read with a higher than allowed len can be
handled by just returning an error. There's no need to crash systems
with panic-on-warn enabled.

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20210914140235.65955-3-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index ea4cc0a6e40cc..97f50f301f13b 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -117,7 +117,7 @@ tps6598x_block_read(struct tps6598x *tps, u8 reg, void *val, size_t len)
 	u8 data[TPS_MAX_LEN + 1];
 	int ret;
 
-	if (WARN_ON(len + 1 > sizeof(data)))
+	if (len + 1 > sizeof(data))
 		return -EINVAL;
 
 	if (!tps->i2c_protocol)
-- 
2.33.0

