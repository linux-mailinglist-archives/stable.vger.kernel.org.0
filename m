Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E76F1E2CE4
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392375AbgEZTSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404319AbgEZTNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:13:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D520E20888;
        Tue, 26 May 2020 19:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520427;
        bh=zWsa3AUmB//Wf1mTtlrz0g0Yvlc+DxhzDn2A2kufhjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jfsa/Bm7+FMcIc5vGsqdDjJ/Jw0Z0NHp8xd0aauJRzz4xgHAGhDDLzr09nCEc+imn
         pdqewc35sMv7ck+LCGE7bpK9HcSFrhZTx5WRoONgNvdSoDyfvCfPTIVh+X1LOENQj4
         bEOaxeo1APGi+Py1a6bKN65sFeH0OvZaOYJsasMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Laurence Oberman <loberman@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.6 068/126] scsi: qla2xxx: Do not log message when reading port speed via sysfs
Date:   Tue, 26 May 2020 20:53:25 +0200
Message-Id: <20200526183943.897738690@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ewan D. Milne <emilne@redhat.com>

commit fb9024b0646939e59d8a0b6799b317070619795a upstream.

Calling ql_log() inside qla2x00_port_speed_show() is causing messages to be
output to the console for no particularly good reason.  The sysfs read
routine should just return the information to userspace.  The only reason
to log a message is when the port speed actually changes, and this already
occurs elsewhere.

Link: https://lore.kernel.org/r/20200504175416.15417-1-emilne@redhat.com
Fixes: 4910b524ac9e ("scsi: qla2xxx: Add support for setting port speed")
Cc: <stable@vger.kernel.org> # v5.1+
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_attr.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1777,9 +1777,6 @@ qla2x00_port_speed_show(struct device *d
 		return -EINVAL;
 	}
 
-	ql_log(ql_log_info, vha, 0x70d6,
-	    "port speed:%d\n", ha->link_data_rate);
-
 	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha->link_data_rate]);
 }
 


