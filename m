Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB3D3CB585
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 11:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhGPKCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 06:02:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231386AbhGPKCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 06:02:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626429569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uWrxnkLFe/NFRcovJSGie/L+AIpvwaIHXs/9ffCf/OY=;
        b=NvOd/8j9rxiyHMlT0L2qvrclVhXW2b3vFNWpJU8cfITFRaBALZB0s7yrrkrAEC5sv0O+Eb
        aeEHozoDBQQS77qv0wcYkx5I0lKaBiJh1b/aMKFsl2Xcfip9RUYqPQ3B0YcV0lzne2PMfQ
        Qxel+adVr+eR1sH5dDgvbW/gdsVdnXc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-Xq3G8uR9P5CB6S9MWEMvhA-1; Fri, 16 Jul 2021 05:59:28 -0400
X-MC-Unique: Xq3G8uR9P5CB6S9MWEMvhA-1
Received: by mail-wm1-f69.google.com with SMTP id r13-20020a7bc08d0000b029023a3f081487so1226908wmh.4
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 02:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uWrxnkLFe/NFRcovJSGie/L+AIpvwaIHXs/9ffCf/OY=;
        b=ZAjVvzgbcYDxB/F5/7R2KtVmILyG0RW2Kjygea8DnY3B+43ycx2uV0V6zu7oV3XGGN
         GaObtXQvQQ8Gqf3mi7piAVXTlBLIcaoj2ATRABTP4C+WL5I8U4y24c5jGP2ZOc8Vs1kK
         sz1h15Cm6OqC1bl+Iy8UsSEv57XTdCJRIbTBd8KCF4mGe101Ck+kxYEdIuKoncEiP90V
         RPdNGGhMcv7n5+9OphN6RZiE8X0ovAkGhNXTj8C3IpuSd5ePZgmJGN5sLpJsfZiusio5
         4w91hpeyCIDklqUkaKjZjg/q5+CK/xvdWxQMzbw/0ga0YL7/AN5AzU2+xAYmUhmvziYA
         UXkQ==
X-Gm-Message-State: AOAM533wbhmaYv50EFu0YChFNHKjCkhpH3XHBLHrtIneBSoJoWDvWAGr
        b9xQ+EbyrKgHLqNRLrN+FjIK0OuepzCtMrVSOvm8aQNjSJoMZMoXMJwZmhGkG+ZYBhqI3+Q477f
        j7VLtAkqNBBSnvHj9
X-Received: by 2002:adf:a350:: with SMTP id d16mr11417429wrb.207.1626429567340;
        Fri, 16 Jul 2021 02:59:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhmbeTwTI4IQb8fn0UC6V7hHToNpVZe0mkO+T3dyfnTutgDELBDcL9qaRcDvtPP7OR1Srr7A==
X-Received: by 2002:adf:a350:: with SMTP id d16mr11417416wrb.207.1626429567170;
        Fri, 16 Jul 2021 02:59:27 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c621f.dip0.t-ipconnect.de. [91.12.98.31])
        by smtp.gmail.com with ESMTPSA id p5sm10317783wrd.25.2021.07.16.02.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 02:59:26 -0700 (PDT)
Subject: Re: [PATCH 5.10 140/215] mm,hwpoison: return -EBUSY when migration
 fails
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>
References: <20210715182558.381078833@linuxfoundation.org>
 <20210715182624.294004469@linuxfoundation.org> <20210716095243.GA12505@amd>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <a5539a09-7964-c188-8e58-5173eb587a24@redhat.com>
Date:   Fri, 16 Jul 2021 11:59:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716095243.GA12505@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.07.21 11:52, Pavel Machek wrote:
> Hi!
> 
>> From: Oscar Salvador <osalvador@suse.de>
>>
>> commit 3f4b815a439adfb8f238335612c4b28bc10084d8
> 
> Another format of marking upstream commits. How are this is number 8
> or so. I have scripts trying to parse this, and I don't believe I'm
> the only one.
> 
>> Link: https://lkml.kernel.org/r/20201209092818.30417-1-osalvador@suse.de
>> Signed-off-by: Oscar Salvador <osalvador@suse.de>
>> Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>> Cc: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Could se simply place Upstream: <hash> tag here? That should
> discourage such "creativity"... plus it will make it clear who touched
> patch in mainline context and who in stable context.

This is properly documented

https://www.kernel.org/doc/html/v5.14-rc1//process/stable-kernel-rules.html


"
The upstream commit ID must be specified with a separate line above the 
commit text, like this:

commit <sha1> upstream.
"

-- 
Thanks,

David / dhildenb

