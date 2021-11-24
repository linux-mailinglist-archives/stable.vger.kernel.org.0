Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3096745C2BB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbhKXNcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:32:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351035AbhKXN3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:29:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80A2861BB6;
        Wed, 24 Nov 2021 12:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758307;
        bh=ulB1My15wYls2WJEtMMxhL4d1kPvMOfZCnCYtDGanM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1h4jFzw8Vio2SFqAdqqYB3ra9al+eHzAk2blfyXNG2B+UbnFHHk8SExS3uz4vc4QE
         iMAe7bEgLH6ekfK7NNLqc0zGdxPWZHZfUoBQ1P7d27p9Irj4RxYeq6W5Tq4HL3uG0G
         A7lsl0wVX9lnVcj5Jva95EYBCxsG4TkBUfQB0H1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Zhi <qtxuning1999@sjtu.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/154] scsi: advansys: Fix kernel pointer leak
Date:   Wed, 24 Nov 2021 12:57:02 +0100
Message-Id: <20211124115703.207636807@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Zhi <qtxuning1999@sjtu.edu.cn>

[ Upstream commit d4996c6eac4c81b8872043e9391563f67f13e406 ]

Pointers should be printed with %p or %px rather than cast to 'unsigned
long' and printed with %lx.

Change %lx to %p to print the hashed pointer.

Link: https://lore.kernel.org/r/20210929122538.1158235-1-qtxuning1999@sjtu.edu.cn
Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index c2c7850ff7b42..727d8f019eddd 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3366,8 +3366,8 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 		   shost->host_no);
 
 	seq_printf(m,
-		   " iop_base 0x%lx, cable_detect: %X, err_code %u\n",
-		   (unsigned long)v->iop_base,
+		   " iop_base 0x%p, cable_detect: %X, err_code %u\n",
+		   v->iop_base,
 		   AdvReadWordRegister(iop_base,IOPW_SCSI_CFG1) & CABLE_DETECT,
 		   v->err_code);
 
-- 
2.33.0



