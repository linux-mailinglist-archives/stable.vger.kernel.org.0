Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F711EFB68
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgFEO3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:29:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52641 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728056AbgFEO3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 10:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591367377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wMUBVCh95l7T1zzX1KFFNS/r5gF1lRogO3oFRYhOsgE=;
        b=K21QxbiBhIw+KyK1wvjJoNCmU13h0+V45j2sPW88qeftkNbCCrAHdG3JD+gf3uZqqLNbsc
        AqOmEeHJPq5wxIU0ILFe70jA72ECsLkUHu4w2Buj0RRVpuWt/MmUhXgJVLGblBxDR+X0ps
        3ALKYqHHgIlgm8mObcmv4vOD84rNK2Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-TvQiO_VmPVyyNGGLHLVUXg-1; Fri, 05 Jun 2020 10:29:35 -0400
X-MC-Unique: TvQiO_VmPVyyNGGLHLVUXg-1
Received: by mail-wr1-f69.google.com with SMTP id e1so3858124wrm.3
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 07:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wMUBVCh95l7T1zzX1KFFNS/r5gF1lRogO3oFRYhOsgE=;
        b=LlTX0vB9hyXpiQ/5IOveUiONx0cbeiG0p1qLcn9tLTYb3I88rHQ+yYphRxpAcY7c68
         YU6MqprauDRrKUt4HsbVsFmbFA9zGVxrYtTv6mEBfHvcD8wUDwHR5Ur0wdhKapWzlE9H
         hsvNa1CTxmyqwUjunvXbAkAk7bli1PiOMVmm5oDWpoPdHdYm0eG+OjFO2Na3MnAvSAlR
         VoHaVulMlMyDQiGnaTwzzmbsK/y/xLR/JD0HfUcgHm+RfJsjHW65IT8ygA0TiyS0P78Z
         FuXYHeGswyi+oabC50Jr9XSNCMwxmrDYB5p+vHeoyPJH6Poo7nn2smcOtNlY1RqhOMEb
         r/jA==
X-Gm-Message-State: AOAM530dMs58pQ1OyUliJcClz693S6j4fuNggawSCWnHh6/eZdqiKuUW
        LeipeBRaSX6oy4zV5lmmgilokIAsRY2s+tK7n3lzS8zx8qj+Al0v3HCbs0V2xjgQT3gKpQ9vSZd
        xQn5i9kQXWWSRSxHl
X-Received: by 2002:a05:600c:4146:: with SMTP id h6mr3106310wmm.170.1591367374319;
        Fri, 05 Jun 2020 07:29:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsH4G7wM9H57d5b4WNUMxsAioO8ycm/M5EW/tfh5pIXAFaYFjrsTGfmYPzLTtMNEqkLl7YJA==
X-Received: by 2002:a05:600c:4146:: with SMTP id h6mr3106290wmm.170.1591367374026;
        Fri, 05 Jun 2020 07:29:34 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id z6sm11799407wrh.79.2020.06.05.07.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 07:29:33 -0700 (PDT)
Date:   Fri, 5 Jun 2020 16:29:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jia He <justin.he@arm.com>, Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [PATCH v2] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
Message-ID: <20200605142930.wz45eysnbi7kyqyc@steredhat>
References: <20200529152102.58397-1-justin.he@arm.com>
 <20200605141049.A67B9207ED@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605141049.A67B9207ED@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 05, 2020 at 02:10:49PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.
> 
> v5.6.15: Build OK!
> v5.4.43: Build failed! Errors:
>     net/vmw_vsock/virtio_transport_common.c:1109:40: error: ???????????????t?????????????????? undeclared (first use in this function); did you mean ???????????????tm???????????????????
>     net/vmw_vsock/virtio_transport_common.c:1109:9: error: too many arguments to function ???????????????virtio_transport_reset_no_sock??????????????????
> 
> v4.19.125: Build failed! Errors:
>     net/vmw_vsock/virtio_transport_common.c:1042:40: error: ???????????????t?????????????????? undeclared (first use in this function); did you mean ???????????????tm???????????????????
>     net/vmw_vsock/virtio_transport_common.c:1042:9: error: too many arguments to function ???????????????virtio_transport_reset_no_sock??????????????????
> 
> v4.14.182: Build failed! Errors:
>     net/vmw_vsock/virtio_transport_common.c:1038:40: error: ???????????????t?????????????????? undeclared (first use in this function); did you mean ???????????????tm???????????????????
>     net/vmw_vsock/virtio_transport_common.c:1038:9: error: too many arguments to function ???????????????virtio_transport_reset_no_sock??????????????????
> 
> v4.9.225: Build failed! Errors:
>     net/vmw_vsock/virtio_transport_common.c:968:40: error: ???????????????t?????????????????? undeclared (first use in this function); did you mean ???????????????tm???????????????????
>     net/vmw_vsock/virtio_transport_common.c:968:9: error: too many arguments to function ???????????????virtio_transport_reset_no_sock??????????????????
> 
> v4.4.225: Failed to apply! Possible dependencies:
>     06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

I think we can simply remove the 't' from virtio_transport_reset_no_sock(),
the following patch should work:

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index fb2060dffb0a..17f4c93f5e75 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1104,6 +1104,14 @@ void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)

        lock_sock(sk);

+       /* Check if sk has been released before lock_sock */
+       if (sk->sk_shutdown == SHUTDOWN_MASK) {
+               (void)virtio_transport_reset_no_sock(pkt);
+               release_sock(sk);
+               sock_put(sk);
+               goto free_pkt;
+       }
+
        /* Update CID in case it has changed after a transport reset event */
        vsk->local_addr.svm_cid = dst.svm_cid;

Thanks,
Stefano

