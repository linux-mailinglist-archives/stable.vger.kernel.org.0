Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E177530733D
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 10:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhA1Jzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 04:55:39 -0500
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:37354 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbhA1Jzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 04:55:38 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 10S9rS5I032263; Thu, 28 Jan 2021 18:53:28 +0900
X-Iguazu-Qid: 2wGqsXjpvoEvKgCo9E
X-Iguazu-QSIG: v=2; s=0; t=1611827608; q=2wGqsXjpvoEvKgCo9E; m=f7a5aESQgubMc8bv/IWoGFIVN8dF107aVQudu/NKBXM=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1112) id 10S9rROe017073;
        Thu, 28 Jan 2021 18:53:27 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 10S9rQTo012643;
        Thu, 28 Jan 2021 18:53:26 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 10S9rQK1000662;
        Thu, 28 Jan 2021 18:53:26 +0900
Date:   Thu, 28 Jan 2021 18:53:25 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Olivier Benjamin <oliben@amazon.com>,
        Julien Grall <jgrall@amazon.com>,
        Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH/RFC] xen-blkback: set ring->xenblkd to NULL after
 kthread_stop()
X-TSB-HOP: ON
Message-ID: <20210128095325.os57fkrwmyzt4t5o@toshiba.co.jp>
References: <20210128090506.3174402-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128090506.3174402-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I forgot to write the kernel version.
This is a patch for 4.4.y.

Best regards,
  Nobuhiro

On Thu, Jan 28, 2021 at 06:05:06PM +0900, Nobuhiro Iwamatsu wrote:
> From: Pawel Wieczorkiewicz <wipawel@amazon.de>
> 
> commit 1c728719a4da6e654afb9cc047164755072ed7c9 upstream.
> 
> When xen_blkif_disconnect() is called, the kernel thread behind the
> block interface is stopped by calling kthread_stop(ring->xenblkd).
> The ring->xenblkd thread pointer being non-NULL determines if the
> thread has been already stopped.
> Normally, the thread's function xen_blkif_schedule() sets the
> ring->xenblkd to NULL, when the thread's main loop ends.
> 
> However, when the thread has not been started yet (i.e.
> wake_up_process() has not been called on it), the xen_blkif_schedule()
> function would not be called yet.
> 
> In such case the kthread_stop() call returns -EINTR and the
> ring->xenblkd remains dangling.
> When this happens, any consecutive call to xen_blkif_disconnect (for
> example in frontend_changed() callback) leads to a kernel crash in
> kthread_stop() (e.g. NULL pointer dereference in exit_creds()).
> 
> This is XSA-350.
> 
> Cc: <stable@vger.kernel.org> # 4.12
> Fixes: a24fa22ce22a ("xen/blkback: don't use xen_blkif_get() in xen-blkback kthread")
> Reported-by: Olivier Benjamin <oliben@amazon.com>
> Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
> Signed-off-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
> Reviewed-by: Julien Grall <jgrall@amazon.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> [iwamatsu: change from ring to blkif]
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/block/xen-blkback/xenbus.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 823f3480ebd19e..f974ed7c33b5df 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -219,6 +219,7 @@ static int xen_blkif_disconnect(struct xen_blkif *blkif)
>  
>  	if (blkif->xenblkd) {
>  		kthread_stop(blkif->xenblkd);
> +		blkif->xenblkd = NULL;
>  		wake_up(&blkif->shutdown_wq);
>  	}
>  
> -- 
> 2.30.0
> 
> 
