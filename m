Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E1137CDBF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbhELQ6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244145AbhELQmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACD8061D22;
        Wed, 12 May 2021 16:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835864;
        bh=JxeUoRHKjT/emeqGlZUaSljOXNtfFEVtz3mTPoyzYoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rzn3FtMOfZ0EFFsmJpDj9/AdTs4Tjl26sOlNrw57N7vz0GXWsUhKEF7OQOlnqKwl7
         Db0aeAsCo9hCYKqW0TZYqRC7uQKJ3akmbaCpAoG5s/VV1LgZPDiEDO+o5LI1PiUG28
         1haifeCogIpg6GTfsdp5A4shqN/1oqTVEaIj5o5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 515/677] rtw88: Fix an error code in rtw_debugfs_set_rsvd_page()
Date:   Wed, 12 May 2021 16:49:21 +0200
Message-Id: <20210512144854.498660821@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c9eaee0c2ec6b1002044fb698cdfb5d9ef4ed28c ]

The sscanf() function returns the number of matches (0 or 1 in this
case).  It doesn't return error codes.  We should return -EINVAL if the
string is invalid

Fixes: c376c1fc87b7 ("rtw88: add h2c command in debugfs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YE8nmatMDBDDWkjq@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 948cb79050ea..e7d51ac9b689 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -270,7 +270,7 @@ static ssize_t rtw_debugfs_set_rsvd_page(struct file *filp,
 
 	if (num != 2) {
 		rtw_warn(rtwdev, "invalid arguments\n");
-		return num;
+		return -EINVAL;
 	}
 
 	debugfs_priv->rsvd_page.page_offset = offset;
-- 
2.30.2



