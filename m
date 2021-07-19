Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446653CE45E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347380AbhGSPn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347472AbhGSPja (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 563CE61283;
        Mon, 19 Jul 2021 16:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711545;
        bh=YE3aL0P/ukx86rH/nOPjZS+oU/mYIqW7gQhYJcpmOYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WilnyKu3wfAsWhZ6a6JbZDmsBFqGPoHQb3nopvxpMPS9Y+Oe49k7t3+mc9nBwBc46
         iF0gX7mF1P2Wf8DXIh7ISxXoT45LC+uY4nEZx7lmwZKEpawKZpdzAo0Efy1eKKTAX6
         EwEuMlpofKqjXCSHnGzy08XfxFl5c0jgC8Eg1Cvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.12 010/292] scsi: zfcp: Report port fc_security as unknown early during remote cable pull
Date:   Mon, 19 Jul 2021 16:51:12 +0200
Message-Id: <20210719144942.867673356@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Maier <maier@linux.ibm.com>

commit 8b3bdd99c092bbaeaa7d9eecb1a3e5dc9112002b upstream.

On remote cable pull, a zfcp_port keeps its status and only gets
ZFCP_STATUS_PORT_LINK_TEST added. Only after an ADISC timeout, we would
actually start port recovery and remove ZFCP_STATUS_COMMON_UNBLOCKED which
zfcp_sysfs_port_fc_security_show() detected and reported as "unknown"
instead of the old and possibly stale zfcp_port->connection_info.

Add check for ZFCP_STATUS_PORT_LINK_TEST for timely "unknown" report.

Link: https://lore.kernel.org/r/20210702160922.2667874-1-maier@linux.ibm.com
Fixes: a17c78460093 ("scsi: zfcp: report FC Endpoint Security in sysfs")
Cc: <stable@vger.kernel.org> #5.7+
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/scsi/zfcp_sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -487,6 +487,7 @@ static ssize_t zfcp_sysfs_port_fc_securi
 	if (0 == (status & ZFCP_STATUS_COMMON_OPEN) ||
 	    0 == (status & ZFCP_STATUS_COMMON_UNBLOCKED) ||
 	    0 == (status & ZFCP_STATUS_PORT_PHYS_OPEN) ||
+	    0 != (status & ZFCP_STATUS_PORT_LINK_TEST) ||
 	    0 != (status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
 	    0 != (status & ZFCP_STATUS_COMMON_ACCESS_BOXED))
 		i = sprintf(buf, "unknown\n");


