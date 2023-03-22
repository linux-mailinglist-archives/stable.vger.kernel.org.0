Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6A16C5887
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 22:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjCVVJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 17:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCVVJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 17:09:18 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C1321963
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 14:09:14 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ek18so78430353edb.6
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 14:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679519353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8BrsbGRfzEHZsIUH0GK10LbjiOfd8SiNUhlgvn39PY=;
        b=G0tlmsVkZ5MwB3Avdu2XDr48gVyqyglLke+1ijhAGs3+ryQ6XzNd8A3ItqruaCCMfH
         5c+8R8YkR/MaynvGsXQeo17JzW3dn2ELpAV12P4smBp3VXdGTsgM3VtmBkjtFVrHj9d0
         lzeSylWQtqfiZVn0ljQBAo2hAOTcV3O5Bc1Tk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679519353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k8BrsbGRfzEHZsIUH0GK10LbjiOfd8SiNUhlgvn39PY=;
        b=66qbGbLBKwkATCg1xxlcCvaLzKxVmSmUlYuEdi3Bnzhn0usfYNFQ/qvCSDft6cps+N
         GdSPcQs1Kab+eR/SRT8bbGbuzwAmm6BHQ7lAzlqD0QS3809cvCodvIBsIlL/j66c88Cy
         9H5GUHy6UIzFV6bLAMr1JujXPt0tfXdF+7387chcozRlAbvrDasa2bUalls0Q9TWAMfb
         l4c2fzT7IAoCqQPOE6Xt7/58NHf2/h7haM3g/4iZcMhg9Et2bPEBtebSVmgh4T1UOV08
         XRQ7mQBQ2wPnBL1kQXQs1P9jWQJd/h8NGf5QUzNRYU0cqEe8u1uWW90qnyuO16CKdc6S
         4NoA==
X-Gm-Message-State: AO0yUKW/F7QwnQ0CLAu5AtUN8M+7w3P6RlZVMlYWv339in6GOw7qjL34
        4/TXndvRRmvKxB5EAsdVyhHoKse4rKmZ0dPWzcEYaA==
X-Google-Smtp-Source: AK7set+j31tUzkLNQ8C27E0Z5OP01MEmmBzfCEEqFAlPnesMKBgVgoy6Ym7FhmmDtow0efITC0GnTA==
X-Received: by 2002:a17:906:7217:b0:886:7eae:26c4 with SMTP id m23-20020a170906721700b008867eae26c4mr9662360ejk.5.1679519352702;
        Wed, 22 Mar 2023 14:09:12 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id c3-20020a170906340300b0092fc6971000sm7652161ejb.40.2023.03.22.14.09.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 14:09:11 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id eh3so78385433edb.11
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 14:09:11 -0700 (PDT)
X-Received: by 2002:a17:906:aac9:b0:927:912:6baf with SMTP id
 kt9-20020a170906aac900b0092709126bafmr3825562ejb.15.1679519351218; Wed, 22
 Mar 2023 14:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230322200309.1997651-1-sashal@kernel.org> <20230322200309.1997651-5-sashal@kernel.org>
In-Reply-To: <20230322200309.1997651-5-sashal@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 22 Mar 2023 14:08:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=whZ8r85GhA=n8=NJCXOnpJ5KNqitV2FK2YnK73+Z7tzUg@mail.gmail.com>
Message-ID: <CAHk-=whZ8r85GhA=n8=NJCXOnpJ5KNqitV2FK2YnK73+Z7tzUg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 5/9] sched_getaffinity: don't assume
 'cpumask_size()' is fully initialized
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ryan Roberts <ryan.roberts@arm.com>,
        Yury Norov <yury.norov@gmail.com>, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 1:09=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> The getaffinity() system call uses 'cpumask_size()' to decide how big
> the CPU mask is - so far so good.  It is indeed the allocation size of a
> cpumask. [...]

Same comment as about commit 8ca09d5fa354 - this is a fine cleanup /
fix and might be worth backporting just for that, but it didn't really
turn into an actual visible bug until commit 596ff4a09b89.

                Linus
