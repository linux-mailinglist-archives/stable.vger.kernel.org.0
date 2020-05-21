Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DE81DD103
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 17:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgEUPRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 11:17:38 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:41392 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727988AbgEUPRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 11:17:37 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 170B44999F;
        Thu, 21 May 2020 15:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1590074250;
         x=1591888651; bh=azTFsx5pT+xwmFKCNHnOoz6GCjXdAT0cN0zwshK92aU=; b=
        c42Y1dMYqMUIF5HddFaTp64B8rVm58yCB1DYblVQ2QEn4f/YjGJBXEQOWLzIiDYk
        OvDR2BRu/zfR0amudL9bEPIqT9yQcb8ZfbcmftfQNTS5shs82DuYgfPEwplTz6W5
        CTKUVgzOZHVPZwEhEHvIvCNtI/cwnpswgkeQzdN7Z9g=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id U1vjTcTe5Nr2; Thu, 21 May 2020 18:17:30 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id ACE4D47D4C;
        Thu, 21 May 2020 18:17:29 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 May 2020 18:17:31 +0300
Date:   Thu, 21 May 2020 18:17:30 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Martin Wilck <mwilck@suse.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
Message-ID: <20200521151730.GA73599@SPB-NB-133.local>
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
 <3ee76f0fc5df716523bfbdd34726b6cccd4971cd.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3ee76f0fc5df716523bfbdd34726b6cccd4971cd.camel@suse.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 10:46:54AM +0200, Martin Wilck wrote:
> On Mon, 2020-05-18 at 21:31 +0300, Roman Bolshakov wrote:
> > The driver performs SCR (state change registration) in all modes
> > including pure target mode.
> > 
> > For each RSCN, scan_needed flag is set in qla2x00_handle_rscn() for
> > the
> > port mentioned in the RSCN and fabric rescan is scheduled. During the
> > rescan, GNN_FT handler, qla24xx_async_gnnft_done() deletes session of
> > the port that caused the RSCN.
> > 
> > In target mode, the session deletion has an impact on ATIO handler,
> > qlt_24xx_atio_pkt(). Target responds with SAM STATUS BUSY to I/O
> > incoming from the deleted session. qlt_handle_cmd_for_atio() and
> > qlt_handle_task_mgmt() return -EFAULT if they are not able to find
> > session of the command/TMF, and that results in invocation of
> > qlt_send_busy():
> > 
> >   qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0014
> >   qla_target(0): Unable to send command to target, sending BUSY
> > status
> > 
> > Such response causes command timeout on the initiator. Error handler
> > thread on the initiator will be spawned to abort the commands:
> > 
> >   scsi 23:0:0:0: tag#0 abort scheduled
> >   scsi 23:0:0:0: tag#0 aborting command
> >   qla2xxx [0000:af:00.0]-188c:23: Entered qla24xx_abort_command.
> >   qla2xxx [0000:af:00.0]-801c:23: Abort command issued nexus=23:0:0
> > -- 0 2003.
> > 
> > Command abort is rejected by target and fails (2003), error handler
> > then
> > tries to perform DEVICE RESET and TARGET RESET but they're also
> > doomed
> > to fail because TMFs are ignored for the deleted sessions.
> > 
> > Then initiator makes BUS RESET that resets the link via
> > qla2x00_full_login_lip(). BUS RESET succeeds and brings initiator
> > port
> > up, SAN switch detects that and sends RSCN to the target port and it
> > fails again the same way as described above. It never goes out of the
> > loop.
> > 
> > The change breaks the RSCN loop by keeping initiator sessions
> > mentioned
> > in RSCN payload in all modes, including dual and pure target mode.
> > 
> > Fixes: 2037ce49d30a ("scsi: qla2xxx: Fix stale session")
> > Cc: Quinn Tran <qutran@marvell.com>
> > Cc: Arun Easi <aeasi@marvell.com>
> > Cc: Nilesh Javali <njavali@marvell.com>
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: Daniel Wagner <dwagner@suse.de>
> > Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: stable@vger.kernel.org # v5.4+
> > Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_gs.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > Hi Martin,
> > 
> > Please apply the patch to scsi-fixes/5.7 at your earliest
> > convenience.
> > 
> > qla2xxx in target and, likely, dual mode is unusable in some SAN
> > fabrics
> > due to the bug.
> > 
> > Thanks,
> > Roman
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_gs.c
> > b/drivers/scsi/qla2xxx/qla_gs.c
> > index 42c3ad27f1cb..b9955af5cffe 100644
> > --- a/drivers/scsi/qla2xxx/qla_gs.c
> > +++ b/drivers/scsi/qla2xxx/qla_gs.c
> > @@ -3495,8 +3495,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t
> > *vha, srb_t *sp)
> >  			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0) {
> >  				qla2x00_clear_loop_id(fcport);
> >  				fcport->flags |= FCF_FABRIC_DEVICE;
> > -			} else if (fcport->d_id.b24 != rp->id.b24 ||
> > -				fcport->scan_needed) {
> > +			} else if ((fcport->d_id.b24 != rp->id.b24 ||
> > +				    fcport->scan_needed) &&
> > +				   (fcport->port_type != FCT_INITIATOR
> > &&
> > +				    fcport->port_type !=
> > FCT_NVME_INITIATOR)) {
> >  				qlt_schedule_sess_for_deletion(fcport);
> >  			}
> >  			fcport->d_id.b24 = rp->id.b24;
> 
> Hi Roman,
> 
> what if the session does need to be deleted eventually?

Hi Martin,

I'm sorry for the delay, it took a while to complete the answer :)

In the other reply to the patch I sent a proposal for v2. We might go
with it to handle N_Port_ID changes. N_Port_ID may change in the
switched fabric topology if initiator cable is replugged to another
physical port on the SAN switch (some fabrics assign physical port
number to domain area). Physical reconnection means initiator is going
to relogin anyway and previous session is no longer needed.

Third variant would be to check non-NULL TCM session on the fcport instead of
checking against fc_port type but that will be less reliable if qla2xxx_nvmet
is added to the mainline, i.e.:

     } else if (fcport->d_id.b24 != rp->id.b24 ||
                (fcport->scan_needed &&
                 !fcport->se_sess)) {
             qlt_schedule_sess_for_deletion(fcport);
     }

Fourth variant would be to disable SCR in pure target mode as Firmware
Interface Specification suggests. Although, the issue would still exit
in dual mode. Proposal #2 and #3 fix the issue in target and dual modes.

> E.g. if after the RSCN the connection to the initiator is actually
> lost, either temporarily or for good? Would the session be deleted in
> some other code path, or would it just continue to lurk around?
> 

RSCN per-se shouldn't be a reason to delete initiator IMO, since it's
just a notification that state of the entity in the fabric has changed.
Nx_Port should figure out what changed and then decide if it's worth to
keep session of the port.

There are multiple cases in v5.7 when session deletion happens. I tried
to cover them below in cscope order and inspected the code around.
Pardon me for mistakes if I overlooked something:

1.
2.
3.  GPN_ID request may be issued to find if something has changed with a
    port after an RSCN.

    I don't see if it's called anywhere though. There's an request of
    GPN_ID inside GPN_ID response handling but it's never called
    outside. So it looks a kind of dead code:

    qla24xx_post_gpnid_work() sends QLA_EVT_GPNID ->
    qla2x00_do_work() dispatches the event to qla24xx_async_gpnid() ->
    qla24xx_async_gpnid() sends IOCB with GPN_ID to fimrware and sets up
    call back to qla2x00_async_gpnid_sp_done() ->
    qla2x00_async_gpnid_sp_done() calls qla24xx_post_gpnid_work() if the
    IOCB timed out or RSCN arrived in the middle of the request.


    If GPN_ID request fails, all session on the host are deleted in
    qla24xx_handle_gpnid_event(). It's kind of weird that it deletes
    everything. May be it was expected to look like this to delete only
    the port that was requested in the GPN_ID request (ea->id.b24):

      if (ea->rc) {
              /* cable is disconnected */
              list_for_each_entry_safe(fcport, t, &vha->vp_fcports, list) {
                      if (fcport->d_id.b24 == ea->id.b24) {
                              fcport->scan_state = QLA_FCPORT_SCAN;

         		      qlt_schedule_sess_for_deletion(fcport);
         	     }
              }
      } else {

    Instead of (5.7/scsi-fixes):

      if (ea->rc) {
              /* cable is disconnected */
              list_for_each_entry_safe(fcport, t, &vha->vp_fcports, list) {
                      if (fcport->d_id.b24 == ea->id.b24)
                              fcport->scan_state = QLA_FCPORT_SCAN;

                      qlt_schedule_sess_for_deletion(fcport);
              }
      } else {


    If GPN_ID request suceeds, and there's a session for the port with
    the same N_Port_Name, it deletes all sessions on the host in
    qla24xx_handle_gpnid_event(). It looks like too heavy hammer IMO,
    maybe it was expected to behave like this to replace only session
    session with the same N_Port_Name (including deleted sessions):

      list_for_each_entry_safe(conflict, t, &vha->vp_fcports,
          list) {
              if ((conflict->d_id.b24 == ea->id.b24) &&
                  (fcport != conflict)) {
                      /*
                       * 2 fcports with conflict Nport ID or
                       * an existing fcport is having nport ID
                       * conflict with new fcport.
                       */

                      conflict->scan_state = QLA_FCPORT_SCAN;

         	      qlt_schedule_sess_for_deletion(conflict);
              }
      }

    Instead of (5.7/scsi-fixes):

      list_for_each_entry_safe(conflict, t, &vha->vp_fcports,
          list) {
              if ((conflict->d_id.b24 == ea->id.b24) &&
                  (fcport != conflict))
                      /*
                       * 2 fcports with conflict Nport ID or
                       * an existing fcport is having nport ID
                       * conflict with new fcport.
                       */

                      conflict->scan_state = QLA_FCPORT_SCAN;

              qlt_schedule_sess_for_deletion(conflict);
      }

    If GPN_ID request succeeds, no sessions were were found for the
    N_Port_Name but there's a session with conflicting N_Port_ID, it gets
    deleted in qla24xx_handle_gpnid_event().

4.
5.  Session is deleted during fabric rescan in qla24xx_async_gnnft_done()
    if RSCN had N_Port_ID of the session (**The patch aims to address
    the issue**) or N_Port_ID was changed in GPN_FT reply.

    Sessions missing in GPN_FT response are deleted after fabric
    discovery in qla24xx_async_gnnft_done() if driver is running in pure
    initiator or dual mode. So, if zone definition changed or some ports
    logged out, sessions of the ports that somehow disappeared from the
    zone are going to be deleted.

6.
7.  Session is deleted if ADISC to an N_Port fails
    qla24xx_handle_adisc_event(). It's also going to be deleted if
    GPN_ID was done for the port or RSCN for the port arrived during ADISC.

    I'm not sure but it may cause session loss for the target
    mode and then I/O timeout on the attached initiator.

8.
9.  RSCN or fabric rescan during GNL will trigger session deletion in
    qla24xx_handle_gnl_done_event().

10.
11. GPDB handling during login will delete session in
    qla24xx_handle_gpdb_event() if RSCN has happened or GPN_ID was made
    in the middle of the GPDB for the port. If ports are detected by
    GPDB as logged out or logout is pending, their session is also
    deleted.

12. Session is going to be deleted in P2P mode if a spare N_Port handle
    can't be found in qla_chk_n2n_b4_login().

13. Failed PLOGI in all topologies but P2P is going to trigger session
    deletion in qla24xx_fcport_handle_login().

14. Session is deleted after an unsuccessful PRLI in
    qla24xx_handle_prli_done_event(). I wonder if dual FCP/FC-NVMe
    sessions are impacted by that.

15.
16. RSCN during PLOGI or duplicated N_Port handle will trigger session
    deletion in qla24xx_handle_plogi_done_event()

17. Missing target, switch, name server and NVMe sessions are deleted in
    after rescan of arbitrated loop by qla2x00_configure_local_loop() in
    dual and pure initiator mode.

    This check is similar to 5. Code duplication can be removed.

18. An RSCN during port registration is going to trigger deletion of the
    related session in qla_register_fcport_fn().

19. Missing target, switch, name server and NVMe sessions are deleted
    after sync fabric scan by qla2x00_find_all_fabric_devs() in dual and
    pure initiator mode.

    The code is similar to 5 and 17, perhaps the duplication can be
    removed.

20. Session is deleted in qla2x00_els_dcmd2_sp_done() if duplicate
    N_Port handle was detected by firmware during Login IOCB.

21. Session is deleted in initiator mode if firmware detects port logout
    in qla2x00_async_event()

22. Session is deleted in during initiator I/O in qla2x00_status_entry()
    if firmware returns a kind of logged out state.

23. Conflicting session with the same N_Port_ID is deleted in cases when
    login is performed by firmware in qla24xx_report_id_acquisition().

24. In case of link loss, all session are deleted in
    qla2x00_mark_all_devices_lost().

25. Another session with the same N_Port_ID is deleted during the
    session init in qla24xx_create_new_sess().

26. All target sessions are deleted in qlt_clear_tgt_db() as part of
    target shutdown in qlt_stop_phase1() and in case of LIP or if Port
    configuration of the target port was changed.

27. Session deletion happens in the dead code, qlt_fc_port_deleted().
    Perhaps the function can be safely removed.

28. Session is deleted for a port that issued LOGO, TPRLO and PRLO in
    qlt_xmit_tm_rsp().

29. Session is deleted in qlt_do_ctio_completion() during the I/O in
    target mode if firmware detects initiator logout and responds to the
    driver with a related error.

30.
31.
32. A PLOGI handler is going to delete stale sessions in
    qlt_find_sess_invalidate_other() if S_ID or N_Port handle of
    the PLOGI matches N_Port_ID or N_Port handle of an existing session.

33. PLOGI, PRLI will result in session deletion if the session is
    already established.

    FWIW, NVMe PRLI may destroy FCP session in case of simultaneous
    FCP/NVMe target, current code doesn't handle multiple process logins
    well. It shouldn't be a big deal since qla2xxx_nvmet hasn't been
    merged to mainline yet.

34. TPRLO, PRLO, LOGO result in session deletion in qlt_24xx_handle_els()
    After inspecting the code I think, only LOGO should fully delete the
    session.

    In the case of mixed FC-NVMe/FCP initiator/target, PRLO/TPRLO
    to/from SCSI target may break sessions of FC-NVMe, likewise FC-NVMe
    PRLO/TPRLO may break FCP sessions.

    PRLO and TPRLO (which is like PRLO from all ports) should only
    downgrade session of the requested FC-4 type to a kind of "process
    (i.e. FCP/FC-NVMe) logged out" state rather than delete it. TPRLO
    should log out all sessions of the FC-4 type on the target port,
    while PRLO should do it only for the originator of the ELS request.


> E.g. if after the RSCN the connection to the initiator is actually
> lost, either temporarily or for good? Would the session be deleted in
> some other code path, or would it just continue to lurk around?
> 

So, as a summary, it seems that the existing code mostly keeps sessions
until:
 - a conflict of N_Port_ID, N_Port_Name or N_Port handle detected;
 - the session is in the middle of refresh/rescan and RSCN arrives;
 - there's an explicit process or port logout from the session, i.e.
   PRLO, TPRLO, LOGO
 - there's a new port or process login from the same session, i.e.
   PLOGI, PRLI;
 - target is shut down;
 - target port link is reset;

And if a session of an initiator is deleted when driver works in target
mode, new session won't be established until a PLOGI and PRLI come from
the initiator.

The assumption is used qlt_handle_cmd_for_atio() and
qlt_handle_task_mgmt() to discard commands and TMFs from initiators that
are not logged in.

Thanks,
Roman
