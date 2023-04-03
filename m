Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C216D4405
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 14:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjDCMDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 08:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDCMDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 08:03:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A074AD01
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 05:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680523357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GDB/hmJOcrYFtJnN1TBanTBM2RE49CIj8eveC48zPtU=;
        b=IWxkp/Ucy8xVRHY29w6pFdNFAL0UKAn+fpZuP6Fjk5a85wNSzFx/uVjjp8UqeJQAS/aWs+
        VY+wP5ZcB2b1t0ODls33mNCBqpIGZJiJJlrdFdP10MLyYXqpNw66wD705rqc4zib1rtRUL
        oVCpRpujiW2bUbwLiI8biBxVPEQqfRw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-cAROLBi_MeaQKYI95zZOkQ-1; Mon, 03 Apr 2023 08:02:36 -0400
X-MC-Unique: cAROLBi_MeaQKYI95zZOkQ-1
Received: by mail-wm1-f71.google.com with SMTP id h22-20020a05600c351600b003ef739416c3so9664409wmq.4
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 05:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680523355;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GDB/hmJOcrYFtJnN1TBanTBM2RE49CIj8eveC48zPtU=;
        b=XWFGfiR57HVpwKpo1WaKbv4XObxOElk6hDsqZwVpClsMeTrms0Eu3keffGuyzUvGeQ
         2GypXFO7MoI5QsBMOav5ZpZ7Ye1SVXccUrstIom4u9BNkRb2i7d/GMNSCrQPGAQBJ8h6
         AuXjny0m6jXfHIvIncAypuLBVyITLWmmEJ4PSNwsUGG3BTtRFAEF36wcZ2QKAwsJszbN
         WNKwaY+YB0bqJF5B83MU53qbFjqQxTCmMJu3Mz3ITaP5n6aEA1WKvpG7XfU3Jjt5y5zg
         MLsToBxFuVfPooeHs0gNC/rlqB8DP7aN6lJV81o9DA8jwZjKqGS+0qCED8C23ivOoB8M
         wL7Q==
X-Gm-Message-State: AAQBX9cKZ+ftCs1lisOo1Qwx6MCxlzxoOOUhBI8ah+RpiJA5YwCEKETP
        m+fxJLuZsLdI4+cQ6qTx6r61D/Juc2UYGs2cwzGvQZHK/9C2u6hXDWQXZjrX81UzE3xVRG1/xAZ
        WvVo5LINTuqqGY1Fj
X-Received: by 2002:a7b:ce88:0:b0:3f0:3a5a:362e with SMTP id q8-20020a7bce88000000b003f03a5a362emr10037672wmj.39.1680523355005;
        Mon, 03 Apr 2023 05:02:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350bK74W1j6j/etoodmlgMY4hwEOB599KYyw+0fEjbGAAaXiONOHFfop9MJUYTe3lHtONcsh5ug==
X-Received: by 2002:a7b:ce88:0:b0:3f0:3a5a:362e with SMTP id q8-20020a7bce88000000b003f03a5a362emr10037657wmj.39.1680523354652;
        Mon, 03 Apr 2023 05:02:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:5e00:8e78:71f3:6243:77f0? (p200300cbc7025e008e7871f3624377f0.dip0.t-ipconnect.de. [2003:cb:c702:5e00:8e78:71f3:6243:77f0])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c468d00b003ef7058ea02sm19072053wmo.29.2023.04.03.05.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 05:02:33 -0700 (PDT)
Message-ID: <aab81ed0-9c1e-a10d-63a5-5172c3f91d38@redhat.com>
Date:   Mon, 3 Apr 2023 14:02:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2] mm: Take a page reference when removing device
 exclusive entries
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        nouveau@lists.freedesktop.org,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
References: <20230330012519.804116-1-apopple@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230330012519.804116-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.03.23 03:25, Alistair Popple wrote:
> Device exclusive page table entries are used to prevent CPU access to
> a page whilst it is being accessed from a device. Typically this is
> used to implement atomic operations when the underlying bus does not
> support atomic access. When a CPU thread encounters a device exclusive
> entry it locks the page and restores the original entry after calling
> mmu notifiers to signal drivers that exclusive access is no longer
> available.
> 
> The device exclusive entry holds a reference to the page making it
> safe to access the struct page whilst the entry is present. However
> the fault handling code does not hold the PTL when taking the page
> lock. This means if there are multiple threads faulting concurrently
> on the device exclusive entry one will remove the entry whilst others
> will wait on the page lock without holding a reference.
> 
> This can lead to threads locking or waiting on a folio with a zero
> refcount. Whilst mmap_lock prevents the pages getting freed via
> munmap() they may still be freed by a migration. This leads to
> warnings such as PAGE_FLAGS_CHECK_AT_FREE due to the page being locked
> when the refcount drops to zero.
> 
> Fix this by trying to take a reference on the folio before locking
> it. The code already checks the PTE under the PTL and aborts if the
> entry is no longer there. It is also possible the folio has been
> unmapped, freed and re-allocated allowing a reference to be taken on
> an unrelated folio. This case is also detected by the PTE check and
> the folio is unlocked without further changes.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
> Cc: stable@vger.kernel.org

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

