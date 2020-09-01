Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9542592F0
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbgIAPTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgIAPS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:18:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB1D5206FA;
        Tue,  1 Sep 2020 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973537;
        bh=czG7leFFJV79SB3ria9grB1nneO63WfiL0BGAdFMZ50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHoM0gWHEZxWZbamWufr1b1xcgp5RpOKxIq9EP8bz7HEGnIy1/Z9iWoTZzo6dVVLL
         Pw0Q3PPrd8y7eecyOAjP1Xbf2K2iFsvZ4/dbtimMHYWh81YkR+hcOCQIuLu79GMKxp
         nzpb6gGYPtVIQcpH2V6X0q94HBjB6akEepjoS990=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Changming Liu <charley.ashbringer@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/91] USB: sisusbvga: Fix a potential UB casued by left shifting a negative value
Date:   Tue,  1 Sep 2020 17:10:13 +0200
Message-Id: <20200901150930.084460798@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changming Liu <charley.ashbringer@gmail.com>

[ Upstream commit 2b53a19284f537168fb506f2f40d7fda40a01162 ]

The char buffer buf, receives data directly from user space,
so its content might be negative and its elements are left
shifted to form an unsigned integer.

Since left shifting a negative value is undefined behavior, thus
change the char to u8 to elimintate this UB.

Signed-off-by: Changming Liu <charley.ashbringer@gmail.com>
Link: https://lore.kernel.org/r/20200711043018.928-1-charley.ashbringer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/sisusbvga/sisusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index a6f88442a53a9..a020d5eafb4a5 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -760,7 +760,7 @@ static int sisusb_write_mem_bulk(struct sisusb_usb_data *sisusb, u32 addr,
 	u8   swap8, fromkern = kernbuffer ? 1 : 0;
 	u16  swap16;
 	u32  swap32, flag = (length >> 28) & 1;
-	char buf[4];
+	u8 buf[4];
 
 	/* if neither kernbuffer not userbuffer are given, assume
 	 * data in obuf
-- 
2.25.1



