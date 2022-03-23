Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6FD4E4A0E
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 01:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240906AbiCWA0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 20:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiCWA0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 20:26:30 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B340813D50;
        Tue, 22 Mar 2022 17:25:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id u22so168525pfg.6;
        Tue, 22 Mar 2022 17:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R+KjN3V1SlenXxLe5Smnpn6Kl0EaEBKZxKusql1w254=;
        b=cvECYKNH5pjdsTN/s4iB+l7+gDkakGP7uIYy2JGzTxtG2ATo9nLBii0ZdatESkWG3r
         xpu9zPFmFQIcFc2NgGPRDHqFw286JKtjV4porAqlXMNXwjp3taEqGJGgENu7mlpc7UJE
         pz91lVnxkYRu1p+b95nNx2EkIDcRYKEaNTHEM8Zaf8Gq+Dc4UhOutT/roPqH2cmF75JV
         c59rhnnyv/iSyQKaM8GMVvYIYNFsEZPjLnyZ3Ca2c/1wZbRaJpD9NsfnJJ0BMz1IJ0oa
         bBsifDdmeE2f7E99dKbDCRH03P1IbvTt4/rnGec8PnA+0KqtLa7vmz4O42hF6kN3ebm5
         KOUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=R+KjN3V1SlenXxLe5Smnpn6Kl0EaEBKZxKusql1w254=;
        b=8IL/oRifEzffCFCb6TzU7oiPduLzjY1lFaf/ZXHq5lidddyOJxlxfsodNGu6fl5ezC
         mVQs+BtR4MTg9BXS118ctRwL2wftXGGFZwmwQLkmhUhdXuRaDqXPc6vjvQBrGWxpzxmC
         fFS0eNHhS7CFqiZwvZFmQupKkJn+OS9JFwGr3BwrYAo5PbTibpoCboRGbBa19iDjymKT
         XsSkOPboOaRHVhWudvHusy6QADdPqFyI6NhJKCMdiijsDl5fK+okYsxYlcFs03JU7Ghy
         DAzsjFLfxxL1XrGWNQj0zBooO1/3pR0XIDBu4Y++9aH68kP69ji763hyJBeGykn6OUyw
         9G/Q==
X-Gm-Message-State: AOAM532o/qV7cZU7nju3GKW3g1jEimBoX852hHAqTHXr02N3ee6Tllyp
        dosk392GHSKf9rCzfsZUKJo=
X-Google-Smtp-Source: ABdhPJzCZi/vmJnOJ2M5f5b9fWl00X7eHUop/OzzdFXBsx9usW96xIqvw/d6pRX/L31s2XfkT3Y6nQ==
X-Received: by 2002:a63:194e:0:b0:372:c757:c569 with SMTP id 14-20020a63194e000000b00372c757c569mr23701978pgz.516.1647995101156;
        Tue, 22 Mar 2022 17:25:01 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:3d69:cefc:7302:2e52])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090a394e00b001c670d67b8esm3968381pjf.32.2022.03.22.17.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 17:25:00 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Tue, 22 Mar 2022 17:24:58 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     vbabka@suse.cz, surenb@google.com, stable@vger.kernel.org,
        sfr@canb.auug.org.au, rientjes@google.com, nadav.amit@gmail.com,
        mhocko@suse.com, quic_charante@quicinc.com,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [patch 163/227] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-ID: <Yjpo2jnp5pkJr+XI@google.com>
References: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
 <20220322214648.AB7A1C340EC@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322214648.AB7A1C340EC@smtp.kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 02:46:48PM -0700, Andrew Morton wrote:
> From: Charan Teja Kalla <quic_charante@quicinc.com>
> Subject: mm: madvise: skip unmapped vma holes passed to process_madvise
> 
> The process_madvise() system call is expected to skip holes in vma passed
> through 'struct iovec' vector list.  But do_madvise, which
> process_madvise() calls for each vma, returns ENOMEM in case of unmapped
> holes, despite the VMA is processed.
> 
> Thus process_madvise() should treat ENOMEM as expected and consider the
> VMA passed to as processed and continue processing other vma's in the
> vector list.  Returning -ENOMEM to user, despite the VMA is processed,
> will be unable to figure out where to start the next madvise.
> 
> Link: https://lkml.kernel.org/r/4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com

I thought it was still under discussion and Charan will post next
version along with previous patch
"mm: madvise: return correct bytes advised with process_madvise"

https://lore.kernel.org/linux-mm/7207b2f5-6b3e-aea4-aa1b-9c6d849abe34@quicinc.com/


> Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
> Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/madvise.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> --- a/mm/madvise.c~mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise
> +++ a/mm/madvise.c
> @@ -1428,9 +1428,16 @@ SYSCALL_DEFINE5(process_madvise, int, pi
>  
>  	while (iov_iter_count(&iter)) {
>  		iovec = iov_iter_iovec(&iter);
> +		/*
> +		 * do_madvise returns ENOMEM if unmapped holes are present
> +		 * in the passed VMA. process_madvise() is expected to skip
> +		 * unmapped holes passed to it in the 'struct iovec' list
> +		 * and not fail because of them. Thus treat -ENOMEM return
> +		 * from do_madvise as valid and continue processing.
> +		 */
>  		ret = do_madvise(mm, (unsigned long)iovec.iov_base,
>  					iovec.iov_len, behavior);
> -		if (ret < 0)
> +		if (ret < 0 && ret != -ENOMEM)
>  			break;
>  		iov_iter_advance(&iter, iovec.iov_len);
>  	}
> _
