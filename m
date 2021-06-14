Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2573A63B2
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhFNLQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233168AbhFNLOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:14:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30E4960D07;
        Mon, 14 Jun 2021 10:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667738;
        bh=d/WeDXI2SiQXWsZKkAp0Kn29WO4HKxpw5LZgqRdHHTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XC91+FHw7RvLQya8R3wvI7qArlUuaKOv++EUY+wLWQJIKOMphTjPESSjW5JSGVdJQ
         uvOz3hFKvzG5CHVUpNJu0BvxBdn2K/QSwAXEbzjyJ2CHGsGxmuAMJo3Eflps3BRKTU
         A20UcRTny+gOplE8wKgyYVqw6HtaXET3KabIIg9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 028/173] scsi: bnx2fc: Return failure if io_req is already in ABTS processing
Date:   Mon, 14 Jun 2021 12:26:00 +0200
Message-Id: <20210614102659.081764376@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 122c81c563b0c1c6b15ff76a9159af5ee1f21563 ]

Return failure from bnx2fc_eh_abort() if io_req is already in ABTS
processing.

Link: https://lore.kernel.org/r/20210519061416.19321-1-jhasan@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 1a0dc18d6915..ed300a279a38 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1220,6 +1220,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		   was a result from the ABTS request rather than the CLEANUP
 		   request */
 		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
+		rc = FAILED;
 		goto done;
 	}
 
-- 
2.30.2



