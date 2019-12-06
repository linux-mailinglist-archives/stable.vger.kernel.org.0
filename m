Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2194114A4B
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 01:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfLFAyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 19:54:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28754 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726037AbfLFAyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 19:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575593693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wvC+UrzFhvb89O+Byz15qsgENexEOo6OJybWKjv9TuE=;
        b=OsDmQ9DbRZGg7PBlW2AEPwNWN2ylk+Ig0Ocp1vtANAnoGUuk5VFwnh4SUYrBWM4a3sJ6Dl
        w4/+6j6qpLM56hNHQECJ3OFOv+vC2qG5onphBf5MgrMHugkjiFN1pxWO5zBB1FruEOAJDc
        km9szbZPfUmyaksnn49Gnj7+mZ8iM3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-GrJDkLvqNOmXp6AqZihGow-1; Thu, 05 Dec 2019 19:54:50 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C586800D5E;
        Fri,  6 Dec 2019 00:54:48 +0000 (UTC)
Received: from ming.t460p (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A633D19488;
        Fri,  6 Dec 2019 00:54:41 +0000 (UTC)
Date:   Fri, 6 Dec 2019 08:54:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Christoph Hellwig <hch@lst.de>, Faiz Abbas <faiz_abbas@ti.com>,
        linux-block@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 240/321] mmc: core: align max segment size with
 logical block size
Message-ID: <20191206005435.GA13152@ming.t460p>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223439.627632861@linuxfoundation.org>
 <20191205222247.GC25107@duo.ucw.cz>
MIME-Version: 1.0
In-Reply-To: <20191205222247.GC25107@duo.ucw.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: GrJDkLvqNOmXp6AqZihGow-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 11:22:47PM +0100, Pavel Machek wrote:
> Hi!
>=20
> > From: Ming Lei <ming.lei@redhat.com>
> >=20
> > [ Upstream commit c53336c8f5f29043fded57912cc06c24e12613d7 ]
> >=20
> > Logical block size is the lowest possible block size that the storage
> > device can address. Max segment size is often related with controller's
> > DMA capability. And it is reasonable to align max segment size with
> > logical block size.
>=20
> > SDHCI sets un-aligned max segment size, and causes ADMA error, so
> > fix it by aligning max segment size with logical block size.
>=20
> If un-aligned max segment sizes are problem, should we add checks to
> prevent setting them?
>=20
> At least these set unaligned problems; is that a problem?
>=20
> drivers/block/nbd.c:=09blk_queue_max_segment_size(disk->queue, UINT_MAX);
> drivers/block/virtio_blk.c:=09=09blk_queue_max_segment_size(q, -1U);
> drivers/block/rbd.c:=09blk_queue_max_segment_size(q, UINT_MAX);

In theory, all segment size should be aligned, however the above MAX
value just means the queue hasn't max segment size limit, so it won't
be applied actually.


Thanks,
Ming

