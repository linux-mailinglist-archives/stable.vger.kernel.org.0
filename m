Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D014714810A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390383AbgAXLQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390381AbgAXLQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:33 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72C1B2087E;
        Fri, 24 Jan 2020 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864593;
        bh=MpPqerH2hwZcvYMCl4E0E6RfTyJ9Ad/Av0H0g/6jTZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fq6Ljtsjct/vDhVsOCzuMjdUREBOVP75WLD81uz0SBuhXEE5SnbdADy5taGE+V+6f
         lO3ikWVnS0ISmTMXDofn16KSXv94YP0GEYqXLmpxXgHZrryyFm0pFfAhSyB2AF8hAE
         nqTT1oISaK2+o4tkLQci/GsrZJxZha/o0lMJEHL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Deepak Rawat <drawat@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 296/639] drm/vmwgfx: Remove set but not used variable restart
Date:   Fri, 24 Jan 2020 10:27:46 +0100
Message-Id: <20200124093123.983402506@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit b2130cca9c8db5073b71d832da2a6c8311a8f3bb ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c: In function 'vmw_cmdbuf_work_func':
drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c:514:7: warning:
 variable 'restart' set but not used [-Wunused-but-set-variable]

It not used any more after commit dc366364c4ef ("drm/vmwgfx: Fix multiple
command buffer context use")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Deepak Rawat <drawat@vmware.com>
Signed-off-by: Deepak Rawat <drawat@vmware.com>
Fixes: dc366364c4ef ("drm/vmwgfx: Fix multiple command buffer context use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
index e7e4655d3f36b..ce1ad7cd78996 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
@@ -511,17 +511,14 @@ static void vmw_cmdbuf_work_func(struct work_struct *work)
 		container_of(work, struct vmw_cmdbuf_man, work);
 	struct vmw_cmdbuf_header *entry, *next;
 	uint32_t dummy;
-	bool restart[SVGA_CB_CONTEXT_MAX];
 	bool send_fence = false;
 	struct list_head restart_head[SVGA_CB_CONTEXT_MAX];
 	int i;
 	struct vmw_cmdbuf_context *ctx;
 	bool global_block = false;
 
-	for_each_cmdbuf_ctx(man, i, ctx) {
+	for_each_cmdbuf_ctx(man, i, ctx)
 		INIT_LIST_HEAD(&restart_head[i]);
-		restart[i] = false;
-	}
 
 	mutex_lock(&man->error_mutex);
 	spin_lock(&man->lock);
@@ -533,7 +530,6 @@ static void vmw_cmdbuf_work_func(struct work_struct *work)
 		const char *cmd_name;
 
 		list_del_init(&entry->list);
-		restart[entry->cb_context] = true;
 		global_block = true;
 
 		if (!vmw_cmd_describe(header, &error_cmd_size, &cmd_name)) {
-- 
2.20.1



