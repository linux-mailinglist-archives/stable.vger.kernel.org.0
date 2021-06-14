Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831AE3A6343
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhFNLLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234483AbhFNLI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:08:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49BCE61450;
        Mon, 14 Jun 2021 10:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667591;
        bh=CDrQW38hQH5yfTSYoFDEHAl6A+SJxrYg8zTmBda9zeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuIBBJHtJkuWHMd0X4K+C7E22zIlIG3ZL07eqOMGeAj4Gtarzw0tu8qQvFlim4QVi
         AwGjaHxPRyR10SKsBAxJnkO+Ukniqd1EzQOiU9fCibhOQ9AmIznYUW8kSy2iP18B7W
         Bz1zq/VErVFnMow9ZVl9UUF86hCJQDvMc62asRJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 130/131] scsi: core: Only put parent device if host state differs from SHOST_CREATED
Date:   Mon, 14 Jun 2021 12:28:11 +0200
Message-Id: <20210614102657.441429636@linuxfoundation.org>
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


