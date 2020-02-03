Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69BE150B6D
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgBCQ1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729415AbgBCQ13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:27:29 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61F5B2086A;
        Mon,  3 Feb 2020 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747248;
        bh=mPV8pOApGUcWAqTRUtRnpic/2GQ030XfApSb2e1ez08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDq/Mt+jKNFV1GfPNl2nA0xmr7sqeWyuxb2PJJZpgAHifGtcDCUqNKPWdDA+rqNaS
         eW4snNEND6YIUTgi+F3UovHV5GhHCEgdHqVssb8TqDnNFSEjPfMlFHALnZkodaEnOG
         agm6YhFHLM64rVd2SgihYl1YlSVJIDZTuRHU5iLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 53/68] scsi: fnic: do not queue commands during fwreset
Date:   Mon,  3 Feb 2020 16:19:49 +0000
Message-Id: <20200203161913.727410180@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 0e2209629fec427ba75a6351486153a9feddd36b ]

When a link is going down the driver will be calling fnic_cleanup_io(),
which will traverse all commands and calling 'done' for each found command.
While the traversal is handled under the host_lock, calling 'done' happens
after the host_lock is being dropped.

As fnic_queuecommand_lck() is being called with the host_lock held, it
might well be that it will pick the command being selected for abortion
from the above routine and enqueue it for sending, but then 'done' is being
called on that very command from the above routine.

Which of course confuses the hell out of the scsi midlayer.

So fix this by not queueing commands when fnic_cleanup_io is active.

Link: https://lore.kernel.org/r/20200116102053.62755-1-hare@suse.de
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index c056b8111ad27..7bf6102b4c3d5 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -445,6 +445,9 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED)))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_FWRESET)))
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	rport = starget_to_rport(scsi_target(sc->device));
 	ret = fc_remote_port_chkready(rport);
 	if (ret) {
-- 
2.20.1



