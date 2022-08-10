Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD5E58E99F
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 11:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiHJJ3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 05:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiHJJ3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 05:29:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C288B6B650
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660123744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cYlVavV3CJNDmR/k23+nnTOqqc22cvfzjUUlVxgKawU=;
        b=VST4oFlF9bHb71OO0hPH1Ey8qI6kOu4nkyggi7JQnAzrhvaRYQuVtAUM0+vdFpY9hRoTGj
        2ss7KSg7vMUh2T8fSLKfSPVdsbqZ7eKkGUg0OtRcgK9aj4UBSsuG9K+YnltK7Jw1McIQrY
        jbfpUKdxCXxWT4v/4XmN2Jrl/YaWpzE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-BS_OAcgpOi-3MGHGsUFHjw-1; Wed, 10 Aug 2022 05:29:03 -0400
X-MC-Unique: BS_OAcgpOi-3MGHGsUFHjw-1
Received: by mail-wr1-f72.google.com with SMTP id e21-20020adf9bd5000000b002207a51b7feso2191936wrc.10
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:29:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=cYlVavV3CJNDmR/k23+nnTOqqc22cvfzjUUlVxgKawU=;
        b=q/M9DJCdw2jSbzUcu7O0pMbXDa7BLhIDA6iCIJKmCDulglbD6JHl1ZyzAax+PYoj5d
         9NvOfzwo9pmwFL8r6eEx+0KmO0evEsH/nFrj1sm78N6s4ODjuv421imeV4ESjcTMkxZS
         Sm9djIEZwyObeyVU4BzEMl4XSQ5cz4ZwN4Cm845p4Osu/qCsysmPDRIbBC1xXlrA10g9
         tiq/kE37jHOuAPvaEVxPc+gbK9RUbJjQND1LJpaPJm64UdoG7NbUo8+M9mUCa7Dk+2/2
         6yNCzKVSEvi+UDEPxytcysQQfAeJqo7LgKHBm4KIer2lJyH2VaqQ5Oz2XD722Hjfy/YS
         FZ0A==
X-Gm-Message-State: ACgBeo1yf4NKG2wYClv2vls0GZl9wMYZFGVfoAIODHNKQeJ3JkI7k7lS
        r/7921TMqluXSMwVrqbDVyi9m8lF1gMb5iQOmcWppeIpszZBLdTYs5mMNbJiGUI5ZGCEdmesSqr
        /yhRqQya4Vt/ibIzf
X-Received: by 2002:a05:600c:5125:b0:3a4:f57b:d34c with SMTP id o37-20020a05600c512500b003a4f57bd34cmr1796440wms.193.1660123742438;
        Wed, 10 Aug 2022 02:29:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Ow3GCEx+75VtQ8c5nEXiLi3RCfkdiTsOt80b5J4UMof9inMEunF/B0LrI+KlpZGPls9w9Ow==
X-Received: by 2002:a05:600c:5125:b0:3a4:f57b:d34c with SMTP id o37-20020a05600c512500b003a4f57bd34cmr1796424wms.193.1660123742178;
        Wed, 10 Aug 2022 02:29:02 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:1600:a3ce:b459:ef57:7b93? (p200300cbc7071600a3ceb459ef577b93.dip0.t-ipconnect.de. [2003:cb:c707:1600:a3ce:b459:ef57:7b93])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d514d000000b0021d7ad6b9fdsm15792376wrt.57.2022.08.10.02.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 02:29:01 -0700 (PDT)
Message-ID: <40b78cfd-c43a-8624-cd1e-8680a081a10d@redhat.com>
Date:   Wed, 10 Aug 2022 11:29:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com> <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey> <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
 <Yu1ie559zt8VvDc1@monkey> <73050e64-e40f-0c94-be96-316d1e8d5f3b@redhat.com>
 <Yu2CI4wGLHCjMSWm@monkey> <Yu2kK6s8m8NLDjuV@xz-m1.local>
 <36bcc1f5-40e9-2d2b-3e94-18994bf62ca4@redhat.com>
 <YvFjww9AX/BuHdSn@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YvFjww9AX/BuHdSn@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.08.22 21:28, Peter Xu wrote:
> On Mon, Aug 08, 2022 at 06:36:58PM +0200, David Hildenbrand wrote:
>> Well, because the write-fault handler as is cannot deal with
>> write-faults in shared mappings. It cannot possibly work or ever have
>> worked.
> 
> Trivially - maybe drop the word "require" in "Hugetlb does not
> require/support writenotify"?
> 

Sure, can do.

-- 
Thanks,

David / dhildenb

