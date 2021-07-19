Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B823CE4F4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346477AbhGSPrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349483AbhGSPpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6A9761404;
        Mon, 19 Jul 2021 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711907;
        bh=Hmk2V+O0nQ1niaTHwAzt3793THZgc5AyJKvgRun1ZJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGC/OHDB+cDudzpYk3j2B2AzPU28WmQAGADt4RBen52aUx7g4HJD0iMJJJHIvRekL
         /JEcd1JvaHNvZGTrPcyeX2+PAFGlJe7Fm6zxZiGwUXeTEJovfh8ZxT6uMMJ2CVjCol
         H7jOg5ZSp1TZ3RLYYWKjeTnxIjujIR+4V9chu0pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jon Mediero <jmdr@disroot.org>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 176/292] module: correctly exit module_kallsyms_on_each_symbol when fn() != 0
Date:   Mon, 19 Jul 2021 16:53:58 +0200
Message-Id: <20210719144948.284861956@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Mediero <jmdr@disroot.org>

[ Upstream commit 2c0f0f3639562d6e38ee9705303c6457c4936eac ]

Commit 013c1667cf78 ("kallsyms: refactor
{,module_}kallsyms_on_each_symbol") replaced the return inside the
nested loop with a break, changing the semantics of the function: the
break only exits the innermost loop, so the code continues iterating the
symbols of the next module instead of exiting.

Fixes: 013c1667cf78 ("kallsyms: refactor {,module_}kallsyms_on_each_symbol")
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Jon Mediero <jmdr@disroot.org>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 260d6f3f6d68..f928037a1b56 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4410,9 +4410,10 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 			ret = fn(data, kallsyms_symbol_name(kallsyms, i),
 				 mod, kallsyms_symbol_value(sym));
 			if (ret != 0)
-				break;
+				goto out;
 		}
 	}
+out:
 	mutex_unlock(&module_mutex);
 	return ret;
 }
-- 
2.30.2



