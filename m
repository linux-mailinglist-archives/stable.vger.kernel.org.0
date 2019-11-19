Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96070101494
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbfKSFfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728804AbfKSFfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07488206EC;
        Tue, 19 Nov 2019 05:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141718;
        bh=t3smQKcjjFBjbreDgVg9JggXSHRt1WbmMzRz6EoMzU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Od9lUSxn5mGOAJyeYDj3HQnEYHk0IRmolf99ko5HhV94BXg+I+l2IPno8lLymmRJ8
         glYCRjutcCy8ixZOmeF+V9UE3E3BFCOb1BzSvbT3OILsaHEf0s8kyF4WSJ1hz6y79B
         DRCKrfpw96ZkXeC7QCQYNiSRlv1EXJ/B8DUOdbsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 256/422] ipmi: fix return value of ipmi_set_my_LUN
Date:   Tue, 19 Nov 2019 06:17:33 +0100
Message-Id: <20191119051415.576556883@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 060e8fb53fe3455568982d10ab8c3dd605565049 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/char/ipmi/ipmi_msghandler.c: In function 'ipmi_set_my_LUN':
drivers/char/ipmi/ipmi_msghandler.c:1335:13: warning:
 variable 'rv' set but not used [-Wunused-but-set-variable]
  int index, rv = 0;

'rv' should be the correct return value.

Fixes: 048f7c3e352e ("ipmi: Properly release srcu locks on error conditions")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 3fb297b5fb176..84c17f936c09c 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1365,7 +1365,7 @@ int ipmi_set_my_LUN(struct ipmi_user *user,
 	}
 	release_ipmi_user(user, index);
 
-	return 0;
+	return rv;
 }
 EXPORT_SYMBOL(ipmi_set_my_LUN);
 
-- 
2.20.1



