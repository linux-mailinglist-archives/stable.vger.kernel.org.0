Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512071D8B1A
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 00:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgERWlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 18:41:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58954 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgERWlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 18:41:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IMbd63186943;
        Mon, 18 May 2020 22:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wfqzLoaxxp4lVJqPw3YFi9A16uL/yoQRMCgjuuIIKA4=;
 b=K5u3wqcOEeuqDuqzTRLVdUswKm0ySp6xLFvhCA85l1Q67h2UDSIJW9Y85rzinCLUfuR7
 SEvQWOmom4eN7cv3JP8sRKrtuKRqpGVqkINeKX0NxddmI9MDeWpGktI/mUOGlE4c6Dvf
 ZgmrDENqjAEfQNclYOm/YJyQbkfcSZVZaklqkJb2WL5TMiPVvWWapdrAWURDj2CM6OPI
 raKLqCq9e1XZ+UT/2aEgClwlQdzvtCDYHf4q79soEyMo14PVoyHzslTSCCU+3EN1JeM7
 w9Ctenxi9MnarrJvByF8Kh6eounEBXJycvcp/UA6SMVl5mxvINgsj32HFcfIj1OW+gR6 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tn9se7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 22:41:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IMYQUk152989;
        Mon, 18 May 2020 22:41:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 312t3wm6k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 22:41:02 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04IMf1Rp019137;
        Mon, 18 May 2020 22:41:01 GMT
Received: from [192.168.1.35] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 15:41:01 -0700
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
To:     Roman Bolshakov <r.bolshakov@yadro.com>, linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        target-devel@vger.kernel.org, linux@yadro.com,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>, stable@vger.kernel.org
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <59107930-dfae-35be-9fb7-cef729e55412@oracle.com>
Date:   Mon, 18 May 2020 17:40:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200518183141.66621-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180191
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/18/20 1:31 PM, Roman Bolshakov wrote:
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
>    qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0014
>    qla_target(0): Unable to send command to target, sending BUSY status
> 
> Such response causes command timeout on the initiator. Error handler
> thread on the initiator will be spawned to abort the commands:
> 
>    scsi 23:0:0:0: tag#0 abort scheduled
>    scsi 23:0:0:0: tag#0 aborting command
>    qla2xxx [0000:af:00.0]-188c:23: Entered qla24xx_abort_command.
>    qla2xxx [0000:af:00.0]-801c:23: Abort command issued nexus=23:0:0 -- 0 2003.
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
> ---
>   drivers/scsi/qla2xxx/qla_gs.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Hi Martin,
> 
> Please apply the patch to scsi-fixes/5.7 at your earliest convenience.
> 
> qla2xxx in target and, likely, dual mode is unusable in some SAN fabrics
> due to the bug.
> 
> Thanks,
> Roman
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index 42c3ad27f1cb..b9955af5cffe 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3495,8 +3495,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
>   			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0) {
>   				qla2x00_clear_loop_id(fcport);
>   				fcport->flags |= FCF_FABRIC_DEVICE;
> -			} else if (fcport->d_id.b24 != rp->id.b24 ||
> -				fcport->scan_needed) {
> +			} else if ((fcport->d_id.b24 != rp->id.b24 ||
> +				    fcport->scan_needed) &&
> +				   (fcport->port_type != FCT_INITIATOR &&
> +				    fcport->port_type != FCT_NVME_INITIATOR)) {
>   				qlt_schedule_sess_for_deletion(fcport);
>   			}
>   			fcport->d_id.b24 = rp->id.b24;
> 
Looks okay.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                     Oracle Linux Engineering
