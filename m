Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E74B3A60F0
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhFNKk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233825AbhFNKiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:38:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5D2661242;
        Mon, 14 Jun 2021 10:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666832;
        bh=uODCy0NfaMyVhFlnfZ3ODB4zEI5OEA519WoqO15KXU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CsaaqDE/cgT0YOlXrSMUEKzlKCrqd4YWHpAQP4eRS/5z0QFbWRCgL+YiyDIbEBVN
         YGbEUAgmDr+sAkqvv7cF17imoWPQHWiVlTBGMuSReBvy/nwhidyhqn7nxLQrtzfEyC
         s/8qT/gan+zYi7Gs6EHHYCJ8lr53cniRBDHY8e6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 46/49] scsi: core: Put .shost_dev in failure path if host state changes to RUNNING
Date:   Mon, 14 Jun 2021 12:27:39 +0200
Message-Id: <20210614102643.363691505@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 11714026c02d613c30a149c3f4c4a15047744529 upstream.

scsi_host_dev_release() only frees dev_name when host state is
SHOST_CREATED. After host state has changed to SHOST_RUNNING,
scsi_host_dev_release() no longer cleans up.

Fix this by doing a put_device(&shost->shost_dev) in the failure path when
host state is SHOST_RUNNING. Move get_device(&shost->shost_gendev) before
device_add(&shost->shost_dev) so that scsi_host_cls_release() can do a put
on this reference.

Link: https://lore.kernel.org/r/20210602133029.2864069-4-ming.lei@redhat.com
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Reported-by: John Garry <john.garry@huawei.com>
Tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hosts.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -256,12 +256,11 @@ int scsi_add_host_with_dma(struct Scsi_H
 
 	device_enable_async_suspend(&shost->shost_dev);
 
+	get_device(&shost->shost_gendev);
 	error = device_add(&shost->shost_dev);
 	if (error)
 		goto out_del_gendev;
 
-	get_device(&shost->shost_gendev);
-
 	if (shost->transportt->host_size) {
 		shost->shost_data = kzalloc(shost->transportt->host_size,
 					 GFP_KERNEL);
@@ -298,6 +297,11 @@ int scsi_add_host_with_dma(struct Scsi_H
  out_del_dev:
 	device_del(&shost->shost_dev);
  out_del_gendev:
+	/*
+	 * Host state is SHOST_RUNNING so we have to explicitly release
+	 * ->shost_dev.
+	 */
+	put_device(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
  out_disable_runtime_pm:
 	device_disable_async_suspend(&shost->shost_gendev);


