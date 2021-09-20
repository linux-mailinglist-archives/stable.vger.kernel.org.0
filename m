Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01685411BC7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhITRCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhITRAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A6DB613E8;
        Mon, 20 Sep 2021 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156774;
        bh=r7upxbZeP6CDiJZHihDvXCwZVQrHHrNKyEz9A57WVqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fg1jpUEi4KGMNcWVwwFpHES7yVFAS/yKpu0xttoxojoHCKt84nzupqQD0U7TTBm6S
         zxmGgAEe6FsxYLYg5b/NoGrgcISUplB5Gd5cB2yLFEr/ITXXtyZvYzYDvSjjaQHQHq
         hdk7n8l0AqU/rX8vcg6YGAQ8sGQnT0R595Saq7ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 080/175] ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()
Date:   Mon, 20 Sep 2021 18:42:09 +0200
Message-Id: <20210920163920.679064153@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit fd6729ec534cffbbeb3917761e6d1fe6a412d3fe ]

This error path is unlikely because of it checked for NULL and
returned -ENOMEM earlier in the function.  But it should return
an error code here as well if we ever do hit it because of a
race condition or something.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210813113438.GB30697@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 73eab12cb3bd..9c2d26b12b69 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2513,8 +2513,10 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 		goto free_data_skb;
 
 	for (index = 0; index < num_pri_streams; index++) {
-		if (WARN_ON(!data_sync_bufs[index].skb))
+		if (WARN_ON(!data_sync_bufs[index].skb)) {
+			ret = -ENOMEM;
 			goto free_data_skb;
+		}
 
 		ep_id = ath6kl_ac2_endpoint_id(wmi->parent_dev,
 					       data_sync_bufs[index].
-- 
2.30.2



