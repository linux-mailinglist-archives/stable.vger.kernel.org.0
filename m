Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6D2204B8F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgFWHsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:48:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:53644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731522AbgFWHsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 03:48:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AA422AD12;
        Tue, 23 Jun 2020 07:48:39 +0000 (UTC)
Date:   Tue, 23 Jun 2020 09:48:39 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        target-devel@vger.kernel.org, linux@yadro.com,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: qla2xxx: Keep initiator ports after RSCN
Message-ID: <20200623074839.jllbs54psrdlfkvs@beryllium.lan>
References: <20200605144435.27023-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605144435.27023-1-r.bolshakov@yadro.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 05, 2020 at 05:44:37PM +0300, Roman Bolshakov wrote:
> The driver performs SCR (state change registration) in all modes
> including pure target mode.
> 
> For each RSCN, scan_needed flag is set in qla2x00_handle_rscn() for the
> port mentioned in the RSCN and fabric rescan is scheduled. During the
> rescan, GNN_FT handler, qla24xx_async_gnnft_done() deletes session of
> the port that caused the RSCN.
> 
> In target mode, the session deletion has an impact on ATIO handler,
> qlt_24xx_atio_pkt(). Target responds with SAM STATUS BUSY to I/O
> incoming from the deleted session. qlt_handle_cmd_for_atio() and
> qlt_handle_task_mgmt() return -EFAULT if they are not able to find
> session of the command/TMF, and that results in invocation of
> qlt_send_busy():
> 
>   qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0014
>   qla_target(0): Unable to send command to target, sending BUSY status
> 
> Such response causes command timeout on the initiator. Error handler
> thread on the initiator will be spawned to abort the commands:
> 
>   scsi 23:0:0:0: tag#0 abort scheduled
>   scsi 23:0:0:0: tag#0 aborting command
>   qla2xxx [0000:af:00.0]-188c:23: Entered qla24xx_abort_command.
>   qla2xxx [0000:af:00.0]-801c:23: Abort command issued nexus=23:0:0 -- 0 2003.
> 
> Command abort is rejected by target and fails (2003), error handler then
> tries to perform DEVICE RESET and TARGET RESET but they're also doomed
> to fail because TMFs are ignored for the deleted sessions.
> 
> Then initiator makes BUS RESET that resets the link via
> qla2x00_full_login_lip(). BUS RESET succeeds and brings initiator port
> up, SAN switch detects that and sends RSCN to the target port and it
> fails again the same way as described above. It never goes out of the
> loop.
> 
> The change breaks the RSCN loop by keeping initiator sessions mentioned
> in RSCN payload in all modes, including dual and pure target mode.
> 
> Fixes: 2037ce49d30a ("scsi: qla2xxx: Fix stale session")
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>

I tried to follow the code paths as descriped in the commit message and also
tried to match it with the detailed response on Martin's question if
this would leak sessions. As far I can tell, this looks good but I am still a
noob when it comes to FC :)

Reviewed-by: Daniel Wagner <dwagner@suse.de>
