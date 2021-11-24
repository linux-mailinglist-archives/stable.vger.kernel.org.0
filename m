Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8C445C15B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344846AbhKXNR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:17:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347349AbhKXNPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:15:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B36C61AAD;
        Wed, 24 Nov 2021 12:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757848;
        bh=aJhIcq5GpkXnt+6eFeSlj0EGsC3g80aE/6o+d4Y2BiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0CUU8zGAOUfJUjuGGiuO2EKy8mtT2mVFu+E0LAHNwe34nBIXIsuN64Z+x/3J+VU5
         expn3lQfCrUKYPtTvpQmQ/5olcs+GsS+YEGJ7hAQpIt7eQrA8aL5J8pzYWBItvOjOL
         kf9ZJFrlrMRUdjFMurSi3gitbPpTvwbm6XFtjPlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sven Peter <sven@svenpeter.dev>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 264/323] usb: typec: tipd: Remove WARN_ON in tps6598x_block_read
Date:   Wed, 24 Nov 2021 12:57:34 +0100
Message-Id: <20211124115727.798893288@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



