Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102CF419C34
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbhI0R0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238012AbhI0RYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E88656137B;
        Mon, 27 Sep 2021 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762930;
        bh=KzbuxniTZU/Xpf8v/BqtXJsvj4hDDoghvisbVdmQzKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHOktnbXcE8WmTojynCfMFcFPKfDoWCgOZPRQMLl9CVBK9txUixVQf9R3AZb9tAI4
         hthgyW/FWdAk96y04sBGuDpsv5h96F6e0WsIEiM/rvIxpJCCub/IYke0NZBeZuvRV6
         CaGAD5yDMQauRfKy2xY9GpYMoymqW5HDAEFqMeWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 105/162] scsi: ufs: core: Unbreak the reset handler
Date:   Mon, 27 Sep 2021 19:02:31 +0200
Message-Id: <20210927170237.072785112@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d04a968c33684b15d1206e23fc1119ce0f0587fb ]

A command tag is passed as the second argument of the
__ufshcd_transfer_req_compl() call in ufshcd_eh_device_reset_handler()
instead of a bitmask. Fix this by passing a bitmask as argument instead of
a command tag.

Link: https://lore.kernel.org/r/20210916175408.2260084-1-bvanassche@acm.org
Fixes: a45f937110fa ("scsi: ufs: Optimize host lock on transfer requests send/compl paths")
Cc: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a858e7d998a6..3a204324151a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6858,7 +6858,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, pos, /*retry_requests=*/true);
+			__ufshcd_transfer_req_compl(hba, 1U << pos, false);
 		}
 	}
 
-- 
2.33.0



