Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AD6360D94
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhDOPDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235326AbhDOPAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FB7461414;
        Thu, 15 Apr 2021 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498622;
        bh=bqcHL98/5DIfVZ4OpfrnQ/Lr5T/8yN1YD9VjwhQTA2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVLKD1gVNkwisOEiMJAB/oKAzuUiqV7zrJl9+NscDnwUOPeYqOcN66RAbaIydqx/8
         h+fpvlQvd3HYt2IUk70+JsMIunh0Y+fWdw+snhSaAAqxYHD6lZ/Q+a90FeM9fKnrL2
         lEa8oZbekY+9Qv6hO+GD0kSpUzbu5lHiKeMHY8xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/25] interconnect: core: fix error return code of icc_link_destroy()
Date:   Thu, 15 Apr 2021 16:47:55 +0200
Message-Id: <20210415144413.213011641@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 715ea61532e731c62392221238906704e63d75b6 ]

When krealloc() fails and new is NULL, no error return code of
icc_link_destroy() is assigned.
To fix this bug, ret is assigned with -ENOMEM hen new is NULL.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20210306132857.17020-1-baijiaju1990@gmail.com
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 5ad519c9f239..8a1e70e00876 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -942,6 +942,8 @@ int icc_link_destroy(struct icc_node *src, struct icc_node *dst)
 		       GFP_KERNEL);
 	if (new)
 		src->links = new;
+	else
+		ret = -ENOMEM;
 
 out:
 	mutex_unlock(&icc_lock);
-- 
2.30.2



