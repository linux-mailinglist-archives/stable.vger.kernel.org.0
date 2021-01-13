Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E852F4A45
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 12:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbhAMLaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 06:30:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbhAMLaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 06:30:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610537366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RBvUo/6vjpBKP0pLeQRwuVWC4Mf8TIQXAT6GH3pLh/A=;
        b=Oa5dnnd7Kq7MCfMY8Nv0Vg/1QPTSNSQDSjfDoUq/UM6NlZ04lP4monn+nAAgGTH5dJDLx/
        A0Z8xxXjvT+OJgzS6fcTCCWx+l+iKbSaikZEMsLumU+1zB4loZAtSj/9P9AMVCiavcuHPC
        GwNXKbyoDcUDoeqmjILbp6JDmVR/x7U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-5PtSeLeVOX-GLUYlHRafCw-1; Wed, 13 Jan 2021 06:29:23 -0500
X-MC-Unique: 5PtSeLeVOX-GLUYlHRafCw-1
Received: by mail-ed1-f70.google.com with SMTP id f21so414109edx.23
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 03:29:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RBvUo/6vjpBKP0pLeQRwuVWC4Mf8TIQXAT6GH3pLh/A=;
        b=qmUA549R+rbPZ5gsFNp+duSS2dpTQL8m8j4D1XgajlBjS/v2Ulp3Sq3JS2wEyM7tqQ
         5SKJNYnavivQR2Wg9MTRTakvxAS6Mg28WAhUZ90KCUL9VlAam0aInXpX4cXu7EZh83Iv
         MdBKL8nws5EOLLbniD2Al0JgWMKAv8glDxMbxghOm0iZ/2DQ6/1B8baA7aKopIzENBbJ
         xZh/36tHAnWTd+/bWe1pcYap+lGJy7f6L9wtkO0sqRigSZu4rhMW/jwEigwU8mucrzKP
         kTDRgmZlwbPF+WaU9dOrjZ36XiRhyLmiY9jwHBuXnMGVQrCfmFkTrmk57PqW8+prb3Gg
         p1zg==
X-Gm-Message-State: AOAM530OdJt5EtsoP7GSIjMbeDazDr9QoNGSGZCO2Zna6We/QIku83M5
        qSawoxwDSZygLk+LB2+iBnCA/VWUdoM4IXF99PZ77q1P1cZ0Vzz5aScYInW4cnL3VuhX2m5m/2r
        EonPcSBrVhRcpTd6Z
X-Received: by 2002:a17:906:c10e:: with SMTP id do14mr1293939ejc.166.1610537362769;
        Wed, 13 Jan 2021 03:29:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwV0UhPTkqnfz0zhus4V2pdERz5D9Xe87p960xLKFrM1TiE4FX3YbkCxBmnvrwbXxFrSOjddA==
X-Received: by 2002:a17:906:c10e:: with SMTP id do14mr1293933ejc.166.1610537362623;
        Wed, 13 Jan 2021 03:29:22 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y22sm588794ejj.111.2021.01.13.03.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 03:29:22 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ACE1618032B; Wed, 13 Jan 2021 12:29:20 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
In-Reply-To: <d7a50628-5559-a054-bc47-2d45746eb503@linux.alibaba.com>
References: <20210112161044.3101-1-toke@redhat.com>
 <d7a50628-5559-a054-bc47-2d45746eb503@linux.alibaba.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 13 Jan 2021 12:29:20 +0100
Message-ID: <878s8x9isv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:

> Hi,
>
> I have fixed this problem last week. Still thanks for your fixing.
> patch is here: https://lkml.org/lkml/2021/1/7/201

Ah, awesome! I did look if this had already been fixed, but your patch
wasn't in the crypto tree and didn't think to go perusing the mailing
lists. So sorry for the duplicate, and thanks for fixing this :)

-Toke

