Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62633328E41
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbhCAT0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240706AbhCATVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4344764EF0;
        Mon,  1 Mar 2021 17:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619455;
        bh=3deFDwrKRhdBOc4SDHrhoASfKkSjLcrrSCmY1SwCKrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FN1BdQCNvxTK9P87Y1DbTTS+4j/HwAxk/afDLgqu66TuR6mrWRimds62TJiN9UB6c
         cHSzj3mCSbpzkGmO4/peUplKqZLwnnstg8hAlQENBpzHsQE6u74+IY+x9yN17ZQtsf
         MSsWMGn0p32h5ZWUUOpRJUqzH98ktJBPaXzqd0rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 431/663] device-dax: Fix default return code of range_parse()
Date:   Mon,  1 Mar 2021 17:11:19 +0100
Message-Id: <20210301161203.212918760@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index de7b74505e75e..c1d379bd7af33 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1046,7 +1046,7 @@ static ssize_t range_parse(const char *opt, size_t len, struct range *range)
 {
 	unsigned long long addr = 0;
 	char *start, *end, *str;
-	ssize_t rc = EINVAL;
+	ssize_t rc = -EINVAL;
 
 	str = kstrdup(opt, GFP_KERNEL);
 	if (!str)
-- 
2.27.0



