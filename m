Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A622C9AD7
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgLAJBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbgLAJBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:01:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1CEF20671;
        Tue,  1 Dec 2020 09:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813278;
        bh=Iydk144FX0Xn6424CqCVcybGpfiJwRh5rskHhF/g9gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlEHmDd/0oaP5V2H6XRC1hwXm9z94bYfz0a8UTS7DSra1J8idkD27AEegfAJgrqw9
         0ExxOW77JfQcGOiJCdm0KaY7VeQIDKWFj5hwrJaQhT9Ie9j3qgJguA83j0KKX5H2ju
         ANki22v+DucEEZmbZSGL3/BCWarhFCxxSUDwZLek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/57] optee: add writeback to valid memory type
Date:   Tue,  1 Dec 2020 09:53:48 +0100
Message-Id: <20201201084651.213385348@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Miguel Silva <rui.silva@linaro.org>

[ Upstream commit 853735e404244f5496cdb6188c5ed9a0f9627ee6 ]

Only in smp systems the cache policy is setup as write alloc, in
single cpu systems the cache policy is set as writeback and it is
normal memory, so, it should pass the is_normal_memory check in the
share memory registration.

Add the right condition to make it work in no smp systems.

Fixes: cdbcf83d29c1 ("tee: optee: check type of registered shared memory")
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/call.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index a5afbe6dee686..7cb7efe62b011 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -538,7 +538,8 @@ void optee_free_pages_list(void *list, size_t num_entries)
 static bool is_normal_memory(pgprot_t p)
 {
 #if defined(CONFIG_ARM)
-	return (pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC;
+	return (((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC) ||
+		((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEBACK));
 #elif defined(CONFIG_ARM64)
 	return (pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL);
 #else
-- 
2.27.0



