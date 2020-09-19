Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E13270C28
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 11:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgISJSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 05:18:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726192AbgISJSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Sep 2020 05:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600507119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lfetqzo7kRPYXW7uWXLArRB8xjwWDZKQ4lA60FHitpQ=;
        b=dqyNSFSCLpCSdTjYGHFltmfWpp3RuS9F29helxE0/HzAk9SZ4PCatxIOlgO1twv8thYAVA
        Vv2EgEMqrEL0O+PWtv18V8sa4SRIiNePR5KEEdgTqBtiyrNkVKzyBdB11OH+ytODGYrIkI
        YWbbkTYCp179KSSdZdqOWJnQUNa3xPQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-AhdzIlUmO1e7TAKsLd7wUQ-1; Sat, 19 Sep 2020 05:18:36 -0400
X-MC-Unique: AhdzIlUmO1e7TAKsLd7wUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F5801891E81;
        Sat, 19 Sep 2020 09:18:34 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-63.ams2.redhat.com [10.36.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D5DD55771;
        Sat, 19 Sep 2020 09:18:31 +0000 (UTC)
Subject: Re: [PATCH] KVM: MIPS: Change the definition of kvm type
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
References: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
 <45a71ce2-42d2-ba49-72a3-155dacede289@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <dc709e46-1daf-98f2-8eb1-436096bb3274@redhat.com>
Date:   Sat, 19 Sep 2020 11:18:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <45a71ce2-42d2-ba49-72a3-155dacede289@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/09/2020 19.22, Paolo Bonzini wrote:
> On 10/09/20 12:33, Huacai Chen wrote:
>> MIPS defines two kvm types:
>>
>>  #define KVM_VM_MIPS_TE          0
>>  #define KVM_VM_MIPS_VZ          1
>>
>> In Documentation/virt/kvm/api.rst it is said that "You probably want to
>> use 0 as machine type", which implies that type 0 be the "automatic" or
>> "default" type. And, in user-space libvirt use the null-machine (with
>> type 0) to detect the kvm capability, which returns "KVM not supported"
>> on a VZ platform.
>>
>> I try to fix it in QEMU but it is ugly:
>> https://lists.nongnu.org/archive/html/qemu-devel/2020-08/msg05629.html
>>
>> And Thomas Huth suggests me to change the definition of kvm type:
>> https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg03281.html
>>
>> So I define like this:
>>
>>  #define KVM_VM_MIPS_AUTO        0
>>  #define KVM_VM_MIPS_VZ          1
>>  #define KVM_VM_MIPS_TE          2
>>
>> Since VZ and TE cannot co-exists, using type 0 on a TE platform will
>> still return success (so old user-space tools have no problems on new
>> kernels); the advantage is that using type 0 on a VZ platform will not
>> return failure. So, the only problem is "new user-space tools use type
>> 2 on old kernels", but if we treat this as a kernel bug, we can backport
>> this patch to old stable kernels.
> 
> I'm a bit wary to do that.  However it's not an issue for QEMU since it
> generally updates the kernel headers.

Are there any other userspace programs beside QEMU that use KVM on MIPS?
If there aren't any other serious userspace programs, I think we should
go ahead with this patch here. Otherwise, what are the other programs
that could be affected?

 Thomas


