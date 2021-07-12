Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DB63C48AA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbhGLGkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237370AbhGLGjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2135761179;
        Mon, 12 Jul 2021 06:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071705;
        bh=m3zx+ceVEdckWgNJJueuh3O9BRsErHXlMTL9Bs9H3U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fp9dSWiNL0fSDteD4eKjRzggOd+Wlp22Ycwg/3q9vxh3ShxAMpx7pV6WSa4vxykr0
         n+PfG8Fb5zUro6kgxksvS2LwRHtSn8QEx5c2n88od3nihrZQqZIhBL2xwDoisiqHmN
         6kymeAtYgDQ1W8CZ1whvY0NBfifkwpb3KdavofM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/593] drivers: hv: Fix missing error code in vmbus_connect()
Date:   Mon, 12 Jul 2021 08:05:43 +0200
Message-Id: <20210712060903.155930625@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 9de6655cc5a6a1febc514465c87c24a0e96d8dba ]

Eliminate the follow smatch warning:

drivers/hv/connection.c:236 vmbus_connect() warn: missing error code
'ret'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1621940321-72353-1-git-send-email-jiapeng.chong@linux.alibaba.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 11170d9a2e1a..bfd7f00a59ec 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -229,8 +229,10 @@ int vmbus_connect(void)
 	 */
 
 	for (i = 0; ; i++) {
-		if (i == ARRAY_SIZE(vmbus_versions))
+		if (i == ARRAY_SIZE(vmbus_versions)) {
+			ret = -EDOM;
 			goto cleanup;
+		}
 
 		version = vmbus_versions[i];
 		if (version > max_version)
-- 
2.30.2



