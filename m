Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABD162A119
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 19:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiKOSJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 13:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbiKOSJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 13:09:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099D42D74F
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668535686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YaV9DXbOMx4t3KxfWAWxFC1KlWvt+Cyg0TC84c9INLk=;
        b=F0mxF8IqF5crJ+gD1wCoozstIsFTwRugQpAA2ak3e8kphVUQ06TWJsZYIpCPibi2wRuFal
        kXZE2Q3/veGG0QCNxLjj4Waeobnkv5T7wOQeZlVLT45YdBO7HFMDqJIPYRTzP06ZHgDVwN
        moNt8jlK+Cwn7ZxrUZgMEc9kqxH7ZlE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-X3IteDYdP1aK7pYJWlRATA-1; Tue, 15 Nov 2022 13:08:04 -0500
X-MC-Unique: X3IteDYdP1aK7pYJWlRATA-1
Received: by mail-wm1-f69.google.com with SMTP id 186-20020a1c02c3000000b003cfab28cbe0so10824589wmc.9
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:08:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YaV9DXbOMx4t3KxfWAWxFC1KlWvt+Cyg0TC84c9INLk=;
        b=HsYzfqGnh2INT8zXyCWHB38MRRt1yzaSfl3GMRmgEbxJC7U49mRrMVe2BLPcfbCcvx
         ZEtex9+mix2GsBp2+3E/iXinf9+e3v8CixxJNgyDvilAV8LjQ5Kc0oXncmQ0b6+M/F3O
         EgHCqbj1yA55nhfRzV0QMtraZOulgz5txh9QmIuPYGzvhttWdLMyZwrGck8pKzT5f7DQ
         S2avaQvN+Bi4Z4tsy/qZgceCqpynYNdLaHPwyebn+hfk9a4CDkXHMXx2K+V2KxnZIVgV
         l3N3o9iZ8eaQFTrZCV+BW/Ym/7kuVpn3TavJ5UF3+97rGi0iprpta07/MekIjv5h7cAJ
         vBoA==
X-Gm-Message-State: ANoB5pljLbDZYRbNOHJsaGJGHfDpVdjy+/3SFH0a3+Vfr/eQB0h5zQNA
        HwqdFVvaBj06b1DgiCUN5MV3IHL425eeu92PUv86M5yONfDDT6Ve6NALJLRdQRRpuzAx1cSL99r
        CRCOVop05eLl4Nl0k
X-Received: by 2002:a05:600c:3ac8:b0:3c6:f252:f072 with SMTP id d8-20020a05600c3ac800b003c6f252f072mr1210425wms.145.1668535683579;
        Tue, 15 Nov 2022 10:08:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7kDog3e2g4dZrQaNUBIv/mNp2vLh/DXOZ8aV1zDYH6nrKZG4euRmQihWvuSTkYhtvNm04g0Q==
X-Received: by 2002:a05:600c:3ac8:b0:3c6:f252:f072 with SMTP id d8-20020a05600c3ac800b003c6f252f072mr1210405wms.145.1668535683256;
        Tue, 15 Nov 2022 10:08:03 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:9d00:9303:90ce:6dcb:2bc9? (p200300cbc7079d00930390ce6dcb2bc9.dip0.t-ipconnect.de. [2003:cb:c707:9d00:9303:90ce:6dcb:2bc9])
        by smtp.gmail.com with ESMTPSA id bk3-20020a0560001d8300b002366c3eefccsm12567795wrb.109.2022.11.15.10.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 10:08:02 -0800 (PST)
Message-ID: <dc5a5173-deeb-a6d0-6c2f-5f6f448bf83e@redhat.com>
Date:   Tue, 15 Nov 2022 19:08:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
 <9af36be3-313b-e39c-85bb-bf30011bccb8@redhat.com> <Y3KgYeMTdTM0FN5W@x1n>
 <ec8b3c86-d3b2-f898-7297-c20a58ae2ac1@redhat.com> <Y3O5bCXSbvKJrjRL@x1n>
 <82d7a142-8c78-4168-37e9-7b677b18987a@redhat.com> <Y3PUgOUYx6ECN405@x1n>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Y3PUgOUYx6ECN405@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.11.22 19:03, Peter Xu wrote:
> On Tue, Nov 15, 2022 at 06:22:03PM +0100, David Hildenbrand wrote:
>> That's precisely what I had in mind recently, and I am happy to hear that
>> you have similar idea:
>>
>> https://lkml.kernel.org/r/20221108174652.198904-6-david@redhat.com
>>
>> "
>> Note that we don't optimize for the actual migration case:
>> (1) When migration succeeds the new PTE will not be writable because the
>>      source PTE was not writable (protnone); in the future we
>>      might just optimize that case similarly by reusing
>>      can_change_pte_writable()/can_change_pmd_writable() when removing
>>      migration PTEs.
>> "
> 
> I see, sorry I haven't yet read it, but sounds doable indeed.
> 
>>
>> Currently, "readable_migration_entry" is even wrong: it might be PROT_NONE
>> and not even readable.
> 
> Do you mean mprotect(PROT_NONE)?
> 
> If we read the "read migration entry" as "migration entry with no write
> bit", it seems still fine, and code-wise after pte recovered it should
> still be PROT_NONE iiuc because mk_pte() will just make a pte without
> e.g. _PRESENT bit set on x86 while it'll have the _PROT_NONE bit.

Exactly that's the unintuitive interpretation of 
"readable_migration_entry". By "wrong" I meant: the naming is wrong.

> 
> May not keep true for numa balancing though: when migration happens after a
> numa hint applied to a pte, it seems to me it's prone to lose the hint
> after migration completes (assuming this migration is not the numa
> balancing operation itself caused by a page access).  Doesn't sound like a
> severe issue though even if I didn't miss something, since if the page got
> moved around the original hint may need to reconsider anyway.

Yes, I think any migration will lose fake PROT_NONE. "Fake" as in "not 
VMA permissions" but "additional permissions imposed by NUMA hinting 
faults."

-- 
Thanks,

David / dhildenb

