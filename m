Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358D24D8D7
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfFTSCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfFTSCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:02:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 304C82083B;
        Thu, 20 Jun 2019 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053763;
        bh=cpxNgLArNb8oHMJEcTs2Z8dA52nkho/h95uANgoU0bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkNV/4XtzGikNMw3hZMw3sxK/uIZSingAkvoc1oZsA8ByukQJ8dbJjKJHqwVXZgOy
         jBiZzj5uj3Adi1iRIRKAAL1FP43+1OewDvVhXnGtADSff3jeoSela8ZILdnrhRUIDF
         tuVlZEL3ZHYkqj73kmKQ0qRBBUFH2Bnk2x05B6Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Pavel Emelyanov <xemul@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 011/117] kernel/sys.c: prctl: fix false positive in validate_prctl_map()
Date:   Thu, 20 Jun 2019 19:55:45 +0200
Message-Id: <20190620174352.658655788@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 6c4e9b533258..157277cbf83a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1762,7 +1762,7 @@ static int validate_prctl_map(struct prctl_mm_map *prctl_map)
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



