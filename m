Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8A71D9261
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgESIq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:46:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:49804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgESIq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 04:46:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 46FE1AF9F;
        Tue, 19 May 2020 08:46:59 +0000 (UTC)
Message-ID: <3ee76f0fc5df716523bfbdd34726b6cccd4971cd.camel@suse.com>
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
From:   Martin Wilck <mwilck@suse.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>, linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        target-devel@vger.kernel.org, linux@yadro.com,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        stable@vger.kernel.org
Date:   Tue, 19 May 2020 10:46:54 +0200
In-Reply-To: <20200518183141.66621-1-r.bolshakov@yadro.com>
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.36.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-05-18 at 21:31 +0300, Roman Bolshakov wrote:
> The driver performs SCR (state change registration) in all modes
> including pure target mode.
> 
> For each RSCN, scan_needed flag is set in qla2x00_handle_rscn() for
> the
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
>   qla_target(0): Unable to send command to target, sending BUSY
> status
> 
> Such response causes command timeout on the initiator. Error handler
> thread on the initiator will be spawned to abort the commands:
> 
>   scsi 23:0:0:0: tag#0 abort scheduled
>   scsi 23:0:0:0: tag#0 aborting command
>   qla2xxx [0000:af:00.0]-188c:23: Entered qla24xx_abort_command.
>   qla2xxx [0000:af:00.0]-801c:23: Abort command issued nexus=23:0:0
> -- 0 2003.
> 
> Command abort is rejected by target and fails (2003), error handler
> then
> tries to perform DEVICE RESET and TARGET RESET but they're also
> doomed
> to fail because TMFs are ignored for the deleted sessions.
> 
> Then initiator makes BUS RESET that resets the link via
> qla2x00_full_login_lip(). BUS RESET succeeds and brings initiator
> port
> up, SAN switch detects that and sends RSCN to the target port and it
> fails again the same way as described above. It never goes out of the
> loop.
> 
> The change breaks the RSCN loop by keeping initiator sessions
> mentioned
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
> ---
>  drivers/scsi/qla2xxx/qla_gs.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Hi Martin,
> 
> Please apply the patch to scsi-fixes/5.7 at your earliest
> convenience.
> 
> qla2xxx in target and, likely, dual mode is unusable in some SAN
> fabrics
> due to the bug.
> 
> Thanks,
> Roman
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c
> b/drivers/scsi/qla2xxx/qla_gs.c
> index 42c3ad27f1cb..b9955af5cffe 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3495,8 +3495,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t
> *vha, srb_t *sp)
>  			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0) {
>  				qla2x00_clear_loop_id(fcport);
>  				fcport->flags |= FCF_FABRIC_DEVICE;
> -			} else if (fcport->d_id.b24 != rp->id.b24 ||
> -				fcport->scan_needed) {
> +			} else if ((fcport->d_id.b24 != rp->id.b24 ||
> +				    fcport->scan_needed) &&
> +				   (fcport->port_type != FCT_INITIATOR
> &&
> +				    fcport->port_type !=
> FCT_NVME_INITIATOR)) {
>  				qlt_schedule_sess_for_deletion(fcport);
>  			}
>  			fcport->d_id.b24 = rp->id.b24;

Hi Roman,

what if the session does need to be deleted eventually? E.g. if after
the RSCN the connection to the initiator is actually lost, either
temporarily or for good? Would the session be deleted in some other
code path, or would it just continue to lurk around?

Martin


