Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA69E3C5541
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355465AbhGLIJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353392AbhGLICE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9732E61C4A;
        Mon, 12 Jul 2021 07:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076492;
        bh=Ss3r1Xszb6PDA6klpcWI/FUjc4crWvIyQEIVLiYKJGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKQ8iOGXpiaMuzwqz2aPLjLKOoeGOV0YQFN+lB0O5gA1Wb57zlE+1KVzuBIeRSy4S
         ULeF7/I77Igf9VMSB2Ay0wB1v3ARbf20PycsA7fRhee8lwEKtdReY6nBFThoAfk7TZ
         KiDAZLeAUlPxDVUc+DFAGdlFMHchTPJ53M4Wivjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 667/800] scsi: iscsi: Flush block work before unblock
Date:   Mon, 12 Jul 2021 08:11:30 +0200
Message-Id: <20210712061037.915479813@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 7ce9fc5ecde0d8bd64c29baee6c5e3ce7074ec9a ]

We set the max_active iSCSI EH works to 1, so all work is going to execute
in order by default. However, userspace can now override this in sysfs. If
max_active > 1, we can end up with the block_work on CPU1 and
iscsi_unblock_session running the unblock_work on CPU2 and the session and
target/device state will end up out of sync with each other.

This adds a flush of the block_work in iscsi_unblock_session.

Link: https://lore.kernel.org/r/20210525181821.7617-17-michael.christie@oracle.com
Fixes: 1d726aa6ef57 ("scsi: iscsi: Optimize work queue flush use")
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b8a93e607891..6ce1cc992d1d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1969,6 +1969,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
  */
 void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
+	flush_work(&session->block_work);
+
 	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
 	/*
 	 * Blocking the session can be done from any context so we only
-- 
2.30.2



