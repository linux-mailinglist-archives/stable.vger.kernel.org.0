Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD15A1EFAC3
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgFEOUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbgFEOU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:20:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67439206F0;
        Fri,  5 Jun 2020 14:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366828;
        bh=+lEalpydFPuoTLmL+lIAkvgtLcYak05gGNyBg7fZBME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVKsuq5ZU5hhN2UeczcCjS6aFsGQ4/TgwWmuuk1FQIJdtO0oQAq0qw60WcGOrTUB6
         LpIiLeapnGjeKHO1rFx0lIOYd8t9lQLSVTT/OILyUm+swc/q1f0tYfQO9utiFxGGPz
         DxMM6SQvzGfOOPr8WwEaaHVIoHnl5a1UltJv11GM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 09/28] scsi: ufs: Release clock if DMA map fails
Date:   Fri,  5 Jun 2020 16:15:11 +0200
Message-Id: <20200605140252.892569834@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.338635395@linuxfoundation.org>
References: <20200605140252.338635395@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

commit 17c7d35f141ef6158076adf3338f115f64fcf760 upstream.

In queuecommand path, if DMA map fails, it bails out with clock held.  In
this case, release the clock to keep its usage paired.

[mkp: applied by hand]

Link: https://lore.kernel.org/r/0101016ed3d66395-1b7e7fce-b74d-42ca-a88a-4db78b795d3b-000000@us-west-2.amazonses.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[EB: resolved cherry-pick conflict caused by newer kernels not having
 the clear_bit_unlock() line]
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2505,6 +2505,7 @@ static int ufshcd_queuecommand(struct Sc
 
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
+		ufshcd_release(hba);
 		lrbp->cmd = NULL;
 		clear_bit_unlock(tag, &hba->lrb_in_use);
 		goto out;


