Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2B83CE165
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349194AbhGSPZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347286AbhGSPSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:18:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC4A761412;
        Mon, 19 Jul 2021 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710296;
        bh=x+P2Do7ryklMpG80dXcyjkEdqfS8QeylccWxHEDQ6Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gN6UnKlVwi3rwloPhvCT5mddl8c9bZvT2m/oOMa0TTuqY76it+c6YfFEzLMQRgnL/
         fQIEwK/1K330X4cF3aWHVL9NL6EobjZNIQBjL18xqiMaVzWZZeA/yGLGvP/mkOz38F
         IQMxYv78VuPtK8yQcHaca5WzjFmZrGRV3Kj1+deE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        anton.ivanov@cambridgegreys.com,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/243] um: fix error return code in winch_tramp()
Date:   Mon, 19 Jul 2021 16:53:07 +0200
Message-Id: <20210719144946.005225439@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit ccf1236ecac476d9d2704866d9a476c86e387971 ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 89df6bfc0405 ("uml: DEBUG_SHIRQ fixes")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-By: anton.ivanov@cambridgegreys.com
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/chan_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index d8845d4aac6a..6040817c036f 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -256,7 +256,8 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 		goto out_close;
 	}
 
-	if (os_set_fd_block(*fd_out, 0)) {
+	err = os_set_fd_block(*fd_out, 0);
+	if (err) {
 		printk(UM_KERN_ERR "winch_tramp: failed to set thread_fd "
 		       "non-blocking.\n");
 		goto out_close;
-- 
2.30.2



