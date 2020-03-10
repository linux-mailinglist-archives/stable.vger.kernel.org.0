Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D496D17FE18
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgCJMsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbgCJMsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:48:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 613FA2468E;
        Tue, 10 Mar 2020 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844518;
        bh=hdEXpynWFPxkGxPFxK8zhwyo9jTjHRf72xZ9g/yKc/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWeF3k5YfL94OTNlYCAmT78YpOzTcd3ieP/GDMjB2qMxVsf7FupGnE1WumZiQ5yZ3
         qB86Xurbibti4fxIePLdY+SxXQkYYbUWS+IkuiAd6wTGuXIzwBtiEFJ9lfZuYTFnKo
         FemIcyehBK3UCR4AtDtGMA8y1eUTJ8Q1vPco688M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/168] habanalabs: patched cb equals user cb in device memset
Date:   Tue, 10 Mar 2020 13:37:47 +0100
Message-Id: <20200310123637.801901119@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>

[ Upstream commit cf01514c5c6efa2d521d35e68dff2e0674d08e91 ]

During device memory memset, the driver allocates and use a CB (command
buffer). To reuse existing code, it keeps a pointer to the CB in two
variables, user_cb and patched_cb. Therefore, there is no need to "put"
both the user_cb and patched_cb, as it will cause an underflow of the
refcnt of the CB.

Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/goya/goya.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 1e97f6d77e3da..13b39fd97429a 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -4666,8 +4666,6 @@ static int goya_memset_device_memory(struct hl_device *hdev, u64 addr, u64 size,
 
 	rc = goya_send_job_on_qman0(hdev, job);
 
-	hl_cb_put(job->patched_cb);
-
 	hl_debugfs_remove_job(hdev, job);
 	kfree(job);
 	cb->cs_cnt--;
-- 
2.20.1



