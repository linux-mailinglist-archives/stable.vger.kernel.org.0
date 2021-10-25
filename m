Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729AA43A049
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhJYT3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235462AbhJYT2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:28:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F047C601FF;
        Mon, 25 Oct 2021 19:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189897;
        bh=VIr5Cg4CxrmJH2Yoat8m8yclOhYDv4uAAGK7cQTOsLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4aO21a+NgK3ZAmUQLO3v+EqAK4TIRzfqP9oHKNHwpmOPkMoEYyuXXwiqRWbvHuQp
         ULDJkBM5Y0vFjxZeFuZ/fPfA6R5xT7dNPrgFa37gKW1Be/F7zgybK3fHpfKD63pHM2
         7HwGPrYt5+hbwtQtLuAm5Glchiw47nKRNlCPaYmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Dexuan Cui <decui@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 33/37] scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()
Date:   Mon, 25 Oct 2021 21:14:58 +0200
Message-Id: <20211025190935.016115642@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 50b6cb3516365cb69753b006be2b61c966b70588 upstream.

After commit ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at
can_queue"), a 416-CPU VM running on Hyper-V hangs during boot because the
hv_storvsc driver sets scsi_driver.can_queue to an integer value that
exceeds SHRT_MAX, and hence scsi_add_host_with_dma() sets
shost->cmd_per_lun to a negative "short" value.

Use min_t(int, ...) to work around the issue.

Link: https://lore.kernel.org/r/20211008043546.6006-1-decui@microsoft.com
Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")
Cc: stable@vger.kernel.org
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hosts.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -218,7 +218,8 @@ int scsi_add_host_with_dma(struct Scsi_H
 		goto fail;
 	}
 
-	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
+	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
+	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
 				   shost->can_queue);
 
 	error = scsi_init_sense_cache(shost);


