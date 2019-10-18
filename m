Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7948ADD2BB
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389220AbfJRWJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389198AbfJRWJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:09:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B12A322475;
        Fri, 18 Oct 2019 22:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436583;
        bh=oRp6FLuQ2dT5U3OHIfhPQWl85hmIQQJT7IQ+xrwJ9uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jg6CR3iFN6JCG3DYCIkGEY3jKNrtMC5G8RA6c8ml/IXxuNBPxLHMjMZgD/HG+W85S
         5sGZH3hTKUvFY1mIUZvI+wbGppbWjEkQPIyfzsbrYHXrrUHLSV6ofhMVBjHKXp1HY/
         8zkvUWKdBFkDaB6VtfQ7qGIkF9ruUZJLioEXRSZI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Connor Kuehl <connor.kuehl@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 12/29] staging: rtl8188eu: fix null dereference when kzalloc fails
Date:   Fri, 18 Oct 2019 18:09:03 -0400
Message-Id: <20191018220920.10545-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220920.10545-1-sashal@kernel.org>
References: <20191018220920.10545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d22360849b883..d4a7d740fc620 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -366,8 +366,10 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 	}
 
 	padapter->HalData = kzalloc(sizeof(struct hal_data_8188e), GFP_KERNEL);
-	if (!padapter->HalData)
-		DBG_88E("cant not alloc memory for HAL DATA\n");
+	if (!padapter->HalData) {
+		DBG_88E("Failed to allocate memory for HAL data\n");
+		goto free_adapter;
+	}
 
 	padapter->intf_start = &usb_intf_start;
 	padapter->intf_stop = &usb_intf_stop;
-- 
2.20.1

