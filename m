Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997B81F2ADF
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgFIAMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730439AbgFHXTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B22242087E;
        Mon,  8 Jun 2020 23:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658378;
        bh=9ARbGD5hH1cGXAdbi3g8ZxYL3XHkazo9g99L1YSsr3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buIiLcnwfzkiYMldM9PanY7xlFRAEuvLQc1n+ltcp2ik/Kl2KVPfyf6uGpW+fKlxV
         5IsMdJaqNb7PUk04zY1ov7uiJiWgFFoaI/m91m5VDp3HM/vCU7MlLBcSb1xbVLXXD9
         R+XPIPN0+q+MTRt1VlbZTx5FQNA4th4uJfcN/leo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 040/175] kgdb: Prevent infinite recursive entries to the debugger
Date:   Mon,  8 Jun 2020 19:16:33 -0400
Message-Id: <20200608231848.3366970-40-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

