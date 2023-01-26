Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B6567C7A1
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 10:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbjAZJle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 04:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbjAZJld (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 04:41:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138EE5D111
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 01:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674726038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TEFHkr2xQ4K7KcAY2fcUqBctXL+9rGNmdq1/w/z4OjM=;
        b=JZKmwCzGCp5kiRbwaCHKViMKzW+vkMTWjxMgsPdCy57Djv6HHS6gq46EyUh++OhJ9iAagk
        hNW8ojDubg2eWNbsHbnAVAiStdjwTeY4hv+2E0dyxc40/xFLQs/872OEza6SFytZEL4d9H
        5QZJS9nbPUsgHijNNrqQ113WiWUPVUM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-Tq4imXqhNs2_snmP9yuGAw-1; Thu, 26 Jan 2023 04:40:37 -0500
X-MC-Unique: Tq4imXqhNs2_snmP9yuGAw-1
Received: by mail-ej1-f71.google.com with SMTP id sa8-20020a170906eda800b0087875c99e6bso159075ejb.22
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 01:40:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TEFHkr2xQ4K7KcAY2fcUqBctXL+9rGNmdq1/w/z4OjM=;
        b=8GI7mzHrV7ovOhYJPrsJHDTq9oG9WE4TpR7qyZ3Xg+4jCCf+fg38K+YwDpjeZ5lMjv
         mySqH8N9YFmYTOJZuIMKCYx4KwTRCjkJizLLbUzPAQOGQHq3kvDux16+kf355w0sV8rC
         MwV7swlRpjIy0XavpVVoGiY0rgIo+oFDAbrtjLxIXFk8CyIgFOoj/1kolAI1/GlUwLc+
         fkkD7WZLnbxMTFpat7rSSlvhS60C3AuWSEHTyQfTlMPKv6ZPjzNvZa+7yUHGkTUOUYie
         bG6rzQB4MEAuUTLNI2vXiJSbmIGf5wouBxaTsC5eYvdnzoYU7JZfg9EgHRvEZTajixAP
         R1MQ==
X-Gm-Message-State: AFqh2kqDDnA7TMmL4GpiOsxsDNak/DUU9+Jno9Nt2erFyOTaiBHic3xP
        7Z55zcoQ2jvmnfrGnDQX2nco5Ph/aFze1Ve0XfjdH6QeAClMAW6Xthb3iBISGZBrCMJG6yS9GTO
        SciKbzei00btbi2qB
X-Received: by 2002:a17:906:f753:b0:7c4:edee:28c0 with SMTP id jp19-20020a170906f75300b007c4edee28c0mr37578002ejb.24.1674726035842;
        Thu, 26 Jan 2023 01:40:35 -0800 (PST)
X-Google-Smtp-Source: AMrXdXssEfL+91YyHiRwdbLyA1oe2zf6Xks/zHaCxQMtbtruIphMufnJlKVikX6QuBZy0ymdCwMaqw==
X-Received: by 2002:a17:906:f753:b0:7c4:edee:28c0 with SMTP id jp19-20020a170906f75300b007c4edee28c0mr37577990ejb.24.1674726035580;
        Thu, 26 Jan 2023 01:40:35 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id z16-20020a170906435000b007b935641971sm339874ejm.5.2023.01.26.01.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 01:40:35 -0800 (PST)
Message-ID: <f322cce0-f83a-16d9-9738-f47f265b41d8@redhat.com>
Date:   Thu, 26 Jan 2023 10:40:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] KVM: x86: Do not return host topology information from
 KVM_GET_SUPPORTED_CPUID
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
References: <20221027092036.2698180-1-pbonzini@redhat.com>
 <CALMp9eQihPhjpoodw6ojgVh_KtvPqQ9qJ3wKWZQyVtArpGkfHA@mail.gmail.com>
 <3a23db58-3ae1-7457-ed09-bc2e3f6e8dc9@redhat.com>
 <CALMp9eQ3wZ4dkq_8ErcUdQAs2F96Gvr-g=7-iBteJeuN5aX00A@mail.gmail.com>
 <8bdf22c8-9ef1-e526-df36-9073a150669d@redhat.com>
 <CALMp9eRKp_4j_Q0j1HYP2itT2+z3pRotQK8LwScMsaGF5FpARA@mail.gmail.com>
 <dec8c012-885a-6ed8-534e-4a5f0a435025@redhat.com>
 <CALMp9eSyVWGS2HQVwwwViE6S_uweiOiFucqa3keuoUjNz9rKqA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eSyVWGS2HQVwwwViE6S_uweiOiFucqa3keuoUjNz9rKqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/23 01:58, Jim Mattson wrote:
>> You wrote it yourself: any VMM must either populate the topology on its
>> own, or possibly fill it with zeros.  Returning a value that is
>> extremely unlikely to be used is worse in pretty much every way (apart
>> from not breaking your VMM, of course).
> 
> I've complained about this particular ioctl more than I can remember.
> This is just one of its many problems.

I agree.  At the very least it should have been a VM ioctl.

>> With a total of six known users (QEMU, crosvm, kvmtool, firecracker,
>> rust-vmm, and the Google VMM), KVM is damned if it reverts the patch and
>> damned if it doesn't.  There is a tension between fixing the one VMM
>> that was using KVM_GET_SUPPORTED_CPUID correctly and now breaks loudly,
>> and fixing 3-4 that were silently broken and are now fixed.  I will
>> probably send a patch to crosvm, though.
>>
>> The VMM being _proprietary_ doesn't really matter, however it does
>> matter to me that it is not _public_: it is only used within Google, and
>> the breakage is neither hard to fix in the VMM nor hard to temporarily
>> avoid by reverting the patch in the Google kernel.
> 
> Sadly, there isn't a single kernel involved. People running our VMM on
> their desktops are going to be impacted as soon as this patch hits
> that distro. (I don't know if I can say which distro that is.) So, now
> we have to get the VMM folks to urgently accommodate this change and
> get a new distribution out.

Ok, this is what is needed to make a more informed choice.  To be clear, 
this is _still_ not public (for example it's not ChromeOS), so there is 
at least some control on what version of the VMM they use?  Would it 
make sense to buy you a few months by deferring this patch to Linux 6.3-6.5?

Thanks,

Paolo

