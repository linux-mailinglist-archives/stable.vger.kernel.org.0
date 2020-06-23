Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992B5205DC3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389409AbgFWUQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389167AbgFWUQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DE2D20E65;
        Tue, 23 Jun 2020 20:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943386;
        bh=ED7Xq0AwfAy+9nyXUotzKpXX9MDzfaoz5X1aK7Sr04c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSXXW+aJYEc7RVotMjnqd+0B/YO2Uxf/45c2crr7KiQT6/UGgmvGWQVe4wpqpVilz
         2PQdcc9l7n9/nGp2e0CS53gcrO/TkL9ptOPCAnCBelIHuXG5iP+e4KJUDYYP33MYS2
         MEOtq+lAkDE/860apkbydtAXulLlJiIcdyHWU+wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Alexander Fomichev <fomichev.ru@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 341/477] NTB: ntb_tool: reading the link file should not end in a NULL byte
Date:   Tue, 23 Jun 2020 21:55:38 +0200
Message-Id: <20200623195423.658932726@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 912e12813dd03c602e4922fc34709ec4d4380cf0 ]

When running ntb_test this warning is issued:

./ntb_test.sh: line 200: warning: command substitution: ignored null
byte in input

This is caused by the kernel returning one more byte than is necessary
when reading the link file.

Reduce the number of bytes read back to 2 as it was before the
commit that regressed this.

Fixes: 7f46c8b3a552 ("NTB: ntb_tool: Add full multi-port NTB API support")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Allen Hubbe <allenbh@gmail.com>
Tested-by: Alexander Fomichev <fomichev.ru@gmail.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_tool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ntb/test/ntb_tool.c b/drivers/ntb/test/ntb_tool.c
index 9eaeb221d9802..b7bf3f863d79b 100644
--- a/drivers/ntb/test/ntb_tool.c
+++ b/drivers/ntb/test/ntb_tool.c
@@ -504,7 +504,7 @@ static ssize_t tool_peer_link_read(struct file *filep, char __user *ubuf,
 	buf[1] = '\n';
 	buf[2] = '\0';
 
-	return simple_read_from_buffer(ubuf, size, offp, buf, 3);
+	return simple_read_from_buffer(ubuf, size, offp, buf, 2);
 }
 
 static TOOL_FOPS_RDWR(tool_peer_link_fops,
@@ -1690,4 +1690,3 @@ static void __exit tool_exit(void)
 	debugfs_remove_recursive(tool_dbgfs_topdir);
 }
 module_exit(tool_exit);
-
-- 
2.25.1



