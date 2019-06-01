Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B48531E07
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbfFANdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbfFANYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:24:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB403264C3;
        Sat,  1 Jun 2019 13:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395462;
        bh=FSI2aQNv3ltYE6uawZI59HSVPdmf3g/QpBr65EX3ngs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zK+Vl7F7+GGDHfxsC+DKIBOo1T1sczwk5lGGBN/2XAGTAF3hrWz6yWJxy26iXcjKp
         FVg+wQaxBZFJo91aFslSiN7sLMY2izFRWeaSeabDM2CaVOr6JIYPuP49pOV4ydyC3L
         8UakgtXHfC4G40e87+yukln3Byp4OATcKsPqeoSw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Pavel Emelyanov <xemul@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 13/99] kernel/sys.c: prctl: fix false positive in validate_prctl_map()
Date:   Sat,  1 Jun 2019 09:22:20 -0400
Message-Id: <20190601132346.26558-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132346.26558-1-sashal@kernel.org>
References: <20190601132346.26558-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

[ Upstream commit a9e73998f9d705c94a8dca9687633adc0f24a19a ]

While validating new map we require the @start_data to be strictly less
than @end_data, which is fine for regular applications (this is why this
nit didn't trigger for that long).  These members are set from executable
loaders such as elf handers, still it is pretty valid to have a loadable
data section with zero size in file, in such case the start_data is equal
to end_data once kernel loader finishes.

As a result when we're trying to restore such programs the procedure fails
and the kernel returns -EINVAL.  From the image dump of a program:

 | "mm_start_code": "0x400000",
 | "mm_end_code": "0x8f5fb4",
 | "mm_start_data": "0xf1bfb0",
 | "mm_end_data": "0xf1bfb0",

Thus we need to change validate_prctl_map from strictly less to less or
equal operator use.

Link: http://lkml.kernel.org/r/20190408143554.GY1421@uranus.lan
Fixes: f606b77f1a9e3 ("prctl: PR_SET_MM -- introduce PR_SET_MM_MAP operation")
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrey Vagin <avagin@gmail.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e25ec93aea221..ab96b98823473 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1861,7 +1861,7 @@ static int validate_prctl_map(struct prctl_mm_map *prctl_map)
 	((unsigned long)prctl_map->__m1 __op				\
 	 (unsigned long)prctl_map->__m2) ? 0 : -EINVAL
 	error  = __prctl_check_order(start_code, <, end_code);
-	error |= __prctl_check_order(start_data, <, end_data);
+	error |= __prctl_check_order(start_data,<=, end_data);
 	error |= __prctl_check_order(start_brk, <=, brk);
 	error |= __prctl_check_order(arg_start, <=, arg_end);
 	error |= __prctl_check_order(env_start, <=, env_end);
-- 
2.20.1

