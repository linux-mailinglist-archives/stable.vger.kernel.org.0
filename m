Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E1E480085
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbhL0Pqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239985AbhL0PoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E89AC08E84E;
        Mon, 27 Dec 2021 07:41:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C792B810BF;
        Mon, 27 Dec 2021 15:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD79C36AE7;
        Mon, 27 Dec 2021 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619710;
        bh=rjWPgFogMYCo7+ob2aWVPqobkszGU9Bj6Eq85hQA4Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWqJ2N1eKzMo+cXpM68Oqy4p6VyLCYWanvqQygRpryq74X57uIAR3mb+tccJk9rHJ
         BToMhkokglFxI6kXt18GD9q8uVtmQMZgOFrRqBCrj/HTphfns3kS+UqRoKEmXhS7uQ
         wedixlLO4mVE3TwZk6KSUtcWdQLLdggWzsErY7w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
Subject: [PATCH 5.15 042/128] asix: fix uninit-value in asix_mdio_read()
Date:   Mon, 27 Dec 2021 16:30:17 +0100
Message-Id: <20211227151332.925355044@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 8035b1a2a37a29d8c717ef84fca8fe7278bc9f03 ]

asix_read_cmd() may read less than sizeof(smsr) bytes and in this case
smsr will be uninitialized.

Fail log:
BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
BUG: KMSAN: uninit-value in asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497
 asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
 asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
 asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497

Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
Reported-and-tested-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/8966e3b514edf39857dd93603fc79ec02e000a75.1640117288.git.paskripkin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 38cda590895cc..b80c2dcfc9084 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -77,7 +77,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 				    0, 0, 1, &smsr, in_pm);
 		if (ret == -ENODEV)
 			break;
-		else if (ret < 0)
+		else if (ret < sizeof(smsr))
 			continue;
 		else if (smsr & AX_HOST_EN)
 			break;
-- 
2.34.1



