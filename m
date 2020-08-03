Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967A623A3E6
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHCMRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:17:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726189AbgHCMRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 08:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596457032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3mek2A6PIw6FAWa9UG6mFGYnYOJu239mNTyE80MC8Tk=;
        b=JSkTE4O1wH7mfNe+S/96wPT9P+T/DwmASh+9wU9NS09m376HV76Oxk34t/7B4Cvs2wRvPn
        vD5Ejgd6+rOsrlYGWmvq4XacRWlGmRrsLUq9suRrEyDkXetplT3yIK6e+i6efujViCWXEg
        tAewcBhRuGDwF8NPaOnps+D9a3mq9Tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-GIvt-njHNbOiWGyyL_TOZA-1; Mon, 03 Aug 2020 08:17:09 -0400
X-MC-Unique: GIvt-njHNbOiWGyyL_TOZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20F2119253C4
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 12:17:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19D016842F
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 12:17:09 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 11F9C9A109;
        Mon,  3 Aug 2020 12:17:09 +0000 (UTC)
Date:   Mon, 3 Aug 2020 08:17:08 -0400 (EDT)
From:   Bob Peterson <rpeterso@redhat.com>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org
Message-ID: <1760387650.10412850.1596457028715.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200803115213.432367-1-agruenba@redhat.com>
References: <20200803115213.432367-1-agruenba@redhat.com>
Subject: Re: [Cluster-devel] [PATCH] gfs2: Fix refcount leak in
 gfs2_glock_poke
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.3.112.61, 10.4.195.26]
Thread-Topic: gfs2: Fix refcount leak in gfs2_glock_poke
Thread-Index: ifhzwx7+YGgdX/sov0CLnDenNThApw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Original Message -----
> In gfs2_glock_poke, make sure gfs2_holder_uninit is called on the local
> glock holder.  Without that, we're leaking a glock and a pid reference.
> 
> Fixes: 9e8990dea926 ("gfs2: Smarter iopen glock waiting")
> Cc: stable@vger.kernel.org # v5.8+
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/gfs2/glock.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index 57134d326cfa..f13b136654ca 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -790,9 +790,11 @@ static void gfs2_glock_poke(struct gfs2_glock *gl)
>  	struct gfs2_holder gh;
>  	int error;
>  
> -	error = gfs2_glock_nq_init(gl, LM_ST_SHARED, flags, &gh);
> +	gfs2_holder_init(gl, LM_ST_SHARED, flags, &gh);
> +	error = gfs2_glock_nq(&gh);
>  	if (!error)
>  		gfs2_glock_dq(&gh);
> +	gfs2_holder_uninit(&gh);
>  }
>  
>  static bool gfs2_try_evict(struct gfs2_glock *gl)
> --
> 2.26.2

Hi,

Looks okay.
I'd rather use nq_init and dq_uninit (and change similar code throughout
to use it more consistently) but in the past you've expressed a
concern that the compiler generates less efficient code.

Maybe it makes more sense to rework gfs2_glock_nq_init and dq_uninit
so the compiler does a more reasonable job? Or I suppose we could
delay that work for later.

Regards,

Bob Peterson

