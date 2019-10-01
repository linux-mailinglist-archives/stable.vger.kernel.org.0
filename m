Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D6C38B8
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 17:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389175AbfJAPRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 11:17:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43741 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732670AbfJAPRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 11:17:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id c3so22033976qtv.10
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 08:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r+FO2BI995eRmLYxxh49xnSc2i73sE6cqi4HJnCrGKE=;
        b=a7T8s9l1nzbmcfBIGUKFO0/p3IZD8mNTu/GfelBMWcTOK+aNSJ5rgdzzCyKwysKXkN
         HNoMtIahnqemYG7VcSPGdirgTBiEjt5if6Cmq/42bQGvbv3nZumRFckU0bMKv0cchzrW
         jHwLBwQE9STJDn5/S6dAOWF3lvx4QyNFiqvPuR7VwR6VA7eaC5m+b6yzpxa2R5/6x3tZ
         wJzDCRFjeAppD77+KOTpjk2K/lPhyvRMp1ZOIWmLpumhIJnDIpwZYx+PTnJe1w16pRHs
         y/V7OivY/CmazNQoi6KEoTrbmc1nZA6WpMX8urcspILcSca/9h9bRxBFMxNUoJSzy+YS
         tudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r+FO2BI995eRmLYxxh49xnSc2i73sE6cqi4HJnCrGKE=;
        b=mKQtbz4BYsO+qpNGXTIdca92CUTwESIDC2ER+CCu9Teg4dKFPiSLHwfTs3DmKbgHfp
         2B8JezYmGpEBVZqmD6+vJVHs8iIgOIXZFf85EKrgoA7rTWsdaMrlml6Ehv9zm9drAtJr
         WEXkTBXEkLJ/TNsKHzX9NRB6qKjAvx5B74ko72Zf/OCpWEfTbT9txgA8iI1IEetU+h7j
         rNC3gPxuqGhE6+gEXhFfB723gkz5OlXlq/tuzV37ClTihMKU+hUiDWUjTeqIsEZnwVZx
         5yAdR44tjTLyUg8I7K68ohApxdFDC4YxQSx8GxovsnSb4djltVMyrbbAJMDpv3N3GywV
         ADbA==
X-Gm-Message-State: APjAAAUjTV/6CIuq7n88KH3TvJQqh6tH8Valm4WGrqIJIs1OGx05gOUq
        bPDMfeDYoNMKFYUtWDPzGF9PIQ==
X-Google-Smtp-Source: APXvYqwB+5whx4p14k8HOKIbO7Xq1eN/HI/koAWy1Z9IZuajIZq9vjGnbrT45Vua7gZUmxHy2+/8Iw==
X-Received: by 2002:ac8:fb4:: with SMTP id b49mr30108477qtk.203.1569943037101;
        Tue, 01 Oct 2019 08:17:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id o28sm7224194qkk.106.2019.10.01.08.17.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 01 Oct 2019 08:17:16 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iFJts-0000N7-4B; Tue, 01 Oct 2019 12:17:16 -0300
Date:   Tue, 1 Oct 2019 12:17:16 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>,
        Steve Wise <larrystevenwise@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Bernard Metzler <BMT@zurich.ibm.com>,
        Krishnamraju Eraparaju <krishna2@chelsio.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/15] RDMA/iwcm: Fix a lock inversion issue
Message-ID: <20191001151716.GE22532@ziepe.ca>
References: <20190930231707.48259-1-bvanassche@acm.org>
 <20190930231707.48259-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930231707.48259-3-bvanassche@acm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 04:16:54PM -0700, Bart Van Assche wrote:
> This patch fixes the lock inversion complaint:
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.3.0-rc7-dbg+ #1 Not tainted
> kworker/u16:6/171 is trying to acquire lock:
> 00000000035c6e6c (&id_priv->handler_mutex){+.+.}, at: rdma_destroy_id+0x78/0x4a0 [rdma_cm]
> 
> but task is already holding lock:
> 00000000bc7c307d (&id_priv->handler_mutex){+.+.}, at: iw_conn_req_handler+0x151/0x680 [rdma_cm]
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>   lock(&id_priv->handler_mutex);
>   lock(&id_priv->handler_mutex);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 3 locks held by kworker/u16:6/171:
>  #0: 00000000e2eaa773 ((wq_completion)iw_cm_wq){+.+.}, at: process_one_work+0x472/0xac0
>  #1: 000000001efd357b ((work_completion)(&work->work)#3){+.+.}, at: process_one_work+0x476/0xac0
>  #2: 00000000bc7c307d (&id_priv->handler_mutex){+.+.}, at: iw_conn_req_handler+0x151/0x680 [rdma_cm]
> 
> stack backtrace:
> CPU: 3 PID: 171 Comm: kworker/u16:6 Not tainted 5.3.0-rc7-dbg+ #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Workqueue: iw_cm_wq cm_work_handler [iw_cm]
> Call Trace:
>  dump_stack+0x8a/0xd6
>  __lock_acquire.cold+0xe1/0x24d
>  lock_acquire+0x106/0x240
>  __mutex_lock+0x12e/0xcb0
>  mutex_lock_nested+0x1f/0x30
>  rdma_destroy_id+0x78/0x4a0 [rdma_cm]
>  iw_conn_req_handler+0x5c9/0x680 [rdma_cm]
>  cm_work_handler+0xe62/0x1100 [iw_cm]
>  process_one_work+0x56d/0xac0
>  worker_thread+0x7a/0x5d0
>  kthread+0x1bc/0x210
>  ret_from_fork+0x24/0x30
> 
> Cc: Or Gerlitz <gerlitz.or@gmail.com>
> Cc: Steve Wise <larrystevenwise@gmail.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Bernard Metzler <BMT@zurich.ibm.com>
> Cc: Krishnamraju Eraparaju <krishna2@chelsio.com>
> Cc: <stable@vger.kernel.org>
> Fixes: de910bd92137 ("RDMA/cma: Simplify locking needed for serialization of callbacks"; v2.6.27).
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>  drivers/infiniband/core/cma.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 0e3cf3461999..d78f67623f24 100644
> +++ b/drivers/infiniband/core/cma.c
> @@ -2396,9 +2396,10 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
>  		conn_id->cm_id.iw = NULL;
>  		cma_exch(conn_id, RDMA_CM_DESTROYING);
>  		mutex_unlock(&conn_id->handler_mutex);
> +		mutex_unlock(&listen_id->handler_mutex);
>  		cma_deref_id(conn_id);
>  		rdma_destroy_id(&conn_id->id);
> -		goto out;
> +		return ret;
>  	}

Hurm. Minimizing code under lock is always a good fix, but the lockdep
report is not a bug.

The issue is caused by the hacky use of SINGLE_DEPTH_NESTING when we
really have two lock classes, 'listening' and 'connecting' for CM ids.

connecting IDs can be nested under listening IDs but not the other way
around.

So two lock classes will also get rid of the lockdep warning, which is
why it isn't a bug..

Applied to for-rc

Thanks,
Jason
