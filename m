Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484571E83CC
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 18:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgE2Qe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 12:34:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727004AbgE2QeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 12:34:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590770059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dZ3Au5FaNGsFuALhZak+xDg1jZacBxkv5pzIdzHUfKU=;
        b=MAZPTIqdjBx4qOWxqDv23mK3HIx51kGXPrn5QLyM/s265yb/PFKzYB0egx9+kXia1+UDQ0
        lIRrCAbJIxoCEaFfExHKslnO2aX6awMu5X8n7a691cGynI/gRbA77cmHgtSuqNnxTm3iL9
        E2Uip4Br2SMtUCnMELP4q4h0fUob0aE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-tUv4C7cYNkmpKNzBQE4yzg-1; Fri, 29 May 2020 12:34:18 -0400
X-MC-Unique: tUv4C7cYNkmpKNzBQE4yzg-1
Received: by mail-wr1-f71.google.com with SMTP id z10so1272689wrs.2
        for <stable@vger.kernel.org>; Fri, 29 May 2020 09:34:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dZ3Au5FaNGsFuALhZak+xDg1jZacBxkv5pzIdzHUfKU=;
        b=PfqHjepAD30wcjVvcOLxEGvab4P2p+8qovMwIP9iMuFtvPc1gPeRIgQjl7ZBqGCXPg
         hoxstgyyMtrRZuSVpg4QSzbDPYZ2M8H4V4P6i+9BZp/VybwQOIjfDqP0pUquzM2q09Pc
         OZXLw+mHVcRMR45cDR1E7327x7/Vq04qetNSgV/pBLer+4W52iKuaxBjRpkkUmhky6XQ
         AME+bmRzEbi0Afm6OpWFlytCKPdhH/06GrDNZNmmfY+PYOFC4u0O4K4CVgHGz25JIBfr
         MG8A6Cd1w5AZP6qcVzndsS8HAsoNJoZW5nEbW0Z1COzOyDIKjU7KXWa2/uBQM7Ib2+9V
         r86g==
X-Gm-Message-State: AOAM530wayMNX57YiKn+RtNtIfvRckbv2PIOODXLqJq6tCk8mGbXvutH
        qJE6PoOKY0CLeX3NhjwxVpehNnb+x+2REBDZtKW12XYsyemq5h9b1vdKclpLVk8yOMqkASbuIZg
        bzbjVRXfwSH/XjDtj
X-Received: by 2002:adf:dbc1:: with SMTP id e1mr2275426wrj.339.1590770055854;
        Fri, 29 May 2020 09:34:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ889WcL2gc5cE15AzE4PQixcL+wfygpza9dr3frPSqYQSWVW6QADK+d89yCcehEvnie2qnA==
X-Received: by 2002:adf:dbc1:: with SMTP id e1mr2275400wrj.339.1590770055587;
        Fri, 29 May 2020 09:34:15 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id r6sm323841wmh.1.2020.05.29.09.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:34:15 -0700 (PDT)
Date:   Fri, 29 May 2020 18:34:12 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jia He <justin.he@arm.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaly Xin <Kaly.Xin@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
Message-ID: <20200529163412.fqswshs65f53qgez@steredhat>
References: <20200529152102.58397-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529152102.58397-1-justin.he@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 11:21:02PM +0800, Jia He wrote:
> When client tries to connect(SOCK_STREAM) the server in the guest with
> NONBLOCK mode, there will be a panic on a ThunderX2 (armv8a server):
> [  463.718844][ T5040] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> [  463.718848][ T5040] Mem abort info:
> [  463.718849][ T5040]   ESR = 0x96000044
> [  463.718852][ T5040]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  463.718853][ T5040]   SET = 0, FnV = 0
> [  463.718854][ T5040]   EA = 0, S1PTW = 0
> [  463.718855][ T5040] Data abort info:
> [  463.718856][ T5040]   ISV = 0, ISS = 0x00000044
> [  463.718857][ T5040]   CM = 0, WnR = 1
> [  463.718859][ T5040] user pgtable: 4k pages, 48-bit VAs, pgdp=0000008f6f6e9000
> [  463.718861][ T5040] [0000000000000000] pgd=0000000000000000
> [  463.718866][ T5040] Internal error: Oops: 96000044 [#1] SMP
> [...]
> [  463.718977][ T5040] CPU: 213 PID: 5040 Comm: vhost-5032 Tainted: G           O      5.7.0-rc7+ #139
> [  463.718980][ T5040] Hardware name: GIGABYTE R281-T91-00/MT91-FS1-00, BIOS F06 09/25/2018
> [  463.718982][ T5040] pstate: 60400009 (nZCv daif +PAN -UAO)
> [  463.718995][ T5040] pc : virtio_transport_recv_pkt+0x4c8/0xd40 [vmw_vsock_virtio_transport_common]
> [  463.718999][ T5040] lr : virtio_transport_recv_pkt+0x1fc/0xd40 [vmw_vsock_virtio_transport_common]
> [  463.719000][ T5040] sp : ffff80002dbe3c40
> [...]
> [  463.719025][ T5040] Call trace:
> [  463.719030][ T5040]  virtio_transport_recv_pkt+0x4c8/0xd40 [vmw_vsock_virtio_transport_common]
> [  463.719034][ T5040]  vhost_vsock_handle_tx_kick+0x360/0x408 [vhost_vsock]
> [  463.719041][ T5040]  vhost_worker+0x100/0x1a0 [vhost]
> [  463.719048][ T5040]  kthread+0x128/0x130
> [  463.719052][ T5040]  ret_from_fork+0x10/0x18
         ^         ^
Maybe we can remove these two columns from the commit message.

> 
> The race condition as follows:
> Task1                            Task2
> =====                            =====
> __sock_release                   virtio_transport_recv_pkt
>   __vsock_release                  vsock_find_bound_socket (found)
>     lock_sock_nested
>     vsock_remove_sock
>     sock_orphan
>       sk_set_socket(sk, NULL)

Here we can add:
      sk->sk_shutdown = SHUTDOWN_MASK;

>     ...
>     release_sock
>                                 lock_sock
>                                    virtio_transport_recv_connecting
>                                      sk->sk_socket->state (panic)
> 
> The root cause is that vsock_find_bound_socket can't hold the lock_sock,
> so there is a small race window between vsock_find_bound_socket() and
> lock_sock(). If there is __vsock_release() in another task, sk->sk_socket
> will be set to NULL inadvertently.
> 
> This fixes it by checking sk->sk_shutdown.
> 
> Signed-off-by: Jia He <justin.he@arm.com>
> Cc: stable@vger.kernel.org
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2: use lightweight checking suggested by Stefano Garzarella
> 
>  net/vmw_vsock/virtio_transport_common.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 69efc891885f..0edda1edf988 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1132,6 +1132,14 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>  
>  	lock_sock(sk);
>  
> +	/* Check if sk has been released before lock_sock */
> +	if (sk->sk_shutdown == SHUTDOWN_MASK) {
> +		(void)virtio_transport_reset_no_sock(t, pkt);
> +		release_sock(sk);
> +		sock_put(sk);
> +		goto free_pkt;
> +	}
> +
>  	/* Update CID in case it has changed after a transport reset event */
>  	vsk->local_addr.svm_cid = dst.svm_cid;
>  
> -- 
> 2.17.1
> 

Anyway, the patch LGTM, let see what David and other say.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

