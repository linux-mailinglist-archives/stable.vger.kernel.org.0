Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A005642B805
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 08:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhJMGyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 02:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238132AbhJMGyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 02:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634107923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RpuzMnNyT7+4FRREcT2u3Kwwl8W2CVjy5nh9V497X+I=;
        b=g0Yy/Bt9ngwHVuzNQ4Ca6yGKN+xFFOO44oGpCC1lnlRg07ey/cSv5WxMNNolUm7Y4ST/K3
        vEP27wbTTvoBYP5qcVX8vYZM0KNo+ptnI3Gdh6dTQZ2nPVK7AoctyHzm41KXH1JwdVCk1U
        to533BRRMjCLONmz/VhudL9OD0/C+cA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-p66QTA95N5O1G1m0Lg_AvA-1; Wed, 13 Oct 2021 02:51:58 -0400
X-MC-Unique: p66QTA95N5O1G1m0Lg_AvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6220079EDC;
        Wed, 13 Oct 2021 06:51:56 +0000 (UTC)
Received: from localhost (unknown [10.39.193.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0844B4180;
        Wed, 13 Oct 2021 06:51:55 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, bfu@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [RFC PATCH 1/1] s390/cio: make ccw_device_dma_* more robust
In-Reply-To: <20211013003714.1c411f0b.pasic@linux.ibm.com>
Organization: Red Hat GmbH
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
 <466de207-e88d-ea93-beec-fbfe10e63a26@linux.ibm.com>
 <874k9ny6k6.fsf@redhat.com> <20211011204837.7617301b.pasic@linux.ibm.com>
 <87pmsawdvr.fsf@redhat.com> <20211013003714.1c411f0b.pasic@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 13 Oct 2021 08:51:54 +0200
Message-ID: <87mtndwh6d.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13 2021, Halil Pasic <pasic@linux.ibm.com> wrote:

> On Tue, 12 Oct 2021 15:50:48 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> >> If I read cio_gp_dma_zalloc() correctly, we either get NULL or a valid
>> >> address, so yes.
>> >>   
>> >
>> > I don't think the extra care will hurt us too badly. I prefer to keep
>> > the IS_ERR_OR_NULL() check because it needs less domain specific
>> > knowledge to be understood, and because it is more robust.  
>> 
>> It feels weird, though -- I'd rather have a comment that tells me
>
> This way the change feels simpler and safer to me. I believe I explained
> the why above. But if you insist I can change it. I double checked the
> cio_gp_dma_zalloc() code, and more or less the code called by it. So
> now I don't feel uncomfortable with the simpler check.
>
> On the other hand, I'm not very happy doing changes solely based on
> somebody's feelings. It would feel much more comfortable with a reason
> based discussion.
>
> One reason to change this to a simple NULL check, is that the
> IS_ERR_OR_NULL() check could upset the reader of the client code,
> which only checks for NULL.
>
> On the other hand I do believe we have some risk of lumping together
> different errors here. E.g. dma_pool is NULL or dma ops are not set up
> properly. Currently we would communicate that kind of a problem as
> -ENOMEM, which wouldn't be a great match. But since dma_alloc_coherent()
> returns either NULL or a valid pointer, and furthermore this looks like
> a common thing in all the mm-api, I decided to be inline with that.
>
> TLDR; If you insist, I will change this to a simple null pointer check.
>
>> exactly what cio_gp_dma_zalloc() is supposed to return; I would have
>> expected that a _zalloc function always gives me a valid pointer or
>> NULL.
>
> I don't think we have such a comment for dma_alloc_coherent() or even
> kmalloc(). I agree, it would be nice to have this behavior documented
> in the apidoc all over the place. But IMHO that is a different issue.

So, I think that a function returning NULL/valid pointer is the more
expected case, and functions that can return an error as well should
document this. But it's not really worth arguing more about this, as
this is not my code anyway, and your patch does look correct.

Acked-by: Cornelia Huck <cohuck@redhat.com>

