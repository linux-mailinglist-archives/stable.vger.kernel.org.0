Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119A745C29A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349832AbhKXNap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:30:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350774AbhKXN2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 302A561167;
        Wed, 24 Nov 2021 12:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758271;
        bh=ISt9HPXrYaaW0N82FruUv60OvQHSwzSStOJjuRQJ4DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WqHnhO4/nWvRRxqiIWv9SOb2L/wexmqMb3iFvgMOvE0piMQB91mF5Dlp7/hX8SDd
         C9suq2vXGoPLLm8sSYh7Jz5Cev9DQ9JgUO6ydne/GY5pjaOIobZUwTXf3sme5D+jjT
         I0smx0W3ngRJUGvz0OQ/YxdXAFyYSlLpHCbwk1p0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sven Peter <sven@svenpeter.dev>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/154] usb: typec: tipd: Remove WARN_ON in tps6598x_block_read
Date:   Wed, 24 Nov 2021 12:56:51 +0100
Message-Id: <20211124115702.874451845@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index 30bfc314b743c..6cb5c8e2c8535 100644
--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -109,7 +109,7 @@ tps6598x_block_read(struct tps6598x *tps, u8 reg, void *val, size_t len)
 	u8 data[TPS_MAX_LEN + 1];
 	int ret;
 
-	if (WARN_ON(len + 1 > sizeof(data)))
+	if (len + 1 > sizeof(data))
 		return -EINVAL;
 
 	if (!tps->i2c_protocol)
-- 
2.33.0



