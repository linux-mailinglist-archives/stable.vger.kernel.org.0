Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7F14EF586
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355237AbiDAPO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350510AbiDAPAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B15B55AEE6
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 07:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648824441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ubFWiDA1LlelDhe80vrrUD2k2vJd+0aq256Lv6ITnp4=;
        b=eDxGx2EZnVlu1BMQP1azyZMjNILLfBc5+d3deMTUgRrdFHvi0lvRn6ZPKFSSMz8OOGMB7u
        Pxx5JgRLNHwdK+xFShNhyDb/cHU1tI2cKZ8gE2liIjnmQ4uNmrPSM8FDien6h3bnv6QxKm
        hO5Fc4fCmbML9MXFtWfqZvvIpZ1dgVs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-JnZtpXHsNYOdjMGCwOMz2g-1; Fri, 01 Apr 2022 10:47:20 -0400
X-MC-Unique: JnZtpXHsNYOdjMGCwOMz2g-1
Received: by mail-qk1-f198.google.com with SMTP id h68-20020a376c47000000b0067e05dade89so2038439qkc.2
        for <stable@vger.kernel.org>; Fri, 01 Apr 2022 07:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ubFWiDA1LlelDhe80vrrUD2k2vJd+0aq256Lv6ITnp4=;
        b=D4sMnsyaoPIPvbnXt7JryI3nyMor0npBBMQXnKzU2hy5+s/9arA++YRiWGnoLhrA9l
         cVH9AILU6QV7qKMxiD1EKbotjySKp0UeHyrrpAb6GnmliMShMFxYVjqY6wkEsnK3HIXO
         Biehmn4IVudGLg7X6M+62m84qXC4/bUgR0ma9pyKYz6oDcdM4Nn0mFLlyu0ejeXh9ytg
         PkFYqQroB/e90dxW2B9FLwiaEVYZfilwmiJgg6IQZwr5rAfXT05FdICoLees4ndvbnjA
         Z+BNmu2isXEwmXGOBiPyjlbYtaPBUty8OWsb2inYQMaAta+yF2+jGY8g2ZZZzApalpjr
         LOeA==
X-Gm-Message-State: AOAM5313ME2Js+fxRzrP4tTENzIlV0Owj+Fa1AmRN3ZvElH0aBdANCPB
        WOP4ofLt20MVMp/acoKr+wKP5pZsyEM9oo570uCtREQ6YAGo7NXUVFsPjzWqAiktq5t0Xmf+yax
        gJOswZ2LaRUE/LkU=
X-Received: by 2002:a05:620a:24c7:b0:67f:9270:4b6a with SMTP id m7-20020a05620a24c700b0067f92704b6amr6635671qkn.52.1648824440263;
        Fri, 01 Apr 2022 07:47:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQRpmdsYnSYXtR8AnJ7zoL6DR0xqqC0MlDkItb7ArARcr3IO6CN0vjf0PcccOnDEIXfYu9qA==
X-Received: by 2002:a05:620a:24c7:b0:67f:9270:4b6a with SMTP id m7-20020a05620a24c700b0067f92704b6amr6635649qkn.52.1648824439903;
        Fri, 01 Apr 2022 07:47:19 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id q204-20020a3743d5000000b0067ece232979sm1374993qka.116.2022.04.01.07.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 07:47:19 -0700 (PDT)
Date:   Fri, 1 Apr 2022 10:47:18 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: md: fix missing check on list iterator
Message-ID: <YkcQdjE6uTfScyEy@redhat.com>
References: <20220327053742.2942-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327053742.2942-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27 2022 at  1:37P -0400,
Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> The bug is here:
>     bypass_pg(m, pg, bypassed);
> 
> The list iterator 'pg' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it will lead
> to a invalid memory access.
> 
> To fix this bug, run bypass_pg(m, pg, bypassed); and return 0
> when found, otherwise return -EINVAL.
> 
> Cc: stable@vger.kernel.org
> Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/md/dm-mpath.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index f4719b65e5e3..6ba8f1133564 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1496,12 +1496,13 @@ static int bypass_pg_num(struct multipath *m, const char *pgstr, bool bypassed)
>  	}
>  
>  	list_for_each_entry(pg, &m->priority_groups, list) {
> -		if (!--pgnum)
> -			break;
> +		if (!--pgnum) {
> +			bypass_pg(m, pg, bypassed);
> +			return 0;
> +		}
>  	}
>  
> -	bypass_pg(m, pg, bypassed);
> -	return 0;
> +	return -EINVAL;
>  }
>  
>  /*
> -- 
> 2.17.1
> 

Did you acually hit a bug (invalid memory access)?

I cannot see how given the checks prior to iterating m->priority_groups:

        if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
            !m->nr_priority_groups || (pgnum > m->nr_priority_groups)) {
                DMWARN("invalid PG number supplied to bypass_pg");
                return -EINVAL;
        }

So I have _not_ taken your "fix".

