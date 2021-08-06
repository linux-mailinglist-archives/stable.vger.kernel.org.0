Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F014D3E2F13
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 19:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhHFR70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 13:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242362AbhHFR7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 13:59:24 -0400
Received: from forward100o.mail.yandex.net (forward100o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B8BC0613CF;
        Fri,  6 Aug 2021 10:59:08 -0700 (PDT)
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward100o.mail.yandex.net (Yandex) with ESMTP id D480D4AC0F92;
        Fri,  6 Aug 2021 20:59:04 +0300 (MSK)
Received: from vla5-fcb6daabdc9a.qloud-c.yandex.net (vla5-fcb6daabdc9a.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3521:0:640:fcb6:daab])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id CFAD461E0004;
        Fri,  6 Aug 2021 20:59:04 +0300 (MSK)
Received: from vla3-3dd1bd6927b2.qloud-c.yandex.net (vla3-3dd1bd6927b2.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:3dd1:bd69])
        by vla5-fcb6daabdc9a.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 5Fn8YsIFMO-x4IOoLFl;
        Fri, 06 Aug 2021 20:59:04 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1628272744;
        bh=iNYB87v7DkTman3KMBj2EDgZWOn1kNBsBPHwo+1qiW8=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=f+C2l3GO97s7IElFyONCCnng/KVvPKmpXhVFM5/Y2BWH4RZ4y9FP++J253b0nmze2
         ozLz9Me2N3YSTc4WncEmeHzP2DXIzUVIU/wcsWP1HYCbKiYQeTsY308hNr+8if0ve9
         xsN3M+nw8zQ6YLo0CClKh2TOZ3h49E7J1I1C41xM=
Authentication-Results: vla5-fcb6daabdc9a.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-3dd1bd6927b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id rHgEv1US1l-x430DPqQ;
        Fri, 06 Aug 2021 20:59:04 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v3] KVM: x86: accept userspace interrupt only if no event
 is injected
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
References: <20210727210916.1652841-1-pbonzini@redhat.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <2b157da6-39a5-4dbb-037f-7abf33a5e0b3@yandex.ru>
Date:   Fri, 6 Aug 2021 20:59:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210727210916.1652841-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

28.07.2021 00:09, Paolo Bonzini пишет:
> Once an exception has been injected, any side effects related to
> the exception (such as setting CR2 or DR6) have been taked place.
> Therefore, once KVM sets the VM-entry interruption information
> field or the AMD EVENTINJ field, the next VM-entry must deliver that
> exception.
>
> Pending interrupts are processed after injected exceptions, so
> in theory it would not be a problem to use KVM_INTERRUPT when
> an injected exception is present.  However, DOSEMU is using
> run->ready_for_interrupt_injection to detect interrupt windows
> and then using KVM_SET_SREGS/KVM_SET_REGS to inject the
> interrupt manually.  For this to work, the interrupt window
> must be delayed after the completion of the previous event
> injection.
>
> Cc: stable@vger.kernel.org
> Reported-by: Stas Sergeev <stsp2@yandex.ru>
> Tested-by: Stas Sergeev <stsp2@yandex.ru>
Acked-by: stsp2@yandex.ru
