Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116F7344354
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhCVMti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhCVMsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED88D619E6;
        Mon, 22 Mar 2021 12:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417039;
        bh=WdUFp7EHK1aaSRLs1v1yIQ1MRYtqJlMTkkRzWZBV+E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGc09lT1f0eAHsck6VA/N/F0lUjlwuEjTwDrw0o6sUKqUFGW4qXEBq9axHR5uD7k+
         veDhLGYAo3ZSeYlrxMU7ZtduIBTX2OSYuf6CwWgSshfo6X80AqpNwyZx8FCziEHxpK
         jhLaQu82WoVuiFUAszQ6rXldZiRjYadriFfHwUGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 30/60] scsi: lpfc: Fix some error codes in debugfs
Date:   Mon, 22 Mar 2021 13:28:18 +0100
Message-Id: <20210322121923.386911932@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 19f1bc7edf0f97186810e13a88f5b62069d89097 upstream.

If copy_from_user() or kstrtoull() fail then the correct behavior is to
return a negative error code.

Link: https://lore.kernel.org/r/YEsbU/UxYypVrC7/@mwanda
Fixes: f9bb2da11db8 ("[SCSI] lpfc 8.3.27: T10 additions for SLI4")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2217,7 +2217,7 @@ lpfc_debugfs_dif_err_write(struct file *
 	memset(dstbuf, 0, 33);
 	size = (nbytes < 32) ? nbytes : 32;
 	if (copy_from_user(dstbuf, buf, size))
-		return 0;
+		return -EFAULT;
 
 	if (dent == phba->debug_InjErrLBA) {
 		if ((buf[0] == 'o') && (buf[1] == 'f') && (buf[2] == 'f'))
@@ -2225,7 +2225,7 @@ lpfc_debugfs_dif_err_write(struct file *
 	}
 
 	if ((tmp == 0) && (kstrtoull(dstbuf, 0, &tmp)))
-		return 0;
+		return -EINVAL;
 
 	if (dent == phba->debug_writeGuard)
 		phba->lpfc_injerr_wgrd_cnt = (uint32_t)tmp;


