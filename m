Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D637360D78
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhDOPDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235071AbhDOPAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2393A61410;
        Thu, 15 Apr 2021 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498575;
        bh=97eCXTqfY9sOzbn9nTyUm35whMSCoyGUofXd3CkpugE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRb8IOtMGsvcl8t7gDhkTy3VzjKm1cd9DxDM8tV6niG9ioriKIVw+h1HQrD+Z8W9I
         gycR7KaiCQY8tLvrwrQ4AoXa+jOfB/lnBmkWlEFhfq9a9BwWAUawZyLY+5RKJJFROr
         iAIf985P7+pHRGjwNUv3TBhHxLeFDBRvbcVOOWhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/18] interconnect: core: fix error return code of icc_link_destroy()
Date:   Thu, 15 Apr 2021 16:47:54 +0200
Message-Id: <20210415144413.103165299@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
References: <20210415144413.055232956@linuxfoundation.org>
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
index c498796adc07..e579b3633a84 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -704,6 +704,8 @@ int icc_link_destroy(struct icc_node *src, struct icc_node *dst)
 		       GFP_KERNEL);
 	if (new)
 		src->links = new;
+	else
+		ret = -ENOMEM;
 
 out:
 	mutex_unlock(&icc_lock);
-- 
2.30.2



