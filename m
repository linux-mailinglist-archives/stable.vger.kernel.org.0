Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5852B44B772
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245679AbhKIWfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344744AbhKIWcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5837D61AA5;
        Tue,  9 Nov 2021 22:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496492;
        bh=ISt9HPXrYaaW0N82FruUv60OvQHSwzSStOJjuRQJ4DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5KkyDGlH+/MX68tJpvinGpHnfQkCy8bC4ZFmimViYuztBH7ybkEuYVlPVU9s3Uk9
         2/p8IY7ewS6CJdUW18O2JxORX+PgTQrn96Z2/iMnPnYseSDgmstA+GqTcDIvZTjcoI
         Z23ZgUMmgigK7R8e6+XV/Ey3XheZcwKkdR3gsQ07ZuiHnuv2h/TASmk4uLGuvyrsqa
         jFOBiZi4hk644wn4GC41ttUe5O6yujquf8SZ6SeJ+WiUbEKz1Wllgegn6uHH4mmbZW
         HwmhpqZKTz7EuSYSnZq3B3GGrQnPHC8Vjr1XC+dJBI6bH70dOimtx6PSKIY9mb5Wxz
         mOH14ag+qlGvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/50] usb: typec: tipd: Remove WARN_ON in tps6598x_block_read
Date:   Tue,  9 Nov 2021 17:20:30 -0500
Message-Id: <20211109222103.1234885-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
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

