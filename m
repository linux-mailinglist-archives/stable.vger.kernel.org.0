Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545DD1E2BC6
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391779AbgEZTIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391804AbgEZTIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:08:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9006C20873;
        Tue, 26 May 2020 19:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520115;
        bh=3bJ9YBKBBnNebZDvA3t8ZGRSL8tqIXgvPp+50KDPZhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3CP4Ttn7aO39XRVip2c0il/gtAhkbFtILv0cjz7uXGCReAgZ19wILtY+gux/V7Y2
         hjrqCrMYWijI0qHshRjnwfqukPIDtYo+RiTbZyxw7xzQo3ZULJ0ACSUc4gewYt9mLN
         07gTczVF+U1NcEstpAunX6PSJD1sYywHHzZX2mfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Bryant G. Ly" <bryangly@gmail.com>,
        Bart van Assche <bvanassche@acm.org>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 063/111] scsi: target: Put lun_ref at end of tmr processing
Date:   Tue, 26 May 2020 20:53:21 +0200
Message-Id: <20200526183938.840421842@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

commit f2e6b75f6ee82308ef7b00f29e71e5f1c6b3d52a upstream.

Testing with Loopback I found that, after a Loopback LUN has executed a
TMR, I can no longer unlink the LUN.  The rm command hangs in
transport_clear_lun_ref() at wait_for_completion(&lun->lun_shutdown_comp)
The reason is, that transport_lun_remove_cmd() is not called at the end of
target_tmr_work().

It seems, that in other fabrics this call happens implicitly when the
fabric drivers call transport_generic_free_cmd() during their
->queue_tm_rsp().

Unfortunately Loopback seems to not comply to the common way
of calling transport_generic_free_cmd() from ->queue_*().
Instead it calls transport_generic_free_cmd() from its
  ->check_stop_free() only.

But the ->check_stop_free() is called by
transport_cmd_check_stop_to_fabric() after it has reset the se_cmd->se_lun
pointer.  Therefore the following transport_generic_free_cmd() skips the
transport_lun_remove_cmd().

So this patch re-adds the transport_lun_remove_cmd() at the end of
target_tmr_work(), which was removed during commit 2c9fa49e100f ("scsi:
target/core: Make ABORT and LUN RESET handling synchronous").

For fabrics using transport_generic_free_cmd() in the usual way the double
call to transport_lun_remove_cmd() doesn't harm, as
transport_lun_remove_cmd() checks for this situation and does not release
lun_ref twice.

Link: https://lore.kernel.org/r/20200513153443.3554-1-bstroesser@ts.fujitsu.com
Fixes: 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET handling synchronous")
Cc: stable@vger.kernel.org
Tested-by: Bryant G. Ly <bryangly@gmail.com>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3336,6 +3336,7 @@ static void target_tmr_work(struct work_
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 


