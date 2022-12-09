Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44787647EF7
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 09:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLIIIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 03:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLIIIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 03:08:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FC11E3DC
        for <stable@vger.kernel.org>; Fri,  9 Dec 2022 00:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670573268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6IK0RYF1mOQiFFce0wSrPhJPVQgIzsR5SoBxpS0hXY=;
        b=XULlyeTBke19xgHeCRXM8ZQd5lwov37fDBpj6HR5gbuhj6p768XDyBm1/MsBIUfNr5wwgr
        uW6TJ4L1J6ihKEQp9dK99p3NPxJZGi3ZwxPd5zVaSCiIBryMfceQsmey5d3PPovv0DXeuv
        I9DItlEV5wnxtRNbH0/+RLwDtjCaoXI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-111-suXFVofdNE-yEYjZF1AkLw-1; Fri, 09 Dec 2022 03:07:47 -0500
X-MC-Unique: suXFVofdNE-yEYjZF1AkLw-1
Received: by mail-wm1-f71.google.com with SMTP id v125-20020a1cac83000000b003cfa148576dso2047610wme.3
        for <stable@vger.kernel.org>; Fri, 09 Dec 2022 00:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6IK0RYF1mOQiFFce0wSrPhJPVQgIzsR5SoBxpS0hXY=;
        b=TxCEI5gDBglEAfhhj0Ayq1rbNhaknNeA8LkPL0nDwBsRe/OwMml3WTe1dZVvCGboOI
         XpCIepQEzXcVtbn5nzK0ngB+PMAqT2F8pbGFumPZpEvunz4X7tqW0wl3Nlozu8rcYDBp
         HG9HKH2gsWCZW0QDg0jsZqSzVWPDyVoRRqL9VizUdI2ce8UWF3OlBQ6f4Ktq/MlN7mp/
         qWGRQKV8y44K6l54eX0XAKTl6m7B2cXbcreHjgcf9X+AnLzOzWGHEuKGlTamGdpO7i3I
         czYNr9sA/0zrm/loQkcJHKE1jizCHAgtM/8rOv26Ke79SA2g47quMpZRHa22ssAqUtET
         gMrA==
X-Gm-Message-State: ANoB5pm1MZD0j1223HDkwJwMdihWjY18gxihdpiaaHKhXuWPdxDjItrp
        2owvKf/pAufGI/B6+ZMXh/Ar1A6c23+4HpgpRvW6maza24mE4D5c2vormTz58fyjQv+1an7AZ9w
        w1H2Xzmcxh2NP1OV0
X-Received: by 2002:a05:600c:3549:b0:3c6:e61e:ae8c with SMTP id i9-20020a05600c354900b003c6e61eae8cmr5001706wmq.28.1670573266445;
        Fri, 09 Dec 2022 00:07:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Uqk/m+cV884khbOL7tzw++hE9c8qAXEjR5hBPFxYbxE9taUU5qsEX/VMC87zkwTztnfgjew==
X-Received: by 2002:a05:600c:3549:b0:3c6:e61e:ae8c with SMTP id i9-20020a05600c354900b003c6e61eae8cmr5001690wmq.28.1670573266112;
        Fri, 09 Dec 2022 00:07:46 -0800 (PST)
Received: from ?IPV6:2003:cb:c702:2e00:b9ea:114c:a3f5:327e? (p200300cbc7022e00b9ea114ca3f5327e.dip0.t-ipconnect.de. [2003:cb:c702:2e00:b9ea:114c:a3f5:327e])
        by smtp.gmail.com with ESMTPSA id t14-20020a05600c198e00b003cfd4a50d5asm7387447wmq.34.2022.12.09.00.07.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 00:07:45 -0800 (PST)
Message-ID: <6209d614-b1f2-4501-6b8a-6d4095c309eb@redhat.com>
Date:   Fri, 9 Dec 2022 09:07:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20221208114137.35035-1-david@redhat.com> <Y5IQzJkBSYwPOtiP@x1n>
 <b9162f04-7d8e-1ada-f428-85fd84327d1c@redhat.com> <Y5JDrkBGEyZviXz9@x1n>
 <Y5JHY2zyK4k8aBtX@x1n>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Y5JHY2zyK4k8aBtX@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.12.22 21:21, Peter Xu wrote:
> On Thu, Dec 08, 2022 at 03:06:06PM -0500, Peter Xu wrote:
>> On Thu, Dec 08, 2022 at 05:44:35PM +0100, David Hildenbrand wrote:
>>> I'll wait for some more (+retest) before I resend tomorrow.
>>
>> One more thing just to double check:
>>
>> It's 6a56ccbcf6c6 ("mm/autonuma: use can_change_(pte|pmd)_writable() to
>> replace savedwrite", 2022-11-30) that just started to break uffd-wp on
>> numa, am I right?
>>
>> With the old code, pte_modify() will persist uffd-wp bit, afaict, and we
>> used to do savedwrite for numa hints.  That all look correct to me until
>> the savedwrite removal patchset with/without vm_page_prot changes.
>>
>> If that's the case, we'd better also mention that in the commit message and
>> has another Fixes: for that one to be clear.
> 
> Nah, never mind.  I think the savedwrite will not guarantee pte write
> protected just like the migration path.  The commit message is correct.

Right, the problem is not the uffd-wp bit getting lost, but the write 
bit getting set, which is independent of 6a56ccbcf6c6. Thanks for 
double-checking 6a56ccbcf6c6.

-- 
Thanks,

David / dhildenb

