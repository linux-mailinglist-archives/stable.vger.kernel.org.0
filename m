Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22FD43A014
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhJYT1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234878AbhJYTZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 486366108B;
        Mon, 25 Oct 2021 19:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189765;
        bh=qTL/thuFkDL43ARggOaRfeIFbZ/h+0f+5NaGoq5Ii90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18tGzMPzUeOU3gScpmEowaIbsj4oEZtNK/BmysnaALaFtCx03+EOxzk88hppYfv2l
         TdQIIcGxv8cTkoT9/rI90CJ3GxZ7kuPUXVWmZKE+bbngDlltgWoYG2RDHQT5fpHnod
         CcvagPV/saiykJEmv52pBoPVuK1RVJ5MUCj8iNx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Dexuan Cui <decui@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 26/30] scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()
Date:   Mon, 25 Oct 2021 21:14:46 +0200
Message-Id: <20211025190928.633444809@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
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
@@ -213,7 +213,8 @@ int scsi_add_host_with_dma(struct Scsi_H
 		goto fail;
 	}
 
-	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
+	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
+	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
 				   shost->can_queue);
 
 	error = scsi_init_sense_cache(shost);


