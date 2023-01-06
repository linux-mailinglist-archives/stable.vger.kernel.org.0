Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E4660579
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 18:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbjAFRRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 12:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbjAFRQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 12:16:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A62E7D1E4;
        Fri,  6 Jan 2023 09:16:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D24B6616F5;
        Fri,  6 Jan 2023 17:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F67C433D2;
        Fri,  6 Jan 2023 17:16:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gjort3rq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1673025394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=13qVFvzj+JoRi8+CvI6HYB6uSTn1bytbuVR6Q3H6GEE=;
        b=gjort3rqIxDFFSGMUL9g9t+pqxS2//Zx7rkx+zku1tA6P4s8RntIG8YRn7KXe7ivEpzJHn
        zoh2J5sHguhfXCw8ss9r6PyzWE60yUD6tpziYgDl1BDFZY1QAR7MrDP8p67ltchwloJp/N
        wP+bU8MM3voRLDUdQfONxFQRlCCWWfs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7be4b881 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 6 Jan 2023 17:16:33 +0000 (UTC)
Received: by mail-ed1-f43.google.com with SMTP id c34so3163163edf.0;
        Fri, 06 Jan 2023 09:16:33 -0800 (PST)
X-Gm-Message-State: AFqh2kpkWdw3IX0G1uTlagvLAoZrmwujK9888TurxozTUPmu2xZiVnq7
        Ve3AqgkJpp/CfXPUUohcegpBUXbfhXP3SGfJZiw=
X-Google-Smtp-Source: AMrXdXsOo0zAqxZ998Wih8ahYgW4gf0ivgvhe+bP0n7y8cElI+fRQWdIBw3TWxXjrERiCHQLHXqTwXOD50gJpMIQKx8=
X-Received: by 2002:aa7:cb13:0:b0:48e:ae51:464d with SMTP id
 s19-20020aa7cb13000000b0048eae51464dmr1649004edt.341.1673025391232; Fri, 06
 Jan 2023 09:16:31 -0800 (PST)
MIME-Version: 1.0
References: <Y7dPV5BK6jk1KvX+@zx2c4.com> <20230106030156.3258307-1-Jason@zx2c4.com>
 <Y7hF5vG8rWjbCLyL@zx2c4.com> <CAA25o9RGVbiXS6ne53gdM1K706zT=hm5c-KuMWrCA_CJtJDXdw@mail.gmail.com>
In-Reply-To: <CAA25o9RGVbiXS6ne53gdM1K706zT=hm5c-KuMWrCA_CJtJDXdw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 6 Jan 2023 18:16:19 +0100
X-Gmail-Original-Message-ID: <CAHmME9pwUZ+rOLEB=zLTUObAv0At=_n5vs=xQfB=Kw_hwA03Tg@mail.gmail.com>
Message-ID: <CAHmME9pwUZ+rOLEB=zLTUObAv0At=_n5vs=xQfB=Kw_hwA03Tg@mail.gmail.com>
Subject: Re: [PATCH v2] tpm: Allow system suspend to continue when TPM suspend fails
To:     Luigi Semenzato <semenzato@chromium.org>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, tbroch@chromium.org,
        dbasehore@chromium.org, keescook@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 6, 2023 at 6:04 PM Luigi Semenzato <semenzato@chromium.org> wro=
te:
>
> I worked a fair amount on TPM 1.0 about 10 years ago and I even vaguely r=
emember suspend-related problems.  I'd be happy to take a look.  The linked=
 thread shows that Peter Huewe was copied.  I know Peter well, his opinion =
can be trusted.  Unfortunately I don't immediately see a link to a patch, c=
an you help?

Sorry, I should have included that:
https://lore.kernel.org/lkml/20230106030156.3258307-1-Jason@zx2c4.com/
Instead of blocking system suspend when TPM_ORD_SAVESTATE fails, it
just lets the system sleep anyway. This means that presumably the
system might sleep without having called TPM_ORD_SAVESTATE. Trying to
figure out how bad that is.

And yes, Peter Huewe certainly knows about TPMs, especially as he
maintains the code in Linux, but the maintainers haven't been so much
available, unfortunately. This bug happens to intersect with something
mostly related that I work on (the rng), so I'm motivated to at least
prevent the worst of the breakage, but I otherwise don't know anything
about the Linux TPM driver.

Jason
