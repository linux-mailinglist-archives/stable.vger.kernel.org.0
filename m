Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328684BCAC
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 17:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfFSPWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 11:22:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38448 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfFSPWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 11:22:07 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D4782C18B2C2;
        Wed, 19 Jun 2019 15:13:21 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21FDE5D9D6;
        Wed, 19 Jun 2019 15:13:17 +0000 (UTC)
Message-ID: <a05c420e46d995a2397c46d416eaeb627c94ea11.camel@redhat.com>
Subject: Re: [PATCH] scsi: vmw_pscsi: Fix use-after-free in
 pvscsi_queue_lck()
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Jan Kara <jack@suse.cz>, Jim Gill <jgill@vmware.com>
Cc:     VMware PV-Drivers <pv-drivers@vmware.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
Date:   Wed, 19 Jun 2019 11:13:16 -0400
In-Reply-To: <20190619070541.30070-1-jack@suse.cz>
References: <20190619070541.30070-1-jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 19 Jun 2019 15:13:29 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-06-19 at 09:05 +0200, Jan Kara wrote:
> Once we unlock adapter->hw_lock in pvscsi_queue_lck() nothing prevents just
> queued scsi_cmnd from completing and freeing the request. Thus cmd->cmnd[0]
> dereference can dereference already freed request leading to kernel crashes or
> other issues (which one of our customers observed). Store cmd->cmnd[0] in a
> local variable before unlocking adapter->hw_lock to fix the issue.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  drivers/scsi/vmw_pvscsi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index ecee4b3ff073..377b07b2feeb 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -763,6 +763,7 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
>  	struct pvscsi_adapter *adapter = shost_priv(host);
>  	struct pvscsi_ctx *ctx;
>  	unsigned long flags;
> +	unsigned char op;
>  
>  	spin_lock_irqsave(&adapter->hw_lock, flags);
>  
> @@ -775,13 +776,14 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
>  	}
>  
>  	cmd->scsi_done = done;
> +	op = cmd->cmnd[0];
>  
>  	dev_dbg(&cmd->device->sdev_gendev,
> -		"queued cmd %p, ctx %p, op=%x\n", cmd, ctx, cmd->cmnd[0]);
> +		"queued cmd %p, ctx %p, op=%x\n", cmd, ctx, op);
>  
>  	spin_unlock_irqrestore(&adapter->hw_lock, flags);
>  
> -	pvscsi_kick_io(adapter, cmd->cmnd[0]);
> +	pvscsi_kick_io(adapter, op);
>  
>  	return 0;
>  }

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

