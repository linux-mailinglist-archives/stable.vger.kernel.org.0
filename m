Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B152C44B7E8
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344852AbhKIWjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:39:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344691AbhKIWgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:36:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66D7861269;
        Tue,  9 Nov 2021 22:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496560;
        bh=tLnqBrFPv3j6HEPrJXTcSeZBMN/5nvOuD+6y1xuxvgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObtpfrrKGx19PolRAFRbXUV4NUCSRGJhestBRKJhgf4DyirdKgajBCDEYAQ00DlRw
         bC98FL9X5U4E4N7UvE2T0ET5/MnQK1s2ojQhEHn3vm1K7pD3N2v/+qMoWiMCLYWg/1
         hwwJyCNPJ9HJSHipcuaMB4VCrBFYngKkqHrI5zJthhoD0aj+ny0A4qWqF+T5dSbVov
         gIcCqyRowBW05G0I0fdhV8WrVKsdWJqOxEjCbGQNgkV6vOm2mC/QiUC4gYvSwWr2mt
         qrc1hLCbNcSbgQ4aU9QSnKYNUEJUSfw4Iz6wnSl/XhVK5GCFwGf9jkGqaVwxR+ZUrv
         b4MNhWWdwHYQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/30] usb: typec: tipd: Remove WARN_ON in tps6598x_block_read
Date:   Tue,  9 Nov 2021 17:22:03 -0500
Message-Id: <20211109222224.1235388-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222224.1235388-1-sashal@kernel.org>
References: <20211109222224.1235388-1-sashal@kernel.org>
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
index a38d1409f15b7..67bebee693301 100644
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

