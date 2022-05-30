Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638F9537504
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiE3G4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 02:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiE3G4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 02:56:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79E0871A10
        for <stable@vger.kernel.org>; Sun, 29 May 2022 23:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653893764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sa2UmNF2oMi53vg8Q5rSsHt/HYB4lW6/nqq4AMUDDrA=;
        b=SxJHBl5PMRWJjrqs2fKdJ20cHxSJIZny3rlRtfGeS0ltowRPXDkr35GNrplql4p3Rzp2X3
        wMTtn7AXM9nHCoqMtcfILObr8OB3y0Wh5Ho2nG8qn7RBrstY7y/6Jq3BjZosY/KTTO+uXp
        Yg2i+oqiS0My2ip7K2jxF4e/oW9OMrQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-mEnS4Hv6NiWzs8ddjFYVrg-1; Mon, 30 May 2022 02:56:02 -0400
X-MC-Unique: mEnS4Hv6NiWzs8ddjFYVrg-1
Received: by mail-wr1-f70.google.com with SMTP id p10-20020adfaa0a000000b0020c4829af5fso1377254wrd.16
        for <stable@vger.kernel.org>; Sun, 29 May 2022 23:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Sa2UmNF2oMi53vg8Q5rSsHt/HYB4lW6/nqq4AMUDDrA=;
        b=OUVsqo68BZRmfxZf8uKCuabZF56jtppAqjVMsveIiSEfhcdAGZWJ44HsmZwl8Cn7GX
         h1+BZZzuRmybmTPzVgK4DthVqu+790KRalgyg0eMiHBjcQiBEVlw4eaKB5doR71qa6vH
         rKGjE+V35TbTPk30YAAuQPiAJtfhxHXQRd/JF/nJ4J082s6vx+0ZTdJnOcsEuEhXAcsl
         zME/hU3FBIRZlWRXM9mJO4j0/Je7qkY8FQFZwKsf3B8hqkhYzsISwQFiNL3vNviGKW0i
         Pqqybl7kxmcPDxxg2zUGs3nJk/oTeOe+x50OW8ME0KoXLJss+QlRwlzuAZolXLLQ8GtH
         AnSA==
X-Gm-Message-State: AOAM530qpfEtX3I1j5fOWjBNRQ5US+blX49j/vvWPkR8HAsPKHNmKzpL
        mSdOHdm2vQ685Wc39Dmv7jaYZ99jyX5CZT/XTHPsx4Eckzcin6+UFjQunPf9WVZH+JE1CzAlbTW
        rneZGTXaEyD1juL08
X-Received: by 2002:a7b:c1cd:0:b0:397:30fb:5378 with SMTP id a13-20020a7bc1cd000000b0039730fb5378mr17441377wmj.115.1653893761576;
        Sun, 29 May 2022 23:56:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxseDVYrx2gUT56kMtQRoTvs35zkrsUHdM9CpTWT6+j5+ntRxhJRT9OjJTXFwn8/Hu1I+1IIQ==
X-Received: by 2002:a7b:c1cd:0:b0:397:30fb:5378 with SMTP id a13-20020a7bc1cd000000b0039730fb5378mr17441364wmj.115.1653893761312;
        Sun, 29 May 2022 23:56:01 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:7c00:aaa9:2ce5:5aa0:f736? (p200300cbc7047c00aaa92ce55aa0f736.dip0.t-ipconnect.de. [2003:cb:c704:7c00:aaa9:2ce5:5aa0:f736])
        by smtp.gmail.com with ESMTPSA id e9-20020adfe389000000b0020c5253d8fcsm9690559wrm.72.2022.05.29.23.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 May 2022 23:56:00 -0700 (PDT)
Message-ID: <0563a019-09e3-a176-d4c1-c240f3cf62d0@redhat.com>
Date:   Mon, 30 May 2022 08:55:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] mm: memory_hotplug: fix memory error handling
Content-Language: en-US
To:     Muchun Song <songmuchun@bytedance.com>, gregkh@linuxfoundation.org,
        rafael@kernel.org, cheloha@linux.vnet.ibm.com, mhocko@suse.com,
        akpm@linux-foundation.org, nathanl@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220530053326.41682-1-songmuchun@bytedance.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220530053326.41682-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.05.22 07:33, Muchun Song wrote:
> The device_unregister() is supposed to be used to unregister devices if
> device_register() has succeed.  And device_unregister() will put device.
> The caller should not do it again, otherwise, the first call of
> put_device() will drop the last reference count, then the next call
> of device_unregister() will UAF on device.
> 
> Fixes: 4fb6eabf1037 ("drivers/base/memory.c: cache memory blocks in xarray to accelerate lookup")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/base/memory.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 7222ff9b5e05..084d67fd55cc 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -636,10 +636,9 @@ static int __add_memory_block(struct memory_block *memory)
>  	}
>  	ret = xa_err(xa_store(&memory_blocks, memory->dev.id, memory,
>  			      GFP_KERNEL));
> -	if (ret) {
> -		put_device(&memory->dev);
> +	if (ret)
>  		device_unregister(&memory->dev);
> -	}
> +
>  	return ret;
>  }
>  

See

https://lkml.kernel.org/r/d44c63d78affe844f020dc02ad6af29abc448fc4.1650611702.git.christophe.jaillet@wanadoo.fr

-- 
Thanks,

David / dhildenb

