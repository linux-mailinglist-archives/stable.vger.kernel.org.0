Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD024E2BFB
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 16:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350064AbiCUPUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 11:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350164AbiCUPUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 11:20:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6AC2E9D8;
        Mon, 21 Mar 2022 08:18:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 24EDD1F385;
        Mon, 21 Mar 2022 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647875900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xFpX1rFA2m/zDU4C8dgv2bCPZ2EIaAccPKrj70k0GOM=;
        b=b74XJAqnFxOPGE0Q6Z+YPvZrhh4KRmkGHVja+nAhwlpSDjdL5ZDKd1A91IjFmLjnRM94bn
        WYmPxDb52SuemoDZSuo/NGnwSXp6nHD2VcHe+juNbS9pMeymWpn/SCV1hXrOwpdMi0y9Dr
        vHBSPfpW3LCO4ihfE6DDmdaCvZ/V3jk=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 71D61A3BA0;
        Mon, 21 Mar 2022 15:18:19 +0000 (UTC)
Date:   Mon, 21 Mar 2022 16:18:18 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     akpm@linux-foundation.org, surenb@google.com, vbabka@suse.cz,
        rientjes@google.com, sfr@canb.auug.org.au, edgararriaga@google.com,
        minchan@kernel.org, nadav.amit@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,1/2] mm: madvise: return correct bytes advised with
 process_madvise
Message-ID: <YjiXOmbO9bn1r/wC@dhcp22.suse.cz>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <125b61a0edcee5c2db8658aed9d06a43a19ccafc.1647008754.git.quic_charante@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <125b61a0edcee5c2db8658aed9d06a43a19ccafc.1647008754.git.quic_charante@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 11-03-22 20:59:05, Charan Teja Kalla wrote:
> The process_madvise() system call returns error even after processing
> some VMA's passed in the 'struct iovec' vector list which leaves the
> user confused to know where to restart the advise next. It is also
> against this syscall man page[1] documentation where it mentions that
> "return value may be less than the total number of requested bytes, if
> an error occurred after some iovec elements were already processed.".
> 
> Consider a user passed 10 VMA's in the 'struct iovec' vector list of
> which 9 are processed but one. Then it just returns the error caused on
> that failed VMA despite the first 9 VMA's processed, leaving the user
> confused about on which VMA it is failed. Returning the number of bytes
> processed here can help the user to know which VMA it is failed on and
> thus can retry/skip the advise on that VMA.
> 
> [1]https://man7.org/linux/man-pages/man2/process_madvise.2.html.
> 
> Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
> Cc: <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
> Changes in V2:
>  -- Separated the ENOMEM handling and return bytes processed, as per Minchan comments.
>  -- This contains correcting return bytes processed with process_madvise().
> 
> Changes in V1:
>  -- Fixed the ENOMEM handling and return bytes processed by process_madvise.
>  -- https://patchwork.kernel.org/project/linux-mm/patch/1646803679-11433-1-git-send-email-quic_charante@quicinc.com/
> 
>  mm/madvise.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 38d0f51..e97e6a9 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1433,8 +1433,7 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
>  		iov_iter_advance(&iter, iovec.iov_len);
>  	}
>  
> -	if (ret == 0)
> -		ret = total_len - iov_iter_count(&iter);
> +	ret = (total_len - iov_iter_count(&iter)) ? : ret;
>  
>  release_mm:
>  	mmput(mm);
> -- 
> 2.7.4

-- 
Michal Hocko
SUSE Labs
