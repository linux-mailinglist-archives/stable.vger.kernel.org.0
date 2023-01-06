Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0C566097B
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 23:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbjAFW2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 17:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjAFW2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 17:28:20 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC9E8113A
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 14:28:19 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id o17so1947172qvn.4
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 14:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QXQOUJjcoX1hrsbbTN+Z+gwuy5Yx5WlxprMyzhgXuL0=;
        b=FSwATMmksAKMdpu1wQNSAU4HfcxbtJpqP5jg4jxAia7ZjIAJt4LpHBViEiX5ZkvhWV
         XA077dHR8grrfxkhZnG7h3W83Y6u9reeX0IgVJqi16hhxZZAnt1gx0ImUTDz0+wZcva6
         cB9bwoRmvnDNak/FU5AzQ18NzyvaFmMkZwKoA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QXQOUJjcoX1hrsbbTN+Z+gwuy5Yx5WlxprMyzhgXuL0=;
        b=4aJU6ZsZrlMzrhqI1P8zLz5LJONGeIa+0fUcIqHOA5Za1/AXCexrUsLwNsvwfMoAJ3
         MQofEY62wg66kPcf14FO8zHpzkazsOob17FuW3hXEu7xAAF+9umT2/wWfqfFFRzy9znH
         8xj8T/4JjGdBU0v4b0MxMo7rErhtApSFcZMf85rVrj+7zlyedwA1XzhtoB9NKByIFjLj
         ZB29PxpmKsXJKK9F9PtYNGTSUJ0lTuTikwXqLPIvUVdvCmX3yTEevgJSo87Pmk+dsa1v
         KMVDT/U8hetme+RzSfYOBlzRZL+hGfFzJl7z2GmaH41IsWe60xYJ7SbS+TUCeGu+s3c5
         fGFQ==
X-Gm-Message-State: AFqh2krVKtzKHJcNL4ttyUeXrmb7zX9PTKjrfAc/Eq2Bi9r2ZDnFxFN2
        AFuOdQM0dNA1gdMGJ36WyJPMp1+lQfFmslad
X-Google-Smtp-Source: AMrXdXvpRaTZE5t5fK3L7taW1sjXkCJHVzjvVORUeY/yy3aaHl60DZNFbYmfraepjv322rGv/4BGUw==
X-Received: by 2002:ad4:558b:0:b0:531:9d56:ab9e with SMTP id f11-20020ad4558b000000b005319d56ab9emr42039315qvx.10.1673044098416;
        Fri, 06 Jan 2023 14:28:18 -0800 (PST)
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com. [209.85.219.54])
        by smtp.gmail.com with ESMTPSA id c23-20020a05620a269700b006fb11eee465sm1221541qkp.64.2023.01.06.14.28.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 14:28:17 -0800 (PST)
Received: by mail-qv1-f54.google.com with SMTP id t7so1953750qvv.3
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 14:28:16 -0800 (PST)
X-Received: by 2002:a0c:df09:0:b0:4f0:656b:c275 with SMTP id
 g9-20020a0cdf09000000b004f0656bc275mr3791255qvl.129.1673044096460; Fri, 06
 Jan 2023 14:28:16 -0800 (PST)
MIME-Version: 1.0
References: <Y7dPV5BK6jk1KvX+@zx2c4.com> <20230106030156.3258307-1-Jason@zx2c4.com>
 <CAHk-=wjin0Rn6j+EvYV9pzrbA0G2xnHKdp_EAB6XnansQ8kpUA@mail.gmail.com> <CAA25o9Sbkg=qD+DH-aqXY9H5R_oBtePcnqagwAGCgoUk8D-Vyg@mail.gmail.com>
In-Reply-To: <CAA25o9Sbkg=qD+DH-aqXY9H5R_oBtePcnqagwAGCgoUk8D-Vyg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 6 Jan 2023 14:28:00 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi60PhJRzaBJ9uvVCpOpqSsKy=oXkGDq7t844BJ6dRcmA@mail.gmail.com>
Message-ID: <CAHk-=wi60PhJRzaBJ9uvVCpOpqSsKy=oXkGDq7t844BJ6dRcmA@mail.gmail.com>
Subject: Re: [PATCH v2] tpm: Allow system suspend to continue when TPM suspend fails
To:     Luigi Semenzato <semenzato@chromium.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jan Dabros <jsd@semihalf.com>,
        regressions@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Altmanninger <aclopte@gmail.com>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        tbroch@chromium.org, dbasehore@chromium.org,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 6, 2023 at 12:04 PM Luigi Semenzato <semenzato@chromium.org> wrote:
>
> I think it's fine to go ahead with your change, for multiple reasons.

Ok, I've applied the patch (although I did end up editing it to use
dev_err() before doing that just to make myself happier about the
printout).

            Linus
