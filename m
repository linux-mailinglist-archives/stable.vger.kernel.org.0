Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570503290A0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhCAULq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238575AbhCAUCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:02:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2C4B6538F;
        Mon,  1 Mar 2021 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621450;
        bh=ZN3zUYvVxiGzRv71wxmn3f2ONDm7+sgHoC/pGjBdXjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObczuXDRcjwRcewpNA11zjsC8ngsr+JVmEB2+XbqzDXjPtgDodkmFBMWY7BZ2+6MQ
         pzZnEBl457jpdwFdJod3nJ0LVsu7aX1ljPD0jAqg8Ac68fQ/zhxhPklp0J4zsRoTbq
         w3Znl5n9FNfI77WMjuGpBT7b1icHFx8RMnawuaN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 520/775] device-dax: Fix default return code of range_parse()
Date:   Mon,  1 Mar 2021 17:11:28 +0100
Message-Id: <20210301161227.222066572@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>

[ Upstream commit 7323fb22f05ff1d20498d267828870a5fbbaebd6 ]

The return value of range_parse() indicates the size when it is
positive.  The error code should be negative.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20210126021331.1059933-1-ruansy.fnst@cn.fujitsu.com
Reported-by: Zhang Qilong <zhangqilong3@huawei.com>
Fixes: 8490e2e25b5a ("device-dax: add a range mapping allocation attribute")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 737b207c9e30d..3003558c1a8bb 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1038,7 +1038,7 @@ static ssize_t range_parse(const char *opt, size_t len, struct range *range)
 {
 	unsigned long long addr = 0;
 	char *start, *end, *str;
-	ssize_t rc = EINVAL;
+	ssize_t rc = -EINVAL;
 
 	str = kstrdup(opt, GFP_KERNEL);
 	if (!str)
-- 
2.27.0



