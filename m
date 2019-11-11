Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE49FF7BA3
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbfKKSiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:38:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbfKKSiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC0E214E0;
        Mon, 11 Nov 2019 18:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497489;
        bh=fVttVjr+D6cUItgUAufminP6729wf7iFYBif/RxkV9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUBmD/wO1MMQkhU5/fIT0jwJD1+Kzo4H3LHANsI3iEajqYuAVTcxCmzneNTZJtzo2
         IM6lML6Z8MpscrREtoM1Yxp2wERyOD25WzY7d9E4x6/WqAobelFM+iJWKIrFwwNuZX
         YX3O5BtqyLWUNu348gWvOYVaIHLblx42brmStLz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 071/105] RDMA/qedr: Fix reported firmware version
Date:   Mon, 11 Nov 2019 19:28:41 +0100
Message-Id: <20191111181445.791561925@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
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
index ddb05b42e5e6a..3e48ed64760b7 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -73,7 +73,7 @@ static void qedr_get_dev_fw_str(struct ib_device *ibdev, char *str)
 	struct qedr_dev *qedr = get_qedr_dev(ibdev);
 	u32 fw_ver = (u32)qedr->attr.fw_ver;
 
-	snprintf(str, IB_FW_VERSION_NAME_MAX, "%d. %d. %d. %d",
+	snprintf(str, IB_FW_VERSION_NAME_MAX, "%d.%d.%d.%d",
 		 (fw_ver >> 24) & 0xFF, (fw_ver >> 16) & 0xFF,
 		 (fw_ver >> 8) & 0xFF, fw_ver & 0xFF);
 }
-- 
2.20.1



