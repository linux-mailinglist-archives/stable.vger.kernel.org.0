Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBC838EFB2
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbhEXP7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234644AbhEXP6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 191A36195B;
        Mon, 24 May 2021 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871046;
        bh=nb5gPHQ0lc71Pv8hxVx6JmpASmurqXzUg7X9LXFRH3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrUFbH4pfx6eO8PIxAZSeAESaV/PP4oRu14hmh98RPir2OStr5llSFrErFj30bjN+
         R/s4JiCtL1zPNkUO+lndtzrGgSDBhgpvCjmJ0UGPPh8DjWkMAqRX7B2Nma5hOJOIT6
         XbvuHQ18R/otvPjR4sXKguiD218MyRhZzobogOAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 004/127] habanalabs/gaudi: Fix a potential use after free in gaudi_memset_device_memory
Date:   Mon, 24 May 2021 17:25:21 +0200
Message-Id: <20210524152335.006868701@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 115726c5d312b462c9d9931ea42becdfa838a076 ]

Our code analyzer reported a uaf.

In gaudi_memset_device_memory, cb is get via hl_cb_kernel_create()
with 2 refcount.
If hl_cs_allocate_job() failed, the execution runs into release_cb
branch. One ref of cb is dropped by hl_cb_put(cb) and could be freed
if other thread also drops one ref. Then cb is used by cb->id later,
which is a potential uaf.

My patch add a variable 'id' to accept the value of cb->id before the
hl_cb_put(cb) is called, to avoid the potential uaf.

Fixes: 423815bf02e25 ("habanalabs/gaudi: remove PCI access to SM block")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 9152242778f5..ecdedd87f8cc 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -5546,6 +5546,7 @@ static int gaudi_memset_device_memory(struct hl_device *hdev, u64 addr,
 	struct hl_cs_job *job;
 	u32 cb_size, ctl, err_cause;
 	struct hl_cb *cb;
+	u64 id;
 	int rc;
 
 	cb = hl_cb_kernel_create(hdev, PAGE_SIZE, false);
@@ -5612,8 +5613,9 @@ static int gaudi_memset_device_memory(struct hl_device *hdev, u64 addr,
 	}
 
 release_cb:
+	id = cb->id;
 	hl_cb_put(cb);
-	hl_cb_destroy(hdev, &hdev->kernel_cb_mgr, cb->id << PAGE_SHIFT);
+	hl_cb_destroy(hdev, &hdev->kernel_cb_mgr, id << PAGE_SHIFT);
 
 	return rc;
 }
-- 
2.30.2



