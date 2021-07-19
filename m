Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672123CDDCD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245650AbhGSPAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343837AbhGSO7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CAA66113E;
        Mon, 19 Jul 2021 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709047;
        bh=V5zivt4KHWMbQAUslsEEoDkydvtFrBaqqBpGyzEc12w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQbJBAWLxUsW2N5BOEhxbuSjc3fjKWXz49viSYbpGLfl8SL+ixmCbiYjDb8Gxu1Bh
         GkPya4AeZy4aavJDzbtKtOrEZnh+dwBa2H0P4w7K08yQQyJG0e0r0KtXcvkpOKSwne
         HPJe2+1tmBo/X+YkiwwqzbrEQ9Jw0Uv6UqsVmYfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/421] atm: iphase: fix possible use-after-free in ia_module_exit()
Date:   Mon, 19 Jul 2021 16:50:44 +0200
Message-Id: <20210719144954.494139511@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 1c72e6ab66b9598cac741ed397438a52065a8f1f ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 008905d4152a..827c6d5e6177 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3301,7 +3301,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-        del_timer(&ia_timer);
+	del_timer_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.30.2



