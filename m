Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C7A27008
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfEVTWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730585AbfEVTWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:22:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB6D20644;
        Wed, 22 May 2019 19:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552966;
        bh=0zw7RmLjAK+ib5kdgkkLzNkiQo+eKZUo+C72b4IzmDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuGfdzu/0z1yNoxSpYm05rA/I9L1hztch3Zc6wWYYy4Hdp1N8p5XKABQRGC7Rgn4z
         09S1iBjQciNL4y6VSV1tX4XJOQ70ReXLf101OpfWtPN8ep+YR3lLlCXzVvYbeKMZ9P
         camf5iwXHxLL7Deqg3LHgNekUSzcu6mGxxHk3yBE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 052/375] scsi: qla2xxx: Fix abort handling in tcm_qla2xxx_write_pending()
Date:   Wed, 22 May 2019 15:15:52 -0400
Message-Id: <20190522192115.22666-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e209783d66bca04b5fce4429e59338517ffc1a0b ]

Implementations of the .write_pending() callback functions must guarantee
that an appropriate LIO core callback function will be called immediately or
at a later time.  Make sure that this guarantee is met for aborted SCSI
commands.

[mkp: typo]

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <gmalavali@marvell.com>
Fixes: 694833ee00c4 ("scsi: tcm_qla2xxx: Do not allow aborted cmd to advance.") # v4.13.
Fixes: a07100e00ac4 ("qla2xxx: Fix TMR ABORT interaction issue between qla2xxx and TCM") # v4.5.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 8a3075d17c63c..bddb573c88dd2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -399,6 +399,8 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 			cmd->se_cmd.transport_state,
 			cmd->se_cmd.t_state,
 			cmd->se_cmd.se_cmd_flags);
+		transport_generic_request_failure(&cmd->se_cmd,
+			TCM_CHECK_CONDITION_ABORT_CMD);
 		return 0;
 	}
 	cmd->trc_flags |= TRC_XFR_RDY;
-- 
2.20.1

