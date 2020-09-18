Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4267526F046
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgIRCmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbgIRCLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C0FD235F9;
        Fri, 18 Sep 2020 02:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395066;
        bh=2gWGb64OjKY/6l98uZGTJwJF9P96AGvSafutQLgCiGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyXidKc+ipm67ucYVVKtjLPyhpyfKBOYq/V3U1aLgPifGmF62g7dbo1EnaXwhQgGj
         mN9ckB5wBV/sBXD/QrptIXPqvoNjKD4jMyZm6xJJs7T3ZNWxdvIHXocsz6jVUP37gY
         oDHTBnPODZXjzwQfLkdLpN0ft/AbRLKZXg27FPZc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 152/206] sparc64: vcc: Fix error return code in vcc_probe()
Date:   Thu, 17 Sep 2020 22:07:08 -0400
Message-Id: <20200918020802.2065198-152-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit ff62255a2a5c1228a28f2bb063646f948115a309 ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20200427122415.47416-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vcc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/vcc.c b/drivers/tty/vcc.c
index 58b454c34560a..10a832a2135e2 100644
--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -604,6 +604,7 @@ static int vcc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	port->index = vcc_table_add(port);
 	if (port->index == -1) {
 		pr_err("VCC: no more TTY indices left for allocation\n");
+		rv = -ENOMEM;
 		goto free_ldc;
 	}
 
-- 
2.25.1

