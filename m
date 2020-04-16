Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB261ACA98
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395308AbgDPPgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897880AbgDPNjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:39:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 999252063A;
        Thu, 16 Apr 2020 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044385;
        bh=Myj1CDp0UdOsG9VN9HTP9WtLs++9igsmwDL49tx1CsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XydSTFfOL1+RT1TqtAdKPT8CqaQXCWhz+gCSJgf8YBf++rJBML8boiRAPFyM+8tyk
         /nrL1Y6DKMBkSXIxJX9oND5VD430G4iE1rUAZ8xkmij/o4lH7bFqi18VX/m7/kTXoK
         pwbP/a2PCHuc3siaE9xd2BADrBuE1QElv/nwz1ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Remus <jremus@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.5 195/257] scsi: zfcp: fix missing erp_lock in port recovery trigger for point-to-point
Date:   Thu, 16 Apr 2020 15:24:06 +0200
Message-Id: <20200416131350.576747147@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Maier <maier@linux.ibm.com>

commit 819732be9fea728623e1ed84eba28def7384ad1f upstream.

v2.6.27 commit cc8c282963bd ("[SCSI] zfcp: Automatically attach remote
ports") introduced zfcp automatic port scan.

Before that, the user had to use the sysfs attribute "port_add" of an FCP
device (adapter) to add and open remote (target) ports, even for the remote
peer port in point-to-point topology. That code path did a proper port open
recovery trigger taking the erp_lock.

Since above commit, a new helper function zfcp_erp_open_ptp_port()
performed an UNlocked port open recovery trigger. This can race with other
parallel recovery triggers. In zfcp_erp_action_enqueue() this could corrupt
e.g. adapter->erp_total_count or adapter->erp_ready_head.

As already found for fabric topology in v4.17 commit fa89adba1941 ("scsi:
zfcp: fix infinite iteration on ERP ready list"), there was an endless loop
during tracing of rport (un)block.  A subsequent v4.18 commit 9e156c54ace3
("scsi: zfcp: assert that the ERP lock is held when tracing a recovery
trigger") introduced a lockdep assertion for that case.

As a side effect, that lockdep assertion now uncovered the unlocked code
path for PtP. It is from within an adapter ERP action:

zfcp_erp_strategy[1479]  intentionally DROPs erp lock around
                         zfcp_erp_strategy_do_action()
zfcp_erp_strategy_do_action[1441]      NO erp lock
zfcp_erp_adapter_strategy[876]         NO erp lock
zfcp_erp_adapter_strategy_open[855]    NO erp lock
zfcp_erp_adapter_strategy_open_fsf[806]NO erp lock
zfcp_erp_adapter_strat_fsf_xconf[772]  erp lock only around
                                       zfcp_erp_action_to_running(),
                                       BUT *_not_* around
                                       zfcp_erp_enqueue_ptp_port()
zfcp_erp_enqueue_ptp_port[728]         BUG: *_not_* taking erp lock
_zfcp_erp_port_reopen[432]             assumes to be called with erp lock
zfcp_erp_action_enqueue[314]           assumes to be called with erp lock
zfcp_dbf_rec_trig[288]                 _checks_ to be called with erp lock:
	lockdep_assert_held(&adapter->erp_lock);

It causes the following lockdep warning:

WARNING: CPU: 2 PID: 775 at drivers/s390/scsi/zfcp_dbf.c:288
                            zfcp_dbf_rec_trig+0x16a/0x188
no locks held by zfcperp0.0.17c0/775.

Fix this by using the proper locked recovery trigger helper function.

Link: https://lore.kernel.org/r/20200312174505.51294-2-maier@linux.ibm.com
Fixes: cc8c282963bd ("[SCSI] zfcp: Automatically attach remote ports")
Cc: <stable@vger.kernel.org> #v2.6.27+
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/scsi/zfcp_erp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -725,7 +725,7 @@ static void zfcp_erp_enqueue_ptp_port(st
 				 adapter->peer_d_id);
 	if (IS_ERR(port)) /* error or port already attached */
 		return;
-	_zfcp_erp_port_reopen(port, 0, "ereptp1");
+	zfcp_erp_port_reopen(port, 0, "ereptp1");
 }
 
 static enum zfcp_erp_act_result zfcp_erp_adapter_strat_fsf_xconf(


