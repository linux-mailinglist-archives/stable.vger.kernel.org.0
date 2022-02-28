Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EB94C780E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240829AbiB1Sk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240851AbiB1SkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:40:17 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6397EB1AAB
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 10:31:59 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id x193so14100797oix.0
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 10:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dI59wPXipr10daedy0IHllFTQmAqt3lJLYrEcIBjKpo=;
        b=JT3wkYgUMQTt4ly66ev/doKnoEVdvzi8mZR2eCb0rXyoRB7Zi70E0L1BN7Vzi9nEQe
         xXfyNnLpz/JkVBRHN/1ccTCGQI32esDU0OQAjb+RxNIo3++MvG3icsvDONHhQxrGQPQ4
         WUFYV2pRbTYA4nk0bw5vLl6n81lbyqYVaXaIn1vEoLd/+1BG0JB92zUTYG/Llvr9HiTr
         hRVIb0CQVW8kMZKfAEGmfPQukfSxHT77GVRpkSGPyOijpAcqAjP4ptWe8Sw5CSIT1JXL
         t9oZyFA89i7VnfwB/m+p9WisAnswQ67RX2jbJvESOMJEI16HlBuPQpqUWbOHB3HJNkYM
         t+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dI59wPXipr10daedy0IHllFTQmAqt3lJLYrEcIBjKpo=;
        b=DL0MAoCpTZsLqH06Pc9OOJBpc8lPodPYlWxgMBP9Zac4062m0KIbKd10cgnK2jmOh4
         17esybBXTKodti62AUb6mhegW4ydiIVEmyYYurM6ci8TlFZqaxplRFJBw4fgOD1w7nX0
         KjrvB7W2apwSIrd8MQKcH5H81zay4KE4BTKYDLpOT1nuDAeK6Eg1zK/9eM38URGOkG7H
         tOD8burrZvZciQv+hZPFJmm6mYSEqM0TF7y3xJGMHAbKF6QgnZ050/893wNikXnMqfrT
         J4d9neRglxxQMfx2bARV21rUA9LpfLCyTv7PMJ9LsS/5EVzlgyH5dAzwogJstXqU844G
         89Iw==
X-Gm-Message-State: AOAM531KhocjCizxtUOpiFfejw8zcRTrws/Q9+s/CF0k0KcUU0TJi52e
        iC8a7Z9Na+EM3SvE9mzkCr4d/mN5t7E=
X-Google-Smtp-Source: ABdhPJwuVDRaaC5EBG/aD/6CYtG2mWLNXB376mcWD0QG44tPY1d543wq5ab9R4JYzJXWwTgGiBfg8w==
X-Received: by 2002:a05:6808:118d:b0:2cc:ef90:3812 with SMTP id j13-20020a056808118d00b002ccef903812mr11822029oil.48.1646073118607;
        Mon, 28 Feb 2022 10:31:58 -0800 (PST)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id s3-20020a056808208300b002d38ef031d6sm6583639oiw.36.2022.02.28.10.31.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Feb 2022 10:31:57 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <YhMv8xAH4+bzSpo2@xz-m1.local>
Date:   Mon, 28 Feb 2022 10:31:56 -0800
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <54D15136-CC60-421F-AB58-4C44D338787E@gmail.com>
References: <20220217211602.2769-1-namit@vmware.com>
 <Yg79WMuYLS1sxASL@xz-m1.local>
 <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
 <68B04C0D-F8CE-4C95-9032-CF703436DC99@gmail.com>
 <YhMv8xAH4+bzSpo2@xz-m1.local>
To:     Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Feb 20, 2022, at 10:23 PM, Peter Xu <peterx@redhat.com> wrote:
>=20
> On Thu, Feb 17, 2022 at 08:00:12PM -0800, Nadav Amit wrote:
>>=20
>>> On Feb 17, 2022, at 6:23 PM, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>=20
>>>> PS: I always think here the VM_SOFTDIRTY check is wrong, IMHO it =
should be:
>>>>=20
>>>>      if (dirty_accountable && pte_dirty(ptent) &&
>>>>                      (pte_soft_dirty(ptent) ||
>>>>                      (vma->vm_flags & VM_SOFTDIRTY))) {
>>>>              ptent =3D pte_mkwrite(ptent);
>>>>      }
>>=20
>> I know it is off-topic (not directly related to my patch), but
>> I tried to understand the logic - both of the existing code and of
>> your suggested change - and I failed.
>>=20
>> IIUC dirty_accountable (whose value is taken from
>> vma_wants_writenotify()) means that the writes *should* be tracked,
>> and therefore the page should remain read-only.
>=20
> Right.
>=20
>>=20
>> So basically the condition should have been based on
>> !dirty_accountable, i.e. the inverted value of dirty_accountable.
>>=20
>> The problem is that dirty_accountable also reflects VM_SOFTDIRTY
>> considerations, so looking on the PTE does not tell you whether
>> the PTE should remain write-protected even if it is dirty.
>=20
> My understanding is that the dirty bits (especially if both set) means
> we've tracked dirty on this pte already so we don't need to, hence we =
can
> set the dirty bit here.  E.g., continuous mprotect(RO), mprotect(RW) =
upon a
> full dirty pte.
>=20
> When something wants to enable tracking again, it needs to clear the =
dirty
> bit, either the real one or soft-dirty one.  So it's a pure =
performance
> enhancement to conditionally set write bit here, when we're sure we =
won't
> need any further tracking on this pte.
>=20
> One thing to mention is that this path only applies to =
VM_SHARED|VM_WRITE,
> because that's what checked the first in vma_wants_writenotify():
>=20
> 	/* If it was private or non-writable, the write bit is already =
clear */
> 	if ((vm_flags & (VM_WRITE|VM_SHARED)) !=3D =
((VM_WRITE|VM_SHARED)))
> 		return 0;
>=20
> IOW private mappings are not optimized in current tree yet.
>=20
> Peter Collingbourne proposed a patch some time ago to optimize it but =
it
> didn't get merged somehow.  Meanwhile even with his latest version it
> should still miss the thp case, so if to reference the private =
optimization
> Andrea's tree would be the best:
>=20
> =
https://github.com/aagit/aa/commit/fadb5e04d94472614c76819acd979b2f60e4eff=
6
>=20
> Hope it clarifies things a bit.  Thanks,

Thanks for the clarification. That=E2=80=99s what I suspected - I did =
not encounter
it since I only used private anonymous mappings. I will try to create a
test-case and send an additional fix for this issue.

Regards,
Nadav=
