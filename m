Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243BE62A131
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 19:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiKOSRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 13:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiKOSRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 13:17:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0632FC06
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668536200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kj5gUGjnNL7HTJHnWGJEGP1r8ya+Z2yQIMJyOuFXDbI=;
        b=VZDMItO1rd+mZ/JFxG/fREocnYo8mwSpw9HAEJ6amXZ5+U2xpAkVWC7WKQnm8kKsg1YUhO
        ADAZ+K1YSp9p118pmJ+pUjd7SyK0O5PWMEkZ2xyW46vKwCu6ItHY9dIHRheAbYaN1tqVEP
        MPiSoluPuZwukcCnXy34TJvAdDOnlr8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-46-vKSG0MqHOcWAHp39UFH2sw-1; Tue, 15 Nov 2022 13:16:38 -0500
X-MC-Unique: vKSG0MqHOcWAHp39UFH2sw-1
Received: by mail-wm1-f71.google.com with SMTP id i9-20020a1c3b09000000b003cfbaa32cfdso5842487wma.2
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:16:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kj5gUGjnNL7HTJHnWGJEGP1r8ya+Z2yQIMJyOuFXDbI=;
        b=R+GC5Mw2nxrNQae2Fql2s2gGGlP8Uka22tX9feCL9jNceazFe5NFr0Ii2rUj3Dg7F2
         MpgwaFvKy8w1jLSbstJqM923m8OcckvdFdeim8am2OtVuNaAG4H5qih1xIrh0+xURwo7
         Um2jq3mTXt003SfgFiuvdH7EZqMi9g80Ml5B4+lVZjMJ/+IwaB3DOwmgM7Bu8mUhO9CB
         s84GsPxvPHQqAMUDnWI3GuXvyLIzQpaJ1DY5KIP907mpd+DCDGpkQ74ke2IDu4lB1KNj
         YUrnlb0MU4oapwsQlT50Fa2WtvabexM/gw7K/iswhm7lPaE7TmNwtzQiA7uSlvNwho+3
         pBNQ==
X-Gm-Message-State: ANoB5pmUnbqVL31wFng2vcOIyLea28kbe0lo4BrnFTOw7Xs3vpsZkkiA
        K7Dvk++v8O8i8ckPbz4BFfG1TmOUfxhVlh9l/2HunFf+V+6AkiTkWFb4BW/XObmVcYLRH0/hAVk
        IIXnCiKoCTwq36iJa
X-Received: by 2002:a7b:c4c7:0:b0:3cf:d58f:f66e with SMTP id g7-20020a7bc4c7000000b003cfd58ff66emr1324760wmk.165.1668536197463;
        Tue, 15 Nov 2022 10:16:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6AVO/NeUZORJwsG145z9PSzkGDH22DT4G3Auyd7YAlI8y6wYKkqYr2uJDocMHWZjck43jIAQ==
X-Received: by 2002:a7b:c4c7:0:b0:3cf:d58f:f66e with SMTP id g7-20020a7bc4c7000000b003cfd58ff66emr1324747wmk.165.1668536197223;
        Tue, 15 Nov 2022 10:16:37 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:9d00:9303:90ce:6dcb:2bc9? (p200300cbc7079d00930390ce6dcb2bc9.dip0.t-ipconnect.de. [2003:cb:c707:9d00:9303:90ce:6dcb:2bc9])
        by smtp.gmail.com with ESMTPSA id c7-20020a1c3507000000b003c6f1732f65sm21054960wma.38.2022.11.15.10.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 10:16:36 -0800 (PST)
Message-ID: <dae5f784-9342-1117-bc58-3d12f98746e1@redhat.com>
Date:   Tue, 15 Nov 2022 19:16:35 +0100
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
 <82d7a142-8c78-4168-37e9-7b677b18987a@redhat.com>
 <2ed12722-2359-cb07-53e7-566d959d311e@redhat.com> <Y3PWP9RPjg5FObMN@x1n>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Y3PWP9RPjg5FObMN@x1n>
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

On 15.11.22 19:11, Peter Xu wrote:
> On Tue, Nov 15, 2022 at 06:54:09PM +0100, David Hildenbrand wrote:
>> No it isn't natural. But sneaking such a change into your fix seems wrong.
>> Touching !uffd-wp code should be separate, if we want to do this at all (as
>> we discussed, maybe the better/cleaner approach is to eliminate writable
>> migration entries if possible).
> 
> If you see I made the subject as mm/migrate, because I took it as a
> migration change, not uffd-wp specific.  I also added the Fixes to the uffd
> patch because afaict that's the only thing that it affects, but I can't
> tell either.
> 
> As I said, I'm trying to follow the rule where we have read entry I want to
> make sure write bit removed.

I really don't think we should do that generic change.

-- 
Thanks,

David / dhildenb

