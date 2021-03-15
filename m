Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B018C33B066
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 11:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCOKxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 06:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229673AbhCOKw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 06:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615805576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LK2mxkow7e8brVvXEdY4+jZpUz8M80ZpwI/loM8Aq14=;
        b=Hge9OH3UCfbXi8dRnUK+ZbtH3kfJ0w2Gfh0aDB1RGguIEo29/QGHXAtMS7g/6hIJgAAFfY
        4G2xx0o8oklIxGdvVVxFnYiay1cWhIkRoNKCDYXPi15vchYo50HUalh6DnvxtD/oNttVLE
        RHYkVFbtj0OZejt7kZgApFsqlt09EoM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-2wKRHwT-Md6bC1YL508QnQ-1; Mon, 15 Mar 2021 06:52:54 -0400
X-MC-Unique: 2wKRHwT-Md6bC1YL508QnQ-1
Received: by mail-ed1-f69.google.com with SMTP id r19so15328991edv.3
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 03:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LK2mxkow7e8brVvXEdY4+jZpUz8M80ZpwI/loM8Aq14=;
        b=UK+6XgMHrE1hrhkBeWg3Tr3IKR7uDx9pSadQPgrfrNwP6PhpSwo/K3jNRbn40eCx5q
         tF9O8pwuxx56NLpSnWwyHYfjTey+2hvBt1HbiWunMCpQScOBvpJKPVV52BRyMPBoFDYg
         6yq83lU+m5M7osNEEOKFaJ3VVsNNCJtuNEvP/FjqB3m7u7DmqkyKYmVBEP76ozCmp3gj
         VtAzM2boRd/xrkRTsimkHkVYp3Zh1wDpNWvCj9fuA8YCojiAqUVwebHvLCY9ovSAkmrp
         MBI6LMcgINuEFiGZKgkpAtuiQHu6a+9kygbRkHxYCtfkCYK5uZCQHsFIk0kevr++BfQ+
         0w/w==
X-Gm-Message-State: AOAM533+bzLH7ZZVhOzV7E40VFcQ7eenyWaSueW7KxIgfPN90IBsIZ3w
        9LTKOvNTFMJ2sFISv0y8Zp/xKKGLTUdMlnPzLrdujC9F+Ibc73t/sLMZsDZPah5fXwuGU7e8pwG
        V8u4mS+QaHDAi+07C
X-Received: by 2002:aa7:df84:: with SMTP id b4mr28919057edy.240.1615805573751;
        Mon, 15 Mar 2021 03:52:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwx9wCpiGKad6zkmoQf20XvPw/JdC59hTlwQbulqEsV40iMgbgWHPodUkiEnuXQgGqtdDrTYA==
X-Received: by 2002:aa7:df84:: with SMTP id b4mr28919049edy.240.1615805573623;
        Mon, 15 Mar 2021 03:52:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id lk12sm7058344ejb.14.2021.03.15.03.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 03:52:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 76BD418027E; Mon, 15 Mar 2021 11:52:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
In-Reply-To: <YEi1RgPgwfT7qHQM@kroah.com>
References: <875z419ihk.fsf@toke.dk> <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
 <2656681.1610542679@warthog.procyon.org.uk> <87sg6yqich.fsf@toke.dk>
 <YEi1RgPgwfT7qHQM@kroah.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 15 Mar 2021 11:52:52 +0100
Message-ID: <87czw0pu2j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Mon, Jan 18, 2021 at 06:13:02PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> David Howells <dhowells@redhat.com> writes:
>>=20
>> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> >
>> >> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>=20
>> >> and also, if you like:
>> >>=20
>> >> Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >
>> > Thanks!
>>=20
>> Any chance of that patch getting into -stable anytime soon? Would be
>> nice to have working WiFi without having to compile my own kernels ;)
>
> What ever happened to this patch?  I can't seem to find it in Linus's
> tree anywhere :(

This was a matter of crossed streams: Tianjia had already submitted an
identical fix, which went in as:

7178a107f5ea ("X.509: Fix crash caused by NULL pointer")

And that has made it into -stable, so all is well as far as I'm
concerned. Sorry for the confusion!

-Toke

