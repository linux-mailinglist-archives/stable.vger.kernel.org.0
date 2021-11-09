Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB5044B843
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345226AbhKIWln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242451AbhKIWjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:39:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1F336152A;
        Tue,  9 Nov 2021 22:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496603;
        bh=aJhIcq5GpkXnt+6eFeSlj0EGsC3g80aE/6o+d4Y2BiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGyVRmDEe7yXoBIHSTLavTWczpNXRwNWBFhRvhVm6OzWmY2TGE9dAzux+jgWq/3+/
         MBqzk347FBMJCsvNPOvYXyV0x3pdolTjlauhXEdDi3JJ1eL+1erj0i3KzQJaMY0l/I
         T7/r4Jw5AAz1i708UflntMBwctf4UeQ2O8aK4/taQQgza9X+/2pCGfHnj2ih1q+uCB
         89D9v1uJcxg7OU2waYZy7laLp9y/d0PijJvCPltp5PHwlt5298zULnc6iG8QY/lBsx
         4fgTqi00Wk4r9g8h+GMQd+xArMig3fBX4BgemNO/8hqz9oFYICgQ/VlYco6ImyqEJT
         4JQdrkXbl3ARw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/21] usb: typec: tipd: Remove WARN_ON in tps6598x_block_read
Date:   Tue,  9 Nov 2021 17:22:56 -0500
Message-Id: <20211109222311.1235686-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222311.1235686-1-sashal@kernel.org>
References: <20211109222311.1235686-1-sashal@kernel.org>
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
 drivers/usb/typec/tps6598x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tps6598x.c b/drivers/usb/typec/tps6598x.c
index 987b8fcfb2aae..a4dd23a8f1954 100644
--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -93,7 +93,7 @@ tps6598x_block_read(struct tps6598x *tps, u8 reg, void *val, size_t len)
 	u8 data[TPS_MAX_LEN + 1];
 	int ret;
 
-	if (WARN_ON(len + 1 > sizeof(data)))
+	if (len + 1 > sizeof(data))
 		return -EINVAL;
 
 	if (!tps->i2c_protocol)
-- 
2.33.0

