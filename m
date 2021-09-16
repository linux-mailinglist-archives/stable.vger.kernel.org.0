Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7407640E5EE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245605AbhIPRQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350526AbhIPRN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:13:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19A66619FA;
        Thu, 16 Sep 2021 16:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810352;
        bh=812aiSYfVNZXsO980ECgTbBYBDHnA8NEVpQikyjAFrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhSN8U/OIodJck6JZymkgOId94/9sNBV72k20lNIg8nCXz1qDWSOD6CuYBc9DTT6Z
         UKF0MmJYUk3IkQfd1HP/duLt72GQ9gDz8tVH8wwPllO2ZHyhcKCRsoyDldSvROi18H
         aKt7KaARti0rIBUzUjCFkROZM+m57M0Ev9/wJR8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Colin Ian King <colin.king@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 110/432] scsi: ufs: Fix unsigned int compared with less than zero
Date:   Thu, 16 Sep 2021 17:57:39 +0200
Message-Id: <20210916155814.503823240@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a5402cdcc2a925835db89ea336909b2b724189df ]

Variable 'tag' is currently an unsigned int and is being compared to less
than zero, this check is always false. Fix this by making 'tag' an int.

Link: https://lore.kernel.org/r/20210806144301.19864-1-colin.king@canonical.com
Fixes: 4728ab4a8e64 ("scsi: ufs: Remove ufshcd_valid_tag()")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Addresses-Coverity: ("Macro compares unsigned to 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1708d7ced527..8275127749d2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6969,7 +6969,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
 	unsigned long flags;
-	unsigned int tag;
+	int tag;
 	int err = FAILED;
 	struct ufshcd_lrb *lrbp;
 	u32 reg;
-- 
2.30.2



