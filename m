Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD2B66CD44
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbjAPRfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbjAPRej (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:34:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768693B64A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673888996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i8TyWaBK0rrh9nu6bilmDzmOvJpbEYXbLFcWBZyCEYc=;
        b=btYoZW14qvAZqTnIweBrT80H7NLy1vP4Mmc93pCM25DWF/kzpPGZ8GibLd7FYmYLq86++L
        LFSQPEdYPh1dCNUhOBxY0flmPp2UV8Luq0R2Oh7byCwcV0bxAQZa0I/VsJIHMy5cbxZOr1
        bljJkDfF/rEwRyIJKKqHa5wXho+zEJg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-496-jIrLSliwMLKt5lXKtib00w-1; Mon, 16 Jan 2023 12:09:55 -0500
X-MC-Unique: jIrLSliwMLKt5lXKtib00w-1
Received: by mail-wr1-f71.google.com with SMTP id e29-20020adf9bdd000000b002bb0d0ea681so5509816wrc.20
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:09:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i8TyWaBK0rrh9nu6bilmDzmOvJpbEYXbLFcWBZyCEYc=;
        b=bDLz/CaVgTVeaMn4YiLglu9d9Ejn0V2k0jZjYq0nQH3e8sCGG/nfFeOoHRWSftqWZu
         X2hKjg+nWMqcZEArtiEoxdyCd2xBTfUZlSaq2cc2RhNH8LXX8xtJrBlsIDG53HSlnSAG
         gKBdBsMo3WrljzbVtoqNBDFDGVpj0mNPo9TGoNcXiDf0LUUloVKp3gLK5KtfKf8N271o
         Q4UWv5F40iYEQLKG82+5clnRCAp4M/MTe/VKeLmGFlZJHNNG7mDMfQtdpwm3XAkLeFPq
         gi8j4kIVNQMUL+QgsFGZAPoGLYuPRuFutr7+rD3nzxJI2GTPGyBib1XMXvN5OTxBNAtP
         mfiQ==
X-Gm-Message-State: AFqh2krOA4s4hi0KtDc7ReTndbLE/rFgiJXERyQPyM9PW4+ZrLH2hsIX
        1KBGpTIX7PLnxthhm/FRXAVyXHqhhjterZEQYj0ipYyuM00695WISwLxA0A7vSVVNOnz1XDIyTw
        EkLvQzo6CdOPztGLl
X-Received: by 2002:adf:e991:0:b0:2b9:1a52:4f50 with SMTP id h17-20020adfe991000000b002b91a524f50mr8239438wrm.6.1673888994007;
        Mon, 16 Jan 2023 09:09:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs7mvXxw8Q84+NmHtR/OTm4Mty+RhE+3nJjPMyUyIkH9Wox+5ZFG6IWOaX4Wg2wSZtWBXwm/w==
X-Received: by 2002:adf:e991:0:b0:2b9:1a52:4f50 with SMTP id h17-20020adfe991000000b002b91a524f50mr8239421wrm.6.1673888993725;
        Mon, 16 Jan 2023 09:09:53 -0800 (PST)
Received: from ?IPV6:2003:cb:c704:1000:21d5:831d:e107:fbd6? (p200300cbc704100021d5831de107fbd6.dip0.t-ipconnect.de. [2003:cb:c704:1000:21d5:831d:e107:fbd6])
        by smtp.gmail.com with ESMTPSA id t13-20020adfe10d000000b002b6bcc0b64dsm14372975wrz.4.2023.01.16.09.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 09:09:53 -0800 (PST)
Message-ID: <06185b08-8440-8922-c0aa-f6fb91aa54e0@redhat.com>
Date:   Mon, 16 Jan 2023 18:09:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] mm: do not try to migrate lru_gen if it's not
 associated with a memcg
Content-Language: en-US
To:     Yu Zhao <yuzhao@google.com>, msizanoen1 <msizanoen@qtmlabs.xyz>
Cc:     Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20230115133330.28420-1-msizanoen@qtmlabs.xyz>
 <20230115134651.30028-1-msizanoen@qtmlabs.xyz>
 <CAOUHufahcS0G_GApTdmzE4_Nb_70LGaCkgV0NR_xJuWN2NdJVg@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAOUHufahcS0G_GApTdmzE4_Nb_70LGaCkgV0NR_xJuWN2NdJVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.01.23 00:13, Yu Zhao wrote:
> On Sun, Jan 15, 2023 at 6:47 AM msizanoen1 <msizanoen@qtmlabs.xyz> wrote:
>>
>> In some cases, memory cgroup migration can be initiated by userspace
>> right after a process was created and right before `lru_gen_add_mm()` is
>> called (e.g. by some program watching a cgroup and moving away any
>> processes it detects[1]), which results in the following sequence of
>> WARNs followed by an Oops as the kernel attempts to perform a
>> `lru_gen_add_mm()` twice on the same `mm`:
> 
> ...
> 
>> Fix this by simply leaving the lru_gen alone if it has not been
>> associated with a memcg yet, as it should eventually be assigned to the
>> right cgroup anyway.
>>
>> [1]: https://gitlab.freedesktop.org/benzea/uresourced/-/blob/master/cgroupify/cgroupify.c
>>
>> v2:
>>          Added stable cc tags
>>
>> Signed-off-by: N/A (patch should not be copyrightable)
>> Cc: stable@vger.kernel.org
> 
> Thanks for the fix.  Cc'ing stable is the right thing to do. The
> commit message and the comment styles could be easily adjusted to
> align with the guidelines.
> 
> I don't think the N/A is acceptible though. I fully respect it if you
> wish to remain anonymous -- I can send a similar fix crediting you
> as the "anonymous user <msizanoen@qtmlabs.xyz>" who reported this bug.

Not acceptable:

Documentation/process/submitting-patches.rs

"using your real name (sorry, no pseudonyms or anonymous contributions.)"


-- 
Thanks,

David / dhildenb

