Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009632626E9
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 07:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgIIFyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 01:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgIIFyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 01:54:07 -0400
Received: from localhost (unknown [172.98.75.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC8532166E;
        Wed,  9 Sep 2020 05:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599630846;
        bh=pbyS4ZMWYMUKwmpi3BhxrHHLzLjXuJLnUN/DArAAcCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Up3DXdI8JG6lYgGcC0tVjYoVSP1nLZyG6no0UVGh0mcYcuP7bLalh/ZHMcaxkd8ZT
         4hKkD4LUFJoxQFZYfY0KmG9+m5OcFoTb6CHL9YtBOQqvWQ53gbXqE+GdKD+ZcMeAHE
         2uF6//oVS8x+8pzmKdA8VqSS/nBIguX1Si2IuUBY=
Date:   Wed, 9 Sep 2020 07:54:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Felipe Franciosi <felipe@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Matej Genci <matej.genci@nutanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] Rescan the entire target on transport reset when LUN is 0
Message-ID: <20200909055403.GA310264@kroah.com>
References: <CY4PR02MB33354370E0A81E75DD9DFE74FB520@CY4PR02MB3335.namprd02.prod.outlook.com>
 <200ad446-1242-9555-96b6-4fa94ee27ec7@redhat.com>
 <CCFAFEBB-8250-4627-B25D-3B9054954C45@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CCFAFEBB-8250-4627-B25D-3B9054954C45@nutanix.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 05:53:16PM +0000, Felipe Franciosi wrote:
> 
> 
> > On Sep 8, 2020, at 3:22 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > On 28/08/20 14:21, Matej Genci wrote:
> >> VirtIO 1.0 spec says
> >>    The removed and rescan events ... when sent for LUN 0, they MAY
> >>    apply to the entire target so the driver can ask the initiator
> >>    to rescan the target to detect this.
> >> 
> >> This change introduces the behaviour described above by scanning the
> >> entire scsi target when LUN is set to 0. This is both a functional and a
> >> performance fix. It aligns the driver with the spec and allows control
> >> planes to hotplug targets with large numbers of LUNs without having to
> >> request a RESCAN for each one of them.
> >> 
> >> Signed-off-by: Matej Genci <matej@nutanix.com>
> >> Suggested-by: Felipe Franciosi <felipe@nutanix.com>
> >> ---
> >> drivers/scsi/virtio_scsi.c | 7 ++++++-
> >> 1 file changed, 6 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> >> index bfec84aacd90..a4b9bc7b4b4a 100644
> >> --- a/drivers/scsi/virtio_scsi.c
> >> +++ b/drivers/scsi/virtio_scsi.c
> >> @@ -284,7 +284,12 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
> >> 
> >> 	switch (virtio32_to_cpu(vscsi->vdev, event->reason)) {
> >> 	case VIRTIO_SCSI_EVT_RESET_RESCAN:
> >> -		scsi_add_device(shost, 0, target, lun);
> >> +		if (lun == 0) {
> >> +			scsi_scan_target(&shost->shost_gendev, 0, target,
> >> +					 SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
> >> +		} else {
> >> +			scsi_add_device(shost, 0, target, lun);
> >> +		}
> >> 		break;
> >> 	case VIRTIO_SCSI_EVT_RESET_REMOVED:
> >> 		sdev = scsi_device_lookup(shost, 0, target, lun);
> >> 
> > 
> > 
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Cc: stable@vger.kernel.org
> 
> Thanks, Paolo.
> 
> I'm Cc'ing stable as I believe this fixes a driver bug where it
> doesn't follow the spec. Per commit message, today devices are
> required to issue RESCAN events for each LUN behind a target when
> hotplugging, or risking the driver not seeing the new LUNs.
> 
> Is this enough? Or should we resend after merge per below?
> https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rst

You need to let stable know the git commit id of the patch in Linus's
tree if the cc: stable is not on the final commit that gets merged.

thanks,

greg k-h

