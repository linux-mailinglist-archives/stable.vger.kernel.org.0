Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D104D2F4A59
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 12:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbhAMLhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 06:37:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728200AbhAMLhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 06:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610537771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQcSb6CyS4Rcj5w1L4KFo4VX77Uj3QkqX6PSofKeGPI=;
        b=FevGkXsNuJvSV0XZ71icVHZMER0FsTiOoaCgJ5v3jm157yIowC0VCGjNCCbos/NvOCqCie
        j82nrJhZ9i6KPqrzpxAUdNXjKYCFFSaP52Z8iwUtyQm5hGFZkdX+o4SkB8l9yj9JAGyx7W
        QGRBlaGs2HouzRr2AQbqHUT5qz5RD/I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-fA4gJJ6_OM-Y3X7-LX6prw-1; Wed, 13 Jan 2021 06:36:10 -0500
X-MC-Unique: fA4gJJ6_OM-Y3X7-LX6prw-1
Received: by mail-wm1-f69.google.com with SMTP id x20so706486wmc.0
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 03:36:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pQcSb6CyS4Rcj5w1L4KFo4VX77Uj3QkqX6PSofKeGPI=;
        b=WRwaV5s69Gw/UK3SZtrtgdKjacN7Fw4+y7cgLhnsXK7NqeJt60Hii1r7gRdh5KkWj7
         Yf/obx+alT9SrNgK8/lLo/TPM3MQ2WdruFMvDEYFtdBx93Hj+WrYM6J1Jr1B5Afl0j3n
         vKDQ7ODLXU2gseJPV3FSD54pTTMF2kt6NXkTC4uLtL0gsF/bb2xppN5kbvjPc6kyE3UF
         yrn6SyEw65+Qm035Nc9Cx2gi5WTHDRQRAbT+zCkOV59LZuDUQBIZ4/8ERkWL8BSSkeJn
         CjNBI7ao39Ug7yFZzznxWnVYZ7quTVXAQPGJTsV6gMDTw452iqtN4mtb1EstQAeMm9/e
         HIBg==
X-Gm-Message-State: AOAM532MlR1USsjRZFkLk3IlYzO9Nueq2oXZ/6IQ3In7JUY1U5goq2XJ
        4Cq7BgDXzyshA1qNpO83vyJZdsaBPRbOh3aR+iAAxshQOnmHmYr9Sx3bxUefjOc20J6zqW7bE4d
        254HSEfSP/xpECPXu
X-Received: by 2002:a1c:a5d4:: with SMTP id o203mr1795408wme.41.1610537768794;
        Wed, 13 Jan 2021 03:36:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxS14vUOEEQ/bzWnoAQ2ltyWpCLjwA+Z3r9kH8HEWajdFCUX904JSU013CXi5oc1xfSAEvgHA==
X-Received: by 2002:a1c:a5d4:: with SMTP id o203mr1795384wme.41.1610537768581;
        Wed, 13 Jan 2021 03:36:08 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r20sm2460567wmh.15.2021.01.13.03.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 03:36:08 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A504C18032B; Wed, 13 Jan 2021 12:36:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
In-Reply-To: <2648795.1610536273@warthog.procyon.org.uk>
References: <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 13 Jan 2021 12:36:07 +0100
Message-ID: <875z419ihk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> I'm intending to use Tianjia's patch.

Yeah, sorry for missing that.

> Would you like to add a Reviewed-by?

Sure:

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

and also, if you like:

Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

