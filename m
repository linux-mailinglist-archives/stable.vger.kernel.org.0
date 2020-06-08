Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2592B1F295D
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbgFHX7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbgFHXXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:23:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3138F208B3;
        Mon,  8 Jun 2020 23:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658581;
        bh=b6KQFxhpqokwjIfbaMiTMCL6QZY5s08BueXsXwADbsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EogdS4CDRwweCW/LxTmboNMPG6lIu+k9Fl3TmzEmnsIrJtK/H4joN/kdqsPIajMhW
         CkOfxKEKek1Vwq/Wpqkg7WlIIcw98to9Vle9jYI/tagAXtUCg6Gy5gaWoNuYoAUZvL
         oZOCPMKv3v66kNguqtlha+2iYHUbs44bhLwLBtCM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 019/106] kgdb: Prevent infinite recursive entries to the debugger
Date:   Mon,  8 Jun 2020 19:21:11 -0400
Message-Id: <20200608232238.3368589-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
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
index d2799767aab8..6a1dc2613bb9 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -444,6 +444,7 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 
 	if (exception_level > 1) {
 		dump_stack();
+		kgdb_io_module_registered = false;
 		panic("Recursive entry to debugger");
 	}
 
-- 
2.25.1

