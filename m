Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3E76C08C2
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjCTB7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjCTB73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:59:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEFE7280
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 18:59:27 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id cy23so40963956edb.12
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 18:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679277566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veHR4OeBVdmMM7ZoMMD2LEaF+ZQb01kUcsthEQZ+G8o=;
        b=g+IZewMqUt+Hpe5Pp7LrKkaiAN+gq51UHhDpEfWJHkxSX3xa2jdTBzH/3UmmEXe7LM
         1FIuiqeAg3dUOlYWoQJK5V1roNftLrfSGzWoDfa9l7KiiRPzCURyS/ysOjL58wxzGE8Z
         Crvh3daZoDU79JxqQCL4fWSpbGxV2WWJJMJZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679277566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=veHR4OeBVdmMM7ZoMMD2LEaF+ZQb01kUcsthEQZ+G8o=;
        b=z/OcBStDNToNGvRnd0V0t8Xn5uHyBKLv0Ba4XNgDFDnZ5GzQZYhR3yW+BXOLVNxLyF
         oAZmhE3BP7ObGsTHpr9eIEss8EtEosDjE+95Ybid5UY/o7wgHWLx2rVGhjVtguK6eoUX
         W9Aan4jjWFunXBebEok3x838Y5ilxsB/B1qzN5hX6kIRVa2IgrFOHSmb+aeADIUlxttc
         3mN5rG2vbn1nD8IDqipZLDZzs27mYf0h78gI1pkm8R/DYvdgbc3hTf8sRTAL0lbRR+XH
         8dcuovmdmvEpYKQkfM8RoADE5ezLwTLBCgxjM5u76IJwDz5j9T2SD/eXXtZjAykAxU4W
         UtfA==
X-Gm-Message-State: AO0yUKWB1U/lONaEjZo/I8Q7hkohlkHA3eFCLgtA5rcKH2oP4M6PY3aG
        CrBPHze7NUSKkNytxsdAN+B6Xsn9GXimrA5KUrYeKQ==
X-Google-Smtp-Source: AK7set/6BtYAnevSxX43e03UXCk2H3P6o+iKytyNMpWK91+2at8HJbZ4zOiFv/sl6cRwuk29FJrMFw==
X-Received: by 2002:a17:907:6e29:b0:934:8043:ebf8 with SMTP id sd41-20020a1709076e2900b009348043ebf8mr2644706ejc.26.1679277565817;
        Sun, 19 Mar 2023 18:59:25 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id e8-20020a170906c00800b008e1509dde19sm3739898ejz.205.2023.03.19.18.59.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 18:59:24 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id t5so4242290edd.7
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 18:59:24 -0700 (PDT)
X-Received: by 2002:a17:906:2294:b0:927:912:6baf with SMTP id
 p20-20020a170906229400b0092709126bafmr2817236eja.15.1679277564111; Sun, 19
 Mar 2023 18:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230320005258.1428043-1-sashal@kernel.org> <20230320005258.1428043-9-sashal@kernel.org>
In-Reply-To: <20230320005258.1428043-9-sashal@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 19 Mar 2023 18:59:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgpK-Gm-nOybRKs1LTD5yb7rPHQ4+=PCDvq61mUpBskYw@mail.gmail.com>
Message-ID: <CAHk-=wgpK-Gm-nOybRKs1LTD5yb7rPHQ4+=PCDvq61mUpBskYw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.2 09/30] cpumask: fix incorrect cpumask scanning
 result checks
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vernon Yang <vernon2gm@gmail.com>,
        Yury Norov <yury.norov@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, mpe@ellerman.id.au,
        tytso@mit.edu, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, christophe.leroy@csgroup.eu,
        npiggin@gmail.com, dmitry.osipenko@collabora.com, joel@jms.id.au,
        nathanl@linux.ibm.com, gustavoars@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 19, 2023 at 5:53=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> [ Upstream commit 8ca09d5fa3549d142c2080a72a4c70ce389163cd ]

These are technically real fixes, but they are really just "documented
behavior" fixes, and don't actually matter unless you also have
596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations"), which doesn't look like stable material.

And if somebody *does* decide to backport commit 596ff4a09b89, you
should then backport all of

  6015b1aca1a2 sched_getaffinity: don't assume 'cpumask_size()' is
fully initialized
  e7304080e0e5 cpumask: relax sanity checking constraints
  63355b9884b3 cpumask: be more careful with 'cpumask_setall()'
  8ca09d5fa354 cpumask: fix incorrect cpumask scanning result checks

but again, none of these matter as long as the constant-sized cpumask
optimized case doesn't exist.

(Technically, FORCE_NR_CPUS also does the constant-size optimizations
even before, but that will complain loudly if that constant size then
doesn't match nr_cpu_ids, so ..).

                   Linus
