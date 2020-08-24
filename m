Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9063A24F9D1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgHXIj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728633AbgHXIjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:39:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE8A20FC3;
        Mon, 24 Aug 2020 08:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258360;
        bh=5A2VtyRJR0QYn/NUiPF8cKX4wWAD7dQLc9ZXAmgRtV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRejIB/9BVcvlTlTy9AFt5aaVRhdTiCWBuYnxkQYIdfIhfZw5SmezP+Zey2qaNMzx
         oJWHtTHmAG0HRGsBLIhr4zlYLk5OXR+vv4B1l61cDXFFDEKJ9dX55UWxP9+h7Nz7yJ
         JtHXBHTPOFd12XSK0a+z/gcI5Poaakb9PGxcAzXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.7 020/124] scsi: zfcp: Fix use-after-free in request timeout handlers
Date:   Mon, 24 Aug 2020 10:29:14 +0200
Message-Id: <20200824082410.412275851@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Maier <maier@linux.ibm.com>

commit 2d9a2c5f581be3991ba67fa9e7497c711220ea8e upstream.

Before v4.15 commit 75492a51568b ("s390/scsi: Convert timers to use
timer_setup()"), we intentionally only passed zfcp_adapter as context
argument to zfcp_fsf_request_timeout_handler(). Since we only trigger
adapter recovery, it was unnecessary to sync against races between timeout
and (late) completion.  Likewise, we only passed zfcp_erp_action as context
argument to zfcp_erp_timeout_handler(). Since we only wakeup an ERP action,
it was unnecessary to sync against races between timeout and (late)
completion.

Meanwhile the timeout handlers get timer_list as context argument and do a
timer-specific container-of to zfcp_fsf_req which can have been freed.

Fix it by making sure that any request timeout handlers, that might just
have started before del_timer(), are completed by using del_timer_sync()
instead. This ensures the request free happens afterwards.

Space time diagram of potential use-after-free:

Basic idea is to have 2 or more pending requests whose timeouts run out at
almost the same time.

req 1 timeout     ERP thread        req 2 timeout
----------------  ----------------  ---------------------------------------
zfcp_fsf_request_timeout_handler
fsf_req = from_timer(fsf_req, t, timer)
adapter = fsf_req->adapter
zfcp_qdio_siosl(adapter)
zfcp_erp_adapter_reopen(adapter,...)
                  zfcp_erp_strategy
                  ...
                  zfcp_fsf_req_dismiss_all
                  list_for_each_entry_safe
                    zfcp_fsf_req_complete 1
                    del_timer 1
                    zfcp_fsf_req_free 1
                    zfcp_fsf_req_complete 2
                                    zfcp_fsf_request_timeout_handler
                    del_timer 2
                                    fsf_req = from_timer(fsf_req, t, timer)
                    zfcp_fsf_req_free 2
                                    adapter = fsf_req->adapter
                                              ^^^^^^^ already freed

Link: https://lore.kernel.org/r/20200813152856.50088-1-maier@linux.ibm.com
Fixes: 75492a51568b ("s390/scsi: Convert timers to use timer_setup()")
Cc: <stable@vger.kernel.org> #4.15+
Suggested-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -430,7 +430,7 @@ static void zfcp_fsf_req_complete(struct
 		return;
 	}
 
-	del_timer(&req->timer);
+	del_timer_sync(&req->timer);
 	zfcp_fsf_protstatus_eval(req);
 	zfcp_fsf_fsfstatus_eval(req);
 	req->handler(req);
@@ -905,7 +905,7 @@ static int zfcp_fsf_req_send(struct zfcp
 	req->qdio_req.qdio_outb_usage = atomic_read(&qdio->req_q_free);
 	req->issued = get_tod_clock();
 	if (zfcp_qdio_send(qdio, &req->qdio_req)) {
-		del_timer(&req->timer);
+		del_timer_sync(&req->timer);
 		/* lookup request again, list might have changed */
 		zfcp_reqlist_find_rm(adapter->req_list, req_id);
 		zfcp_erp_adapter_reopen(adapter, 0, "fsrs__1");


