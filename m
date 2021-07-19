Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA2D3CE35F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbhGSPhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347323AbhGSPfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C30661457;
        Mon, 19 Jul 2021 16:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711129;
        bh=M6UPGWBZua8uVdgs9rcujGlz0P9agDbxYeYR0nvMEy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvWH8WwrjQXUKlezhdg6dtTzjNmnNqi769eKm9a22wHk9EseTtb+8Me1TPJsSSXIs
         /Y2LfQivl4EkOuxj4qD2xKdih71YJYqClg5kfK33KAUqsYZ4AW5FOKl6bJkNUQC4J8
         q+rH5L1419IufdJxdnbkLm++V0MIZX3WQXhx/ptY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jon Mediero <jmdr@disroot.org>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 205/351] module: correctly exit module_kallsyms_on_each_symbol when fn() != 0
Date:   Mon, 19 Jul 2021 16:52:31 +0200
Message-Id: <20210719144951.750512944@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 927d46cb8eb9..0b850188419a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4425,9 +4425,10 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
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



