Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290C448972E
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244568AbiAJLSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:18:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244532AbiAJLSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 06:18:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641813529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a1mKixw3piLB47kAb+NgNKbQU1uo3Pje5s8quzB5jk0=;
        b=EqaXD6pdaCfOOSB1dggh+mcmja7mdQvKdJG+AR+bsGJRVUX4MhZkt5KJVBiged528n88uk
        xFdZQxTmqvXymi6sZQS4GctDtGTbuycR2l6DKsCa9wLtiUXblbWveDVEBAS59xfHtZxHXz
        PLpMCtOYUN1KNQ6+ZksvVSiYrwjmYzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-wSmpKZGjN6GuPbqk0EwnZQ-1; Mon, 10 Jan 2022 06:18:46 -0500
X-MC-Unique: wSmpKZGjN6GuPbqk0EwnZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C87ED1017965;
        Mon, 10 Jan 2022 11:18:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 742B77D4D0;
        Mon, 10 Jan 2022 11:18:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220110111444.926753-1-asmadeus@codewreck.org>
References: <20220110111444.926753-1-asmadeus@codewreck.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     dhowells@redhat.com, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, lucho@ionkov.net, ericvh@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] 9p: fix enodata when reading growing file
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3730530.1641813522.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 10 Jan 2022 11:18:42 +0000
Message-ID: <3730531.1641813522@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dominique Martinet <asmadeus@codewreck.org> wrote:

> Reading from a file that was just extended by a write, but the write had
> not yet reached the server would return ENODATA as illustrated by this
> command:
> $ xfs_io -c 'open -ft test' -c 'w 4096 1000' -c 'r 0 1000'
> wrote 1000/1000 bytes at offset 4096
> 1000.000000 bytes, 1 ops; 0.0001 sec (5.610 MiB/sec and 5882.3529 ops/se=
c)
> pread: No data available
> =

> Fix this case by having netfs assume zeroes when reads from server come
> short like AFS and CEPH do
> =

> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> Co-authored-by: David Howells <dhowells@redhat.com>
> Cc: stable@vger.kernel.org

I think you want this also:

Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do read=
s and caching")

Reviewed-by: David Howells <dhowells@redhat.com>

