Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2DFF17F67C
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCJLl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgCJLl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 07:41:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D886E24655;
        Tue, 10 Mar 2020 11:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583840486;
        bh=k5stvxdQ1VPH28EIv9MyT/8I/Xb9vVbD+Zy2Z1sDqzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cOmBPlKpy3uqCfqBtGOip4N+/gtp9sQboyDLbHufZBP7JVYvKs1dJbwMou4tSQ0MB
         DTWOjIh77fpPPfk+7fb0tWI2pppE1UIPHCNFt0nl/QL92Sh/6Zz64u6lFepNCM+LBp
         1yh/S8ccRNnTgIFaV24AUCifwdi1Ukv3Xhgpcyos=
Date:   Tue, 10 Mar 2020 12:41:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Viswas G <Viswas.G@microsemi.com>,
        Deepak Ukey <deepak.ukey@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [stable-4.19 1/2] scsi: pm80xx: panic on ncq error cleaning up
 the read log.
Message-ID: <20200310114124.GD3106483@kroah.com>
References: <20200309101739.32483-1-jinpu.wang@cloud.ionos.com>
 <20200309101739.32483-2-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309101739.32483-2-jinpu.wang@cloud.ionos.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 11:17:38AM +0100, Jack Wang wrote:
> From: Viswas G <Viswas.G@microsemi.com>
> 
> commit 0b6df110b3d0c12562011fcd032cfb6ff16b6d56 upstream
> 
> when there's an error in 'ncq mode' the host has to read the ncq error
> log (10h) to clear the error state. however, the ccb that is setup for
> doing this doesn't setup the ccb so that the previous state is
> cleared. if the ccb was previously used for an IO n_elems is set and
> pm8001_ccb_task_free() treats this as the signal to go free a
> scatter-gather list (that's already been freed).
> 
> Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
> Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

This commit showed up in 4.15, how can it also go into 4.19 again?

Totally confused,

greg k-h
