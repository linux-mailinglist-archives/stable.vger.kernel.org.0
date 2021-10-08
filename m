Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A9D42735F
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 00:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhJHWEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 18:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhJHWEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 18:04:01 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426BCC061570;
        Fri,  8 Oct 2021 15:02:06 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o133so3015135pfg.7;
        Fri, 08 Oct 2021 15:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5UinZ74z2CsW0OaciEdEsvBP6wq+BAWiOp/zdaLjDiM=;
        b=liQt8Za2zk8164J/xmfMTRki1RHTOwJISamrwRbtBNv8DxGUkZm/Sz7RIKF5aVRWlf
         JMim/U0BghDW9EQoQBxCjqiKCZDq2SYeSKF5HDdZ3xvkvSHnCXv348SV6xwGxnQrCPRz
         XzD3dQdekbfIsVUnEdP5wUKuHc7AZU3LmpmLNysu2J6xo+mHQNDJm1TIACcu0YmuNoxx
         1OTDTH/qzGe5VivvK8567ITDkPGwYfsacT7M02gC4dLvN4vEOOt/yu9P4YIgCHUOPmU/
         ImzKaOlsw0lQx0v/GylQmJx/bIPWwaYGUu4Y9C97qBqYvMa8rkAwSxSXikpa9+a1TU7L
         VqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5UinZ74z2CsW0OaciEdEsvBP6wq+BAWiOp/zdaLjDiM=;
        b=zgIuOLI6CSqbxhqW/23EdPgjcrrDtrX/wW/ZxsseIvEFhgzWX0kLr4+WIBpF8OeSZQ
         F61Pi6CgoObm34ltTlLwHYEH3qlvo2YV9h3948/0d1vXB4II7A1j8XC5uPPpLDRI6Nlk
         ErtljY3BFrkliF0maeSXWzBczEdpY51tmZvHvcOyf1oXeCcV3wMEd55GfTHZotqSaElF
         ZZnsUmyvn2n1Miyin/B1UynrJ8SX+rYZBBv2jh8CYyDsJcV0LzhzaKIHtwqL6t02sRvm
         9piBcVFBcBUqTUhgJt8SyD6sK/vIUvJ65/Opr8ORP5kLmzal2PC7H7eqj8Nx2iiVYyI/
         BNhw==
X-Gm-Message-State: AOAM530vBCz/lOg4v01zjRjXlpDcPg23g6QsjfUie6m0jzt7R2WhmqE+
        bQxh5Ze2BYFySy0mLIA+pjQ=
X-Google-Smtp-Source: ABdhPJznF1BpKNROhYqKyONHuIKHafj4QGG+1F9uQjac/PqWA/pc7iYoVRFpvJ8ylIL2nx8DAK6BQQ==
X-Received: by 2002:a05:6a00:1307:b0:43d:2b4:419a with SMTP id j7-20020a056a00130700b0043d02b4419amr12492102pfu.62.1633730525508;
        Fri, 08 Oct 2021 15:02:05 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id q18sm280605pfj.46.2021.10.08.15.02.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Oct 2021 15:02:04 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH] mm/userfaultfd: provide unmasked address on page-fault
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <d5a244e9-a04e-8794-e55f-380db5e8c6c4@redhat.com>
Date:   Fri, 8 Oct 2021 15:02:02 -0700
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E2ADE3F0-74B1-4D1D-80AE-0BBC49D932E6@gmail.com>
References: <20211007235055.469587-1-namit@vmware.com>
 <d5a244e9-a04e-8794-e55f-380db5e8c6c4@redhat.com>
To:     David Hildenbrand <david@redhat.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Oct 8, 2021, at 1:05 AM, David Hildenbrand <david@redhat.com> =
wrote:
>=20
> On 08.10.21 01:50, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>> Userfaultfd is supposed to provide the full address (i.e., unmasked) =
of
>> the faulting access back to userspace. However, that is not the case =
for
>> quite some time.
>> Even running "userfaultfd_demo" from the userfaultfd man page =
provides
>> the wrong output (and contradicts the man page). Notice that
>> "UFFD_EVENT_PAGEFAULT event" shows the masked address.
>> 	Address returned by mmap() =3D 0x7fc5e30b3000
>> 	fault_handler_thread():
>> 	    poll() returns: nready =3D 1; POLLIN =3D 1; POLLERR =3D 0
>> 	    UFFD_EVENT_PAGEFAULT event: flags =3D 0; address =3D =
7fc5e30b3000
>> 		(uffdio_copy.copy returned 4096)
>> 	Read address 0x7fc5e30b300f in main(): A
>> 	Read address 0x7fc5e30b340f in main(): A
>> 	Read address 0x7fc5e30b380f in main(): A
>> 	Read address 0x7fc5e30b3c0f in main(): A
>> Add a new "real_address" field to vmf to hold the unmasked address. =
It
>> is possible to keep the unmasked address in the existing address =
field
>> (and mask whenever necessary) instead, but this is likely to cause
>> backporting problems of this patch.
>=20
> Can we be sure that no existing users will rely on this behavior that =
has been the case since end of 2016 IIRC, one year after UFFD was =
upstreamed?

Let me to blow off your mind: how do you be sure that the current =
behavior does not make applications to misbehave? It might cause =
performance issues as it did for me or hidden correctness issues.

> I do wonder what the official ABI nowadays is, because man pages =
aren't necessarily the source of truth.

Documentation/admin-guide/mm/userfaultfd.rst says: "You get the address =
of the access that triggered the missing page
event=E2=80=9D.

So it is a bug.



