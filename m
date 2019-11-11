Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78768F7C3C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfKKSoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbfKKSoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:44:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6A8520659;
        Mon, 11 Nov 2019 18:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497858;
        bh=dss0UCtVF8ZL+T4a9RC7yR8+z7o5WELNOfKD0cogP+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XINu+5W+maaHvEgrz9XOa/Mt0pzoqYruZ+ENooaasQNHiPyqQQZ3XnbMuNRqyw0eq
         kI7tZYF9zb+9NJfhP85XRbu4T/CWyVtXVOhfil155H7EkNthpDjLy2HTN53zHjxHpE
         Y10NPTT36I1AgJZ70n8DDArMELVpTufyA1IagQaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/125] RDMA/qedr: Fix reported firmware version
Date:   Mon, 11 Nov 2019 19:28:35 +0100
Message-Id: <20191111181450.273179965@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit b806c94ee44e53233b8ce6c92d9078d9781786a5 ]

Remove spaces from the reported firmware version string.
Actual value:
$ cat /sys/class/infiniband/qedr0/fw_ver
8. 37. 7. 0

Expected value:
$ cat /sys/class/infiniband/qedr0/fw_ver
8.37.7.0

Fixes: ec72fce401c6 ("qedr: Add support for RoCE HW init")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Link: https://lore.kernel.org/r/20191007210730.7173-1-kamalheib1@gmail.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index a0af6d424aeda..d1680d3b58250 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -77,7 +77,7 @@ static void qedr_get_dev_fw_str(struct ib_device *ibdev, char *str)
 	struct qedr_dev *qedr = get_qedr_dev(ibdev);
 	u32 fw_ver = (u32)qedr->attr.fw_ver;
 
-	snprintf(str, IB_FW_VERSION_NAME_MAX, "%d. %d. %d. %d",
+	snprintf(str, IB_FW_VERSION_NAME_MAX, "%d.%d.%d.%d",
 		 (fw_ver >> 24) & 0xFF, (fw_ver >> 16) & 0xFF,
 		 (fw_ver >> 8) & 0xFF, fw_ver & 0xFF);
 }
-- 
2.20.1



