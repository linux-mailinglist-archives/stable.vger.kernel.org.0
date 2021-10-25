Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83DA43A376
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237453AbhJYT7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239409AbhJYT4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AD3B61073;
        Mon, 25 Oct 2021 19:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191203;
        bh=IkMDFOmc7IMCVP3I5vGYPaPzbfUgdwu1oriSfnoUNtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jg3vUNB4/4antVBnX7Zwtkz8LjK3M01tWMH6DInx2QhM8VxxIL3j0kQ2N+JAmettN
         3rEgA+wEpX3rvg0K6311WADlSgS5SP1OCI4o/tuUWpyBGCUvPk1DsOMcoH1MpkplO4
         xQSniusjFw9xSlqScbptIdcTNFObCUvbvvmM+17U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 151/169] scsi: mpi3mr: Fix duplicate device entries when scanning through sysfs
Date:   Mon, 25 Oct 2021 21:15:32 +0200
Message-Id: <20211025191036.664596019@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 97e6ea6d78064e7f1e9e19c45dc690aabbb71297 ]

When scanning devices through the 'scan' attribute in sysfs, the user will
observe duplicate device entries in lsscsi command output.

Set the shost's max_channel to zero to avoid this.

Link: https://lore.kernel.org/r/20211014055425.30719-1-sreekanth.reddy@broadcom.com
Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 24ac7ddec749..206c2598ade3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3755,7 +3755,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_lun = -1;
 	shost->unique_id = mrioc->id;
 
-	shost->max_channel = 1;
+	shost->max_channel = 0;
 	shost->max_id = 0xFFFFFFFF;
 
 	if (prot_mask >= 0)
-- 
2.33.0



