Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7229C5A7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754155AbgJ0OEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900860AbgJ0OEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:04:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF0B02222C;
        Tue, 27 Oct 2020 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807487;
        bh=6NBAEUVFpxc4x1YYsbZlGveUAnM3ZCPXTBKEHsU8lTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcAQwcqpWSw1jQnP9vj8GNpVgjq2F5r5bFVVv5kbw8f5JA4ghjVANTedJAMNu1qi6
         KTYI83IUJ6L4qRcDlIlUU+fq1LNCpKS2cHBKdt49i+tD4Xe/ImRdRNzuwSD2DAdwII
         eAckmcsCKpn54x+7cwJCn0hf9uoXbZjqb3X0fLZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/139] scsi: qla4xxx: Fix an error handling path in qla4xxx_get_host_stats()
Date:   Tue, 27 Oct 2020 14:48:46 +0100
Message-Id: <20201027134903.664735320@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 574918e69720fe62ab3eb42ec3750230c8d16b06 ]

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()'.

Link: https://lore.kernel.org/r/20200802101527.676054-1-christophe.jaillet@wanadoo.fr
Fixes: 4161cee52df8 ("[SCSI] qla4xxx: Add host statistics support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3fda5836aac69..f10088a1d38c0 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1223,7 +1223,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, int len)
 			le64_to_cpu(ql_iscsi_stats->iscsi_sequence_error);
 exit_host_stats:
 	if (ql_iscsi_stats)
-		dma_free_coherent(&ha->pdev->dev, host_stats_size,
+		dma_free_coherent(&ha->pdev->dev, stats_size,
 				  ql_iscsi_stats, iscsi_stats_dma);
 
 	ql4_printk(KERN_INFO, ha, "%s: Get host stats done\n",
-- 
2.25.1



