Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BB027D73E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 21:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgI2Tss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 15:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbgI2Tsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 15:48:45 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72759C061755;
        Tue, 29 Sep 2020 12:48:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id q13so16857893ejo.9;
        Tue, 29 Sep 2020 12:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EfV9n3jCAY5e7p3ZDi51z+9ZxQ5VOAS4PnGR9TPcCJE=;
        b=Tg/uX+BCrdziC/0U0xQ9DUNRneekSaNt89qrGtZKVWr0gDy714YxYxv7oYqtnh1rLg
         evm9dVAj+mlS7k9NsfRsDAsWI2wNsS2pbVvMetBbqKAYasrq59rUmxM9Vuui4+WKbSGP
         VWDdiM1pyyh20kphoBxaFKL6Kz8/qHFVT8aKWTb2rJF5a4f07mzvIxWPp/l7K/1bX4yd
         VmgthGmTNo1MK8uAuTPhEkWB0rs7FqipF0q1DqKoGSTeAv5Ojs7JhqxM12ar+at24ccp
         oaIrRqaFFaHr+GuAnXn2x//Y4VIxUzgnu3BrF5nCN6WFu7D/w7b0ksoSZSFmfJFguiJX
         /ekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EfV9n3jCAY5e7p3ZDi51z+9ZxQ5VOAS4PnGR9TPcCJE=;
        b=I14mFIpsDuFXf4Rm6bZiNPpJqIGlCvF+jsoyZb9a57VyM34iLbQMACB3frZvEhwuOz
         ZWcnVxpNMvSU1OndgUEdu7W3yY/BEZA+gOrH5b2O6XNoZAnwD0qkyIgZyTM5b935Y2rJ
         +IlIXIx7M9ohwGEHxpUz5OTzs8EkN+Khd7DpQl7TcOiQpX+FVzxQGMl5tKpVsezPMKEB
         EPln0V7EPQAXvt8/TiurnhMx+O+KsYYhnswZ/kMrPsl5ZhUzxQFL2eImya6owbInYSXA
         RXCLYyoQL09wOqwSDVauJp0H00gx0SiO9nexqPjT+JeGUrdL5yGkrFZ5bJA7O3wUBvdJ
         urcQ==
X-Gm-Message-State: AOAM533k+Cd03a113ZfeNZa4ge44v2K5UDsJgKhyrRQVEMfEPRN7r2xI
        QO9tu4XXvU0AKgvT5SeR+fhirGaNFQOLBYXUB78=
X-Google-Smtp-Source: ABdhPJwYlYPE1fi96p1hcpNgqHFGUf7tTTqgoMg6O5rCyHechmLOcELaQlqm+9099tKeePaLN+CjUWw6OycJO5BQj9w=
X-Received: by 2002:a17:906:fa0a:: with SMTP id lo10mr3262551ejb.22.1601408924109;
 Tue, 29 Sep 2020 12:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200928043329.606781-1-mark.mielke@gmail.com>
In-Reply-To: <20200928043329.606781-1-mark.mielke@gmail.com>
From:   Marc Dionne <marc.c.dionne@gmail.com>
Date:   Tue, 29 Sep 2020 16:48:32 -0300
Message-ID: <CAB9dFdvK2y==KjSfL6m+XOzBDP8kJmQX33Jf7m+5Ys762FPx2w@mail.gmail.com>
Subject: Re: [PATCH] iscsi: iscsi_tcp: Avoid holding spinlock while calling getpeername
To:     Mark Mielke <mark.mielke@gmail.com>
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 1:34 AM Mark Mielke <mark.mielke@gmail.com> wrote:
>
> Kernel may fail to boot or devices may fail to come up when
> initializing iscsi_tcp devices starting with Linux 5.8.
>
> Marc Dionne identified the cause in RHBZ#1877345.
>
> Commit a79af8a64d39 ("[SCSI] iscsi_tcp: use iscsi_conn_get_addr_param
> libiscsi function") introduced getpeername() within the session spinlock.
>
> Commit 1b66d253610c ("bpf: Add get{peer, sock}name attach types for
> sock_addr") introduced BPF_CGROUP_RUN_SA_PROG_LOCK() within getpeername,
> which acquires a mutex and when used from iscsi_tcp devices can now lead
> to "BUG: scheduling while atomic:" and subsequent damage.
>
> This commit ensures that the spinlock is released before calling
> getpeername() or getsockname(). sock_hold() and sock_put() are
> used to ensure that the socket reference is preserved until after
> the getpeername() or getsockname() complete.
>
> Reported-by: Marc Dionne <marc.c.dionne@gmail.com>
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1877345
> Link: https://lkml.org/lkml/2020/7/28/1085
> Link: https://lkml.org/lkml/2020/8/31/459
> Fixes: a79af8a64d39 ("[SCSI] iscsi_tcp: use iscsi_conn_get_addr_param libiscsi function")
> Fixes: 1b66d253610c ("bpf: Add get{peer, sock}name attach types for sock_addr")
> Signed-off-by: Mark Mielke <mark.mielke@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/iscsi_tcp.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index b5dd1caae5e9..d10efb66cf19 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -736,6 +736,7 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
>         struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
>         struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
>         struct sockaddr_in6 addr;
> +       struct socket *sock;
>         int rc;
>
>         switch(param) {
> @@ -747,13 +748,17 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
>                         spin_unlock_bh(&conn->session->frwd_lock);
>                         return -ENOTCONN;
>                 }
> +               sock = tcp_sw_conn->sock;
> +               sock_hold(sock->sk);
> +               spin_unlock_bh(&conn->session->frwd_lock);
> +
>                 if (param == ISCSI_PARAM_LOCAL_PORT)
> -                       rc = kernel_getsockname(tcp_sw_conn->sock,
> +                       rc = kernel_getsockname(sock,
>                                                 (struct sockaddr *)&addr);
>                 else
> -                       rc = kernel_getpeername(tcp_sw_conn->sock,
> +                       rc = kernel_getpeername(sock,
>                                                 (struct sockaddr *)&addr);
> -               spin_unlock_bh(&conn->session->frwd_lock);
> +               sock_put(sock->sk);
>                 if (rc < 0)
>                         return rc;
>
> @@ -775,6 +780,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>         struct iscsi_tcp_conn *tcp_conn;
>         struct iscsi_sw_tcp_conn *tcp_sw_conn;
>         struct sockaddr_in6 addr;
> +       struct socket *sock;
>         int rc;
>
>         switch (param) {
> @@ -789,16 +795,18 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>                         return -ENOTCONN;
>                 }
>                 tcp_conn = conn->dd_data;
> -
>                 tcp_sw_conn = tcp_conn->dd_data;
> -               if (!tcp_sw_conn->sock) {
> +               sock = tcp_sw_conn->sock;
> +               if (!sock) {
>                         spin_unlock_bh(&session->frwd_lock);
>                         return -ENOTCONN;
>                 }
> +               sock_hold(sock->sk);
> +               spin_unlock_bh(&session->frwd_lock);
>
> -               rc = kernel_getsockname(tcp_sw_conn->sock,
> +               rc = kernel_getsockname(sock,
>                                         (struct sockaddr *)&addr);
> -               spin_unlock_bh(&session->frwd_lock);
> +               sock_put(sock->sk);
>                 if (rc < 0)
>                         return rc;
>
> --
> 2.28.0
>

Works for me and prevents the iscsid crash.

Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
