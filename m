Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8B8109120
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 16:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfKYPjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 10:39:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50857 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728525AbfKYPjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 10:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574696348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VsAK8fAT6IoBWsUTU5eNZ/mMVj2S5/lNLs9J4QbChX8=;
        b=imDn/JSqLhxSccJVUDCeOYy3TKvfJidvUbVBGDczVteLxg8s60zZ8e8wQvpLiZnw8reERd
        yM2Gx5uEyOtkg0gbpf9JMLzcG4V9GQ/W+1khdNFmrrNHx+Iy/aruDeAh8I9MeqqAYzWqEb
        IAD6baBYev961DzH7w5Qjp+GVYGSoi0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-B1iWcfonNQixKS4CQCDM6A-1; Mon, 25 Nov 2019 10:39:05 -0500
Received: by mail-wr1-f71.google.com with SMTP id y1so9073351wrl.0
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 07:39:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=JfeNkKRQpB3nyKxT13T4aFmOpj0a4eWI57/SBtH5GLA=;
        b=EYHDaOQR7JMtE4JdXveqZin11XtYYCGI5cVUgP+1CyKPo9X7Uy9pjIDFhqzFJY2A6g
         n7kCuoKN63xZ+KGx1GWiJMQ+m/gQegTqzI8X+AGwglfA5ltTz1XG8N6cpIKt6LQNU+nN
         3m3FyV44y5JiXNZc13ohnDGYnFRXm7ozHGfUk69VUjjrNh+Uk/1VpVNlPbvNlwOM/RBZ
         wSX2uTh7Lbpm1XrWtLSjZzFu+faMYFH+S2KvbkpABghTPMqB7/AiDTx4MhQPkyZDp0xG
         edAQSY3DrM7ywqVKTRc1ecYV3Y9lySMXxaFmmfdtIlwGcvQFSvjpT6AZ7DHpOAsxVreO
         goTw==
X-Gm-Message-State: APjAAAVbifRokSY4ijC5TLQ8xZ/eultg/jYM9hNYkilYp5MdKyZWyp/7
        ufMR6z5L1Xj91UhPamLiM7wjS3kYZf/Tj5inA7OaAyhof/pxr4L/g012ExYKjcQDn+Trl0yjEYw
        98uufDs1sY9boP7lR
X-Received: by 2002:a7b:c651:: with SMTP id q17mr16270840wmk.109.1574696343789;
        Mon, 25 Nov 2019 07:39:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqyO92aD7lZFKUlvx8u4ehuiAiIep59+uZl4Saozmql0UvAIXMTYDsNQ03IoHgafVad3nl7USg==
X-Received: by 2002:a7b:c651:: with SMTP id q17mr16270827wmk.109.1574696343540;
        Mon, 25 Nov 2019 07:39:03 -0800 (PST)
Received: from steredhat (host192-186-dynamic.51-79-r.retail.telecomitalia.it. [79.51.186.192])
        by smtp.gmail.com with ESMTPSA id x8sm10799389wrm.7.2019.11.25.07.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 07:39:03 -0800 (PST)
Date:   Mon, 25 Nov 2019 16:39:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Tsirkin <mst@redhat.com>
Subject: Please backport 6dbd3e66e778 vhost/vsock: split packets to send
 using multiple buffers
Message-ID: <CAGxU2F5NAbrFGF7LaVSyWSNy2kdkL=dATfujaUi3V7iXwqRcGg@mail.gmail.com>
MIME-Version: 1.0
X-MC-Unique: B1iWcfonNQixKS4CQCDM6A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
with Michael, we realized that this patch merged upstream solves an
issue in the device emulation in the vhost-vsock module.
Before this patch, the emulation did not meet the VIRTIO vsock
specification, assuming that the buffer in the RX virtqueue was always 4 KB=
,
without checking the actual size.

Please, backport the following patch to fix this issue:

commit 6dbd3e66e7785a2f055bf84d98de9b8fd31ff3f5
Author: Stefano Garzarella <sgarzare@redhat.com>
Date:   Tue Jul 30 17:43:33 2019 +0200

    vhost/vsock: split packets to send using multiple buffers
  =20
    If the packets to sent to the guest are bigger than the buffer
    available, we can split them, using multiple buffers and fixing
    the length in the packet header.
    This is safe since virtio-vsock supports only stream sockets.
  =20
    Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
    Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
    Acked-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>


The commit applies and builds against 4.14, 4.19, and 5.3

Thanks,
Stefano

