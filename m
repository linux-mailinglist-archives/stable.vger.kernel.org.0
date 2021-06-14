Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57693A6341
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbhFNLLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235139AbhFNLIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C45F461448;
        Mon, 14 Jun 2021 10:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667589;
        bh=d3vysglgx2VDQxV0Ai53lGn9KkchRwONqJV3OJtW5Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtfBJwkVKV1hzffHrldGbUZ98x8Rq6IsCh7kGMtusmR0kzARbFQUV4LrJqoZkQ3ux
         HOfgNslNpjWaK5EodzW5LT9J8J8klinAHnkDp6s6VqE3VCrdHrkMZDsuRR+nT9lW65
         N29MWcG4JftyqU2V144AJ16fIY1mRV+i0QjjRhS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 129/131] scsi: core: Put .shost_dev in failure path if host state changes to RUNNING
Date:   Mon, 14 Jun 2021 12:28:10 +0200
Message-Id: <20210614102657.402091854@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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
@@ -254,12 +254,11 @@ int scsi_add_host_with_dma(struct Scsi_H
 
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
@@ -297,6 +296,11 @@ int scsi_add_host_with_dma(struct Scsi_H
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


