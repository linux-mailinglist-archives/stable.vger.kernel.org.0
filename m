Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22230337AE6
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhCKRdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:33:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229632AbhCKRdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615484024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XqfVvgDEaeVZgfA4fm07c5tH+yOQh34HrNoi9gVsjLg=;
        b=K9Je8dfKljRYgr1AhAFTZVOVMX04J1uDSVP5GTQOQtk8kbFHSm2uAUA/T57GMPPwRLthbh
        Oh+GGgEZ+4wI5SoEX+sCWzuxeY6DuAEpi3iIfgIOyPjhuvrbvD4yuUg9X2N8w9gmMEtqMb
        RcWYIx8GIEmOzFzNpGKPs6KRQL4Blwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-3xkXpRKgPoKAF7_Cud4tBg-1; Thu, 11 Mar 2021 12:33:41 -0500
X-MC-Unique: 3xkXpRKgPoKAF7_Cud4tBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 479A81074659;
        Thu, 11 Mar 2021 17:33:40 +0000 (UTC)
Received: from ovpn-113-87.phx2.redhat.com (ovpn-113-87.phx2.redhat.com [10.3.113.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2E2C60C03;
        Thu, 11 Mar 2021 17:33:39 +0000 (UTC)
Message-ID: <f9bdd225112d79cfc3854cfc52bfea441b547b95.camel@redhat.com>
Subject: Re: [PATCH v2] nvme-fc: fix racing controller reset and create
 association
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org, Nigel Kirkland <nkirkland2304@gmail.com>
Date:   Thu, 11 Mar 2021 12:33:39 -0500
In-Reply-To: <20210309005126.58460-1-jsmart2021@gmail.com>
References: <20210309005126.58460-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-03-08 at 16:51 -0800, James Smart wrote:
> Recent patch to prevent calling __nvme_fc_abort_outstanding_ios in
> interrupt context results in a possible race condition. A controller
> reset results in errored io completions, which schedules error
> work. The change of error work to a work element allows it to fire
> after the ctrl state transition to NVME_CTRL_CONNECTING, causing
> any outstanding io (used to initialize the controller) to fail and
> cause problems for connect_work.
> 
> Add a state check to only schedule error work if not in the RESETTING
> state.
> 
> Fixes: 19fce0470f05 ("nvme-fc: avoid calling
> _nvme_fc_abort_outstanding_ios from interrupt context")
> Cc: <stable@vger.kernel.org> # v5.10+
> 
> Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v2: clean up typo in commit header
> ---
>  drivers/nvme/host/fc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index 20dadd86e981..0f92bd12123e 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -2055,7 +2055,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
>  		nvme_fc_complete_rq(rq);
>  
>  check_error:
> -	if (terminate_assoc)
> +	if (terminate_assoc && ctrl->ctrl.state != NVME_CTRL_RESETTING)
>  		queue_work(nvme_reset_wq, &ctrl->ioerr_work);
>  }
>  

This fix resolves the frequent -EBUSY / -ENETRESET errors I saw when
resetting the controller via sysfs, as well as the eventual hang with
the controller stuck in the _CONNECTING state, thanks.  Looks good.

-Ewan


