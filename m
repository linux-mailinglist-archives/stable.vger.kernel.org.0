Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8FB226723
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387478AbgGTQJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387469AbgGTQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:09:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A28DE22CB1;
        Mon, 20 Jul 2020 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261340;
        bh=eoZ6aqVUpZt4bpJWl7G/xhI+5Tqx6a8wdxwhcKq1e40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5Lu6vleQTjBeFErHG+evzkY0utsmcCctqaCkMy5+Cb2GUFpFjZ0OMDWkcZGF8tO5
         2Qyu9iuo1V+kWW7l7C0Tzk6sc/iEkawYZQBvkQ5X1XUpa6DiYavjrePJybhfBKNZAC
         kdhS7wsi6Bx/q+J3Y15xQ5CEzYc2j29ltmsfInZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 073/244] scsi: qla2xxx: make 1-bit bit-fields unsigned int
Date:   Mon, 20 Jul 2020 17:35:44 +0200
Message-Id: <20200720152829.316470169@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 78b874b7cbf09fbfadfa5f18a347ebef7bbb49fe ]

The bitfields mpi_fw_dump_reading and mpi_fw_dumped are currently signed
which is not recommended as the representation is an implementation defined
behaviour.  Fix this by making the bit-fields unsigned ints.

Link: https://lore.kernel.org/r/20200428102013.1040598-1-colin.king@canonical.com
Fixes: cbb01c2f2f63 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index daa9e936887bb..172ea4e5887d9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4248,8 +4248,8 @@ struct qla_hw_data {
 	int		fw_dump_reading;
 	void		*mpi_fw_dump;
 	u32		mpi_fw_dump_len;
-	int		mpi_fw_dump_reading:1;
-	int		mpi_fw_dumped:1;
+	unsigned int	mpi_fw_dump_reading:1;
+	unsigned int	mpi_fw_dumped:1;
 	int		prev_minidump_failed;
 	dma_addr_t	eft_dma;
 	void		*eft;
-- 
2.25.1



