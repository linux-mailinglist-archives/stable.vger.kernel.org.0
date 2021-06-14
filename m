Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B0E3A64C1
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhFNL2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235513AbhFNL0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A15361419;
        Mon, 14 Jun 2021 10:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668098;
        bh=CDrQW38hQH5yfTSYoFDEHAl6A+SJxrYg8zTmBda9zeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmPdKC9i4zY/F1vRteKo2gB9xcqzfcJWl4Fc21605T3Oer3d/G41M5UUzlO+k0q4e
         vtjG2QWO8HZvvtkmu6+oeqW6XGtTlkmp5PU/BQUPbUdCasGXOhPv5PtTOuGkj/m9mK
         AlVvIO06kU/8UjhSWIopWaI+HIGs+YyFXu7mb2FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.12 173/173] scsi: core: Only put parent device if host state differs from SHOST_CREATED
Date:   Mon, 14 Jun 2021 12:28:25 +0200
Message-Id: <20210614102703.932977108@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 1e0d4e6225996f05271de1ebcb1a7c9381af0b27 upstream.

get_device(shost->shost_gendev.parent) is called after host state has
switched to SHOST_RUNNING. scsi_host_dev_release() shouldn't release the
parent device if host state is still SHOST_CREATED.

Link: https://lore.kernel.org/r/20210602133029.2864069-5-ming.lei@redhat.com
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hosts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -347,7 +347,7 @@ static void scsi_host_dev_release(struct
 
 	ida_simple_remove(&host_index_ida, shost->host_no);
 
-	if (parent)
+	if (shost->shost_state != SHOST_CREATED)
 		put_device(parent);
 	kfree(shost);
 }


