Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017F5EED36
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389696AbfKDWEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388664AbfKDWEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:04:34 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F666217F5;
        Mon,  4 Nov 2019 22:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905073;
        bh=8b+rc10cF3+ehcKjsbukOG/c6H/IqWuM9gO4hAiVys8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paql6eV0GRWXwqvz13MBNeqFyVfzS40x6Ug2SzSHQqkhCSk6buyd/E9qJdQzXNisp
         N6VFSrWfFHvgi2wUmR8c0bSqHH4RZZjbfRBH8sBgrhY7+lST9JRbLvRj1CntcBHGKD
         s9o0+E1FQkiqGfM7rd6M/M/6Da/R/TD2QDfMCiB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Connor Kuehl <connor.kuehl@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 020/163] staging: rtl8188eu: fix null dereference when kzalloc fails
Date:   Mon,  4 Nov 2019 22:43:30 +0100
Message-Id: <20191104212141.878157643@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor Kuehl <connor.kuehl@canonical.com>

[ Upstream commit 955c1532a34305f2f780b47f0c40cc7c65500810 ]

If kzalloc() returns NULL, the error path doesn't stop the flow of
control from entering rtw_hal_read_chip_version() which dereferences the
null pointer. Fix this by adding a 'goto' to the error path to more
gracefully handle the issue and avoid proceeding with initialization
steps that we're no longer prepared to handle.

Also update the debug message to be more consistent with the other debug
messages in this function.

Addresses-Coverity: ("Dereference after null check")

Signed-off-by: Connor Kuehl <connor.kuehl@canonical.com>
Link: https://lore.kernel.org/r/20190927214415.899-1-connor.kuehl@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 664d93a7f90df..4fac9dca798e8 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -348,8 +348,10 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 	}
 
 	padapter->HalData = kzalloc(sizeof(struct hal_data_8188e), GFP_KERNEL);
-	if (!padapter->HalData)
-		DBG_88E("cant not alloc memory for HAL DATA\n");
+	if (!padapter->HalData) {
+		DBG_88E("Failed to allocate memory for HAL data\n");
+		goto free_adapter;
+	}
 
 	/* step read_chip_version */
 	rtw_hal_read_chip_version(padapter);
-- 
2.20.1



