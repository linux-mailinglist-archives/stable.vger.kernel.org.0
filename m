Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CE844C70A
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhKJSrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232896AbhKJSrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:47:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94CE56115A;
        Wed, 10 Nov 2021 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569870;
        bh=zcHyq49sTh9mXhWeGeX8Zs82VtijvsSELOCePhpwUxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHbrCj/sUt0V7xw16iBIOC35k6g+E2hBnLl65m76z+IveDkl+XYlbWWMEFA4G5RxN
         SmP2SrI0/gW9hrM/I/M4OrH3F567Xi43Vtp/gvqwImJ7fnze312PrMClzS9Ca1SvUm
         KmystQkCszWHJR3TCfisgcCodhempfpBNr/EAF4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 01/22] scsi: core: Put LLD module refcnt after SCSI device is released
Date:   Wed, 10 Nov 2021 19:43:08 +0100
Message-Id: <20211110182001.628982980@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.579561273@linuxfoundation.org>
References: <20211110182001.579561273@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit f2b85040acec9a928b4eb1b57a989324e8e38d3f upstream.

SCSI host release is triggered when SCSI device is freed. We have to make
sure that the low-level device driver module won't be unloaded before SCSI
host instance is released because shost->hostt is required in the release
handler.

Make sure to put LLD module refcnt after SCSI device is released.

Fixes a kernel panic of 'BUG: unable to handle page fault for address'
reported by Changhui and Yi.

Link: https://lore.kernel.org/r/20211008050118.1440686-1-ming.lei@redhat.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: Changhui Zhong <czhong@redhat.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi.c       |    4 +++-
 drivers/scsi/scsi_sysfs.c |    9 +++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -951,8 +951,10 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
+	struct module *mod = sdev->host->hostt->module;
+
 	put_device(&sdev->sdev_gendev);
+	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -427,9 +427,12 @@ static void scsi_device_dev_release_user
 	struct device *parent;
 	struct list_head *this, *tmp;
 	unsigned long flags;
+	struct module *mod;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	mod = sdev->host->hostt->module;
+
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -461,11 +464,17 @@ static void scsi_device_dev_release_user
 
 	if (parent)
 		put_device(parent);
+	module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
+
+	/* Set module pointer as NULL in case of module unloading */
+	if (!try_module_get(sdp->host->hostt->module))
+		sdp->host->hostt->module = NULL;
+
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }


