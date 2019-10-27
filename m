Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C96E6578
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfJ0VCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbfJ0VCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:02:33 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94BE92064A;
        Sun, 27 Oct 2019 21:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210152;
        bh=nQzPg6Cjllqir6rtER6d5XGo+HSHjtmHJ9eSyOdluEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLSEs8YjoZY4VM/GLqYll3Z/yTPx1Y7oNuER/tnEObhB1e//4jhDfkBxtYHA2HiQc
         /ETrnPyozXkcsJQplRq/YORj6qhEcjDzw0GJjLJQS8VWuKfBQhsrDWrncYl0zhRu7Z
         Dyi0SMBvVQGeC9tlwAxHefLnsuJR7kZtiyp7v2gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/41] scsi: ufs: skip shutdown if hba is not powered
Date:   Sun, 27 Oct 2019 22:00:39 +0100
Message-Id: <20191027203059.889159814@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
References: <20191027203056.220821342@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit f51913eef23f74c3bd07899dc7f1ed6df9e521d8 ]

In some cases, hba may go through shutdown flow without successful
initialization and then make system hang.

For example, if ufshcd_change_power_mode() gets error and leads to
ufshcd_hba_exit() to release resources of the host, future shutdown flow
may hang the system since the host register will be accessed in unpowered
state.

To solve this issue, simply add checking to skip shutdown for above kind of
situation.

Link: https://lore.kernel.org/r/1568780438-28753-1-git-send-email-stanley.chu@mediatek.com
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Acked-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fd8bbd2b5d0eb..504d367961528 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5371,6 +5371,9 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 {
 	int ret = 0;
 
+	if (!hba->is_powered)
+		goto out;
+
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
 		goto out;
 
-- 
2.20.1



