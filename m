Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8653637CEA1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345079AbhELRGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236837AbhELQsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:48:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BF4F61E81;
        Wed, 12 May 2021 16:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836148;
        bh=Ye/owjlNIoK0mUKgznSfE5i1P9eBj+sn/vOQXCOxK0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eo/QpnGEvcBN2N8PXLsBLwYCy2ga387w71hahUa2TczvIh9sJMdeY2Jt+wLSKYkv4
         uK8VrfcNay3D01lPoZIh/fpflbuqh4NTkXwjACBBqQhN85ARQYCvmm0UPzVYDhHM4M
         Ud11R8DPK63nRoSM0TwIaQICtopP7cbAYZbWo2B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 629/677] wlcore: Fix buffer overrun by snprintf due to incorrect buffer size
Date:   Wed, 12 May 2021 16:51:15 +0200
Message-Id: <20210512144858.267040414@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a9a4c080deb33f44e08afe35f4ca4bb9ece89f4e ]

The size of the buffer than can be written to is currently incorrect, it is
always the size of the entire buffer even though the snprintf is writing
as position pos into the buffer. Fix this by setting the buffer size to be
the number of bytes left in the buffer, namely sizeof(buf) - pos.

Addresses-Coverity: ("Out-of-bounds access")
Fixes: 7b0e2c4f6be3 ("wlcore: fix overlapping snprintf arguments in debugfs")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210419141405.180582-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/debugfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index 715edfa5f89f..a9e13e6d65c5 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -84,7 +84,7 @@ static ssize_t sub## _ ##name## _read(struct file *file,		\
 	wl1271_debugfs_update_stats(wl);				\
 									\
 	for (i = 0; i < len && pos < sizeof(buf); i++)			\
-		pos += snprintf(buf + pos, sizeof(buf),			\
+		pos += snprintf(buf + pos, sizeof(buf) - pos,		\
 			 "[%d] = %d\n", i, stats->sub.name[i]);		\
 									\
 	return wl1271_format_buffer(userbuf, count, ppos, "%s", buf);	\
-- 
2.30.2



