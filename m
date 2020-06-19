Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519E420143B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390125AbgFSPGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391419AbgFSPGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:06:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 577B121835;
        Fri, 19 Jun 2020 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579177;
        bh=9ARbGD5hH1cGXAdbi3g8ZxYL3XHkazo9g99L1YSsr3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hz6uY6QzjtzNawpSslsUN6VRsKQe6kBNBVEfdvCOG0ieubYr1qolVh/cjCqIovoOA
         cMR9ZENQXHeVWyoigvl8yLb8TyasbI1fJnr/vSqaY6L9Pvb0T1Atv3kc9L+Mj3BaQR
         lKYrGxJB34GUXYnyZaSQ3fTZM3GeKxZ9yPUCF8go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/261] kgdb: Prevent infinite recursive entries to the debugger
Date:   Fri, 19 Jun 2020 16:30:48 +0200
Message-Id: <20200619141651.695804315@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 3ca676e4ca60d1834bb77535dafe24169cadacef ]

If we detect that we recursively entered the debugger we should hack
our I/O ops to NULL so that the panic() in the next line won't
actually cause another recursion into the debugger.  The first line of
kgdb_panic() will check this and return.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Link: https://lore.kernel.org/r/20200507130644.v4.6.I89de39f68736c9de610e6f241e68d8dbc44bc266@changeid
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/debug_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index d0d557c0ceff..7d54c7c28054 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -501,6 +501,7 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 
 	if (exception_level > 1) {
 		dump_stack();
+		kgdb_io_module_registered = false;
 		panic("Recursive entry to debugger");
 	}
 
-- 
2.25.1



