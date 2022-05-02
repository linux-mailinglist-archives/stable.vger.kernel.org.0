Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB645178BF
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 23:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387554AbiEBVGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 17:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387547AbiEBVGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 17:06:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA92BCB3;
        Mon,  2 May 2022 14:03:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 872B9B819C2;
        Mon,  2 May 2022 21:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923F0C385AC;
        Mon,  2 May 2022 21:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651525381;
        bh=OmovROpG4S6hvHwAvxQX6xMhTJmXgyXS4ghxPMNiaiU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=I15MgOFM4oj9/LTAyswDzWSeXxqjehqxQmAwH8O8aqnF0oM4Ii2PK9dcozaFqXU5P
         /XM0JZsq3xtllSe8z11uErXRoIo06+IDxqdfsJ041G3qGgqVGgXr4JnBDFQdlTbtR0
         8215YvziMKI61ukRgkKdqjqA5qWPs18KKAstGRKWTVQ7ZAfr5xkh/2ogsQkL/Rvkpi
         /aeZC4d9FQCPAeFD169ZDzO8hMmQlT1dIumhLISSu5OVSl3OAEDI2gtcoJDZMpd6bx
         tbcppuwbQ9iKgt15tVECfaN0Fvd8FWq5dXoQyIqYXiIoKMYegFriTQak2D1SDK2JII
         6+LTqpehVonQg==
Message-ID: <96911abe-c1c6-42a4-322e-d7b06dae0c8e@kernel.org>
Date:   Mon, 2 May 2022 16:02:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RESEND][PATCH] firmware: stratix10-svc: fix a missing check on
 list iterator
Content-Language: en-US
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     gregkh@linuxfoundation.org, richard.gong@intel.com,
        atull@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220414035609.2239-1-xiam0nd.tong@gmail.com>
From:   Dinh Nguyen <dinguyen@kernel.org>
In-Reply-To: <20220414035609.2239-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/13/22 22:56, Xiaomeng Tong wrote:
> The bug is here:
> 	pmem->vaddr = NULL;
> 
> The list iterator 'pmem' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it will
> lead to a invalid memory access.
> 
> To fix this bug, just gen_pool_free/set NULL/list_del() and return
> when found, otherwise list_del HEAD and return;
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ca5ce896524f ("firmware: add Intel Stratix10 service layer driver")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>   drivers/firmware/stratix10-svc.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
> index 29c0a616b317..30093aa82b7f 100644
> --- a/drivers/firmware/stratix10-svc.c
> +++ b/drivers/firmware/stratix10-svc.c
> @@ -941,17 +941,17 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate_memory);
>   void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
>   {
>   	struct stratix10_svc_data_mem *pmem;
> -	size_t size = 0;
>   
>   	list_for_each_entry(pmem, &svc_data_mem, node)
>   		if (pmem->vaddr == kaddr) {
> -			size = pmem->size;
> -			break;
> +			gen_pool_free(chan->ctrl->genpool,
> +				       (unsigned long)kaddr, pmem->size);
> +			pmem->vaddr = NULL;
> +			list_del(&pmem->node);
> +			return;
>   		}
>   
> -	gen_pool_free(chan->ctrl->genpool, (unsigned long)kaddr, size);
> -	pmem->vaddr = NULL;
> -	list_del(&pmem->node);
> +	list_del(&svc_data_mem);
>   }
>   EXPORT_SYMBOL_GPL(stratix10_svc_free_memory);
>   

Acked-by: Dinh Nguyen <dinguyen@kernel.org>
