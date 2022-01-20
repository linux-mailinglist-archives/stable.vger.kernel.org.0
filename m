Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2F5495051
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 15:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351790AbiATOfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 09:35:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351156AbiATOfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 09:35:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642689308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D378avGhHf7Yew8dpU8oH0FTT2ZH+6InHr9T5zdsY3g=;
        b=iAUwRInTTkcxnkbZxUKJZYK059F/qAAjMZs8KgtJPJXZiJl//LocofPzxmW6bi8oWNg9PF
        eG7nZkQwu5ONx0KgE3r+itU65Fa6c/cSnSfaaH/VE1Z6NCfOBHvkpQhzzqosMQdcfzkbOW
        zj58v8wpxWVNdypZdPsbuUHoQIxiQEQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-Aati9j2NM7e9FDZ-ofjW4g-1; Thu, 20 Jan 2022 09:35:05 -0500
X-MC-Unique: Aati9j2NM7e9FDZ-ofjW4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D3461926DA0;
        Thu, 20 Jan 2022 14:35:04 +0000 (UTC)
Received: from localhost (unknown [10.39.195.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A092678AB2;
        Thu, 20 Jan 2022 14:35:03 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v2 2/2] virtio: acknowledge all features before access
In-Reply-To: <20220118170225.30620-2-mst@redhat.com>
Organization: Red Hat GmbH
References: <20220118170225.30620-1-mst@redhat.com>
 <20220118170225.30620-2-mst@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Thu, 20 Jan 2022 15:35:01 +0100
Message-ID: <87h79ycw6i.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18 2022, "Michael S. Tsirkin" <mst@redhat.com> wrote:

> The feature negotiation was designed in a way that
> makes it possible for devices to know which config
> fields will be accessed by drivers.
>
> This is broken since commit 404123c2db79 ("virtio: allow drivers to
> validate features") with fallout in at least block and net.  We have a
> partial work-around in commit 2f9a174f918e ("virtio: write back
> F_VERSION_1 before validate") which at least lets devices find out which
> format should config space have, but this is a partial fix: guests
> should not access config space without acknowledging features since
> otherwise we'll never be able to change the config space format.
>
> To fix, split finalize_features from virtio_finalize_features and
> call finalize_features with all feature bits before validation,
> and then - if validation changed any bits - once again after.
>
> Since virtio_finalize_features no longer writes out features
> rename it to virtio_features_ok - since that is what it does:
> checks that features are ok with the device.
>
> As a side effect, this also reduces the amount of hypervisor accesses -
> we now only acknowledge features once unless we are clearing any
> features when validating (which is uncommon).
>
> Cc: stable@vger.kernel.org
> Fixes: 404123c2db79 ("virtio: allow drivers to validate features")
> Fixes: 2f9a174f918e ("virtio: write back F_VERSION_1 before validate")
> Cc: "Halil Pasic" <pasic@linux.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> fixup! virtio: acknowledge all features before access

Leftover from rebasing?

> ---
>  drivers/virtio/virtio.c       | 39 ++++++++++++++++++++---------------
>  include/linux/virtio_config.h |  3 ++-
>  2 files changed, 24 insertions(+), 18 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Would like to see a quick sanity test from Halil, though.

