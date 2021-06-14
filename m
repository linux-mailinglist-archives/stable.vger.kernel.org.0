Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425213A60F2
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhFNKk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233826AbhFNKiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:38:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C4D2613D9;
        Mon, 14 Jun 2021 10:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666835;
        bh=xWEwteo7NPXPsxqEdDDHdF/rrWH2BGQ2zXlGiNMmXxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lmx4d1NnGi+IPP3Flzz22CzSh6ZXY8XV56LxoKjJ6lq0soIzztkJUJWE/qv5qqf7K
         Kj74FDD2J+LNrTvT0s+/fJMBJ8XOCaGmavlbEYil4A8sGtIIfECw/8zPZqDvi31iRO
         vsxZOxbYVsE6aq7NoW9kY6FyRHXnLouIMaeG7DLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 47/49] scsi: core: Only put parent device if host state differs from SHOST_CREATED
Date:   Mon, 14 Jun 2021 12:27:40 +0200
Message-Id: <20210614102643.394116029@linuxfoundation.org>
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
@@ -355,7 +355,7 @@ static void scsi_host_dev_release(struct
 
 	ida_simple_remove(&host_index_ida, shost->host_no);
 
-	if (parent)
+	if (shost->shost_state != SHOST_CREATED)
 		put_device(parent);
 	kfree(shost);
 }


