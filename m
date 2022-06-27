Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B9D55C409
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbiF0MSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 08:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiF0MSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 08:18:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7437FBC2F
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 05:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656332323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QeTRmruqb8PXfYbpUfjyc9E5QDPm7vrxIbGT7xAqTVw=;
        b=P0d/WGh8veYb0mJuYHRqI2u6Bn8le5BlyH5W4gvIfQwLbv9vOfiO9QHyQZpqMfgXOdmgzs
        b0EBA42PFhgrnf6OZaW2Q5xyy4c2C0oiGn31wkrMLId/ipGC6Mbu8zl/ciLN+Isz1PgNhc
        +/TiUb3Grw0n0noFnvr5L9edfooVtNA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-NaRm6WF6NZuZaAFFayI8wg-1; Mon, 27 Jun 2022 08:18:42 -0400
X-MC-Unique: NaRm6WF6NZuZaAFFayI8wg-1
Received: by mail-ed1-f69.google.com with SMTP id g7-20020a056402424700b00435ac9c7a8bso7030646edb.14
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 05:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QeTRmruqb8PXfYbpUfjyc9E5QDPm7vrxIbGT7xAqTVw=;
        b=oQQnB1Io/CegFFbAIrguzrB6nqD1tvMJTFHejhaUYRswk9wc2XArPZAnSqI2Bb3ZMD
         WnSKbI/02lGycaYofzLO7SATxnFYdo5UXpdQVCs8YyB4TQy69KOutnFcz3JoiWtcu9V1
         Fc6+sEVtPiOGCF49HGnROZbUu5OCknL5wHGRNp/tlfisHiE6nLqF83uSUd0ptUsh7Wd9
         YUSjNgiiYICx5q3Qhn8hm/urS2On+0id5PZr8TkL3yuvgtoNwhljLckm+CaZvsXqyOgU
         wva8PBLTEz39Xe97k1VZz4r9KaDKjUMCwo1wDTULyRyiZPjpfCAPhXLFrAnsMihyDF5q
         HL1w==
X-Gm-Message-State: AJIora/KJbaoVeObJ1mwJR4PrDoJxJsPmcOfY0JQmoKMPUxpZp9F06om
        kjtpShizejU7ZAxZ6/4YjC0UynJEq/mxU7FIauRvJ7N3Hi6YzQE4YwR4WNXkO8jCU0KVprpJZGK
        9T5VJt9hhgrylYOGB
X-Received: by 2002:a05:6402:320f:b0:435:7236:e312 with SMTP id g15-20020a056402320f00b004357236e312mr16272776eda.115.1656332320679;
        Mon, 27 Jun 2022 05:18:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tkzyK4X8BkQekizGdw2RIZ8xukoWzY0sSwXgAYAPhEmTwq0WxbjiOjIOET+0jJY1iqXoU9eg==
X-Received: by 2002:a05:6402:320f:b0:435:7236:e312 with SMTP id g15-20020a056402320f00b004357236e312mr16272566eda.115.1656332318612;
        Mon, 27 Jun 2022 05:18:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b5-20020aa7cd05000000b0042bc5a536edsm7343465edw.28.2022.06.27.05.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 05:18:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BFDC7476CA0; Mon, 27 Jun 2022 14:18:36 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory Erwin <gregerwin256@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH v6] ath9k: sleep for less time when unregistering hwrng
In-Reply-To: <20220627120735.611821-1-Jason@zx2c4.com>
References: <20220627113749.564132-1-Jason@zx2c4.com>
 <20220627120735.611821-1-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Jun 2022 14:18:36 +0200
Message-ID: <87y1xib8pv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Even though hwrng provides a `wait` parameter, it doesn't work very well
> when waiting for a long time. There are numerous deadlocks that emerge
> related to shutdown. Work around this API limitation by waiting for a
> shorter amount of time and erroring more frequently. This commit also
> prevents hwrng from splatting messages to dmesg when there's a timeout
> and switches to using schedule_timeout_interruptible(), so that the
> kthread can be stopped.
>
> Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> Tested-by: Gregory Erwin <gregerwin256@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: stable@vger.kernel.org
> Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumpin=
g into random.c")
> Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsF=
GTEjs0c00giw@mail.gmail.com/
> Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8H=
ys_DVXtent3HA@mail.gmail.com/
> Link: https://bugs.archlinux.org/task/75138
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Gregory, care to take this version for a spin as well to double-check
that it still resolves the issue? :)

-Toke

