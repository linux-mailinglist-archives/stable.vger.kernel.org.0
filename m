Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F035A2CBE
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 18:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344824AbiHZQrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 12:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344825AbiHZQrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 12:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2043D4D4F1
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 09:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661532367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aM/0vWRQhG6l7795J8Sv+413xc0zb7CfNl42O6VQfck=;
        b=FBxHiUqU9FVpa7Horoiw5XLQf84aODDYVcVdXQTPTBqa548PgpKeq6u5jPC7wPlIq5rwHm
        wUtmrL4APmTS/c3/qKNtaVL9Hd/jUIi4vT1fecTD1koa8ild7yJizT5pDCsE1PRPTq8jr9
        1T17Yxox02xa/7JAlfQJks3MVVr5O3c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-584-ia-QS8-3N1mmzE3HHFOG0Q-1; Fri, 26 Aug 2022 12:46:05 -0400
X-MC-Unique: ia-QS8-3N1mmzE3HHFOG0Q-1
Received: by mail-wm1-f69.google.com with SMTP id p19-20020a05600c1d9300b003a5c3141365so4298820wms.9
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 09:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=aM/0vWRQhG6l7795J8Sv+413xc0zb7CfNl42O6VQfck=;
        b=SVvZBD/ulR/5VIbKI4KrcN9aAB1K1byFOcTCgwQvajJvOk5XLMD9SSO3TAuy7df3Te
         95oEBeZhuL25RdZrmHyfxQAVb+WaR3nGEcUM1AXZWO+OQROB2oHQWDNailF5RVKBRUun
         NoNb4yQ5dDMszXH4CxOUhUUr6FA63uZk68YZxFFn83bGm+0J9+N3otYxx/Ym1nB7XpOo
         lAJCadKgx4eWkCKY5NnVC6vdtBAkEm/aPRap2FItkvon1eXR3CeKyeB3OAbUJPjHAfB2
         +TQ8pTiID6aXwWDdwIk+ls6cLPpQN1p0syTpCQISjYhcTRu8X8UN+aKvlrdJmfkAHveX
         93EQ==
X-Gm-Message-State: ACgBeo02Zi/O0sh1ES2/A4iGn/Foq8rBz8LHbGMOetAn0fRs1PMcRy7d
        Ukh/n4GNUxaHfMY3HJORMV4+14s1J3s/SlnPoMSuv3urlWbNgETqrWigjYjvS5pCMdwEpV5PWW5
        mlLXObjjd99kkSx/R
X-Received: by 2002:a7b:cd0f:0:b0:3a5:ec59:daf0 with SMTP id f15-20020a7bcd0f000000b003a5ec59daf0mr279203wmj.13.1661532364613;
        Fri, 26 Aug 2022 09:46:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR40NbGvjbiWl5L8l+XuL5Rh4KAQqMtg/LZ8GOIke5nZFYZHD6d6ipQhIpQgrK46S3HVwjTkJA==
X-Received: by 2002:a7b:cd0f:0:b0:3a5:ec59:daf0 with SMTP id f15-20020a7bcd0f000000b003a5ec59daf0mr279186wmj.13.1661532364308;
        Fri, 26 Aug 2022 09:46:04 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:f600:abad:360:c840:33fa? (p200300cbc708f600abad0360c84033fa.dip0.t-ipconnect.de. [2003:cb:c708:f600:abad:360:c840:33fa])
        by smtp.gmail.com with ESMTPSA id l9-20020a7bc349000000b003a5fa79007fsm162159wmj.7.2022.08.26.09.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 09:46:03 -0700 (PDT)
Message-ID: <140e7688-b66d-2f6d-fed8-e39da5045420@redhat.com>
Date:   Fri, 26 Aug 2022 18:46:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <ffbc824af5daa2c44b91c66834a341894fba4ce6.1661309831.git-series.apopple@nvidia.com>
 <YwZGHyYJiJ+CGLn2@xz-m1.local> <8735dkeyyg.fsf@nvdebian.thelocal>
 <YwgFRLn43+U/hxwt@xz-m1.local> <8735dj7qwb.fsf@nvdebian.thelocal>
 <YwjZamk4n/dz+Y/M@xz-m1.local>
 <72146725-3d70-0427-50d4-165283a5a85d@redhat.com>
 <Ywjs/i4kIVlxZwpb@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 2/3] mm/migrate_device.c: Copy pte dirty bit to page
In-Reply-To: <Ywjs/i4kIVlxZwpb@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.08.22 17:55, Peter Xu wrote:
> On Fri, Aug 26, 2022 at 04:47:22PM +0200, David Hildenbrand wrote:
>>> To me anon exclusive only shows this mm exclusively owns this page. I
>>> didn't quickly figure out why that requires different handling on tlb
>>> flushs.  Did I perhaps miss something?
>>
>> GUP-fast is the magic bit, we have to make sure that we won't see new
>> GUP pins, thus the TLB flush.
>>
>> include/linux/mm.h:gup_must_unshare() contains documentation.
> 
> Hmm.. Shouldn't ptep_get_and_clear() (e.g., xchg() on x86_64) already
> guarantees that no other process/thread will see this pte anymore
> afterwards?

You could have a GUP-fast thread that just looked up the PTE and is
going to pin the page afterwards, after the ptep_get_and_clear()
returned. You'll have to wait until that thread finished.

Another user that relies on this interaction between GUP-fast and TLB
flushing is for example mm/ksm.c:write_protect_page()

There is a comment in there explaining the interaction a bit more detailed.

Maybe we'll be able to handle this differently in the future (maybe once
this turns out to be an actual performance problem). Unfortunately,
mm->write_protect_seq isn't easily usable because we'd need have to make
sure we're the exclusive writer.


For now, it's not too complicated. For PTEs:
* try_to_migrate_one() already uses ptep_clear_flush().
* try_to_unmap_one() already conditionally used ptep_clear_flush().
* migrate_vma_collect_pmd() was the one case that didn't use it already
 (and I wonder why it's different than try_to_migrate_one()).

-- 
Thanks,

David / dhildenb

