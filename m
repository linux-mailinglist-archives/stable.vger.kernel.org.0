Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897964E6A61
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 22:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353022AbiCXVqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 17:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345641AbiCXVqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 17:46:31 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325C0B7168
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 14:44:57 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id b16so6996486ioz.3
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 14:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtG3L3i2VNWzLKZCzuXCjQJQZ/iQPSa3QxfocCII+yI=;
        b=QiXk2bRrt9r2iy2pw39Ur0S1CksPSEVIavay+B5XCLlr32bHYrl+Jg7S1Wz9sJJddl
         SfdJh5KvOpCXlLl6D0qlljbm2QqG1ZimdlJGZ+kY9v0tqLOFLckFYG0DIgSDejmgHFOu
         rvJt10zs3T+Zi/e0PitYFXusD6ngNFenflicfM+z7BGnOC4QWS34JsIgWTg7/zkzy/ce
         7yxmWbt6nH+726Ctq2wDyguUw9/BW1sCSX+QZ396esY35eMesUxgt4VlPFEdEaDT7vkL
         8gnnaadz7PnCccOhffngbcdUOLtLr14uCeS7R2+XRp2J/I3wNU3R3yqCdjO2F3zsGKm6
         uu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtG3L3i2VNWzLKZCzuXCjQJQZ/iQPSa3QxfocCII+yI=;
        b=n277Vx3pYJ6E00ggC40bBHzoXBtUA9Xkj/FiDBB5Eh9P+y+7As0mP8m1Rnwa1+Opb2
         Bucen147+x4Zp8WYciRF924sT1UUTdYqAllPhpfOSzy7CoOtB+isjB5EiSLJAYs5GJSX
         YeO/sMN3NFILr0Cf1JRawsPJfCvId5Xi+TDpLomASuYNEov72TaJoxRTjhjYmLsvY2FR
         auH9bkYCewb159urmV15wBrMUC+0STZtT97w7Ct21V9NNYMiBnFOMp7savXi7BlduSys
         ZQ8o+ZrHGgXO/1jwsFJUbFcWbC/wjwBdYOObIv/W+Pf54UJEGz7ErUUvY5+wEyK3aRVj
         X8QA==
X-Gm-Message-State: AOAM533dcZDPgDTknwbCjaeOQupZLdzOnLpCQhpPt7M4ekWn6fTgsx3d
        AUiS6lBDAV+A5g6W1hUN53MvgKTSM+dwkSmUm1FodA==
X-Google-Smtp-Source: ABdhPJzWHqISwWQ+GxG0Zg2dYghqEE6/RmqQZ/aiWq9FM5RxmFzYXqerGBEFOf6FUUsx7Gpn4GC0i7gIFHccilOldj8=
X-Received: by 2002:a05:6602:1493:b0:649:1890:cffd with SMTP id
 a19-20020a056602149300b006491890cffdmr3907876iow.167.1648158296431; Thu, 24
 Mar 2022 14:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220324210909.1843814-1-axelrasmussen@google.com> <YjzjiDFBgigPqEO9@casper.infradead.org>
In-Reply-To: <YjzjiDFBgigPqEO9@casper.infradead.org>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Thu, 24 Mar 2022 14:44:20 -0700
Message-ID: <CAJHvVcj90ROLGWGZi_f5b4VCugD4o7v3quCv-6A6jPUdMbqi6A@mail.gmail.com>
Subject: Re: [PATCH] mm/secretmem: fix panic when growing a memfd_secret
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 24, 2022 at 2:33 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Mar 24, 2022 at 02:09:09PM -0700, Axel Rasmussen wrote:
> > This patch avoids the panic by implementing a custom setattr for
> > memfd_secret, which detects resizes specifically (setting the size for
> > the first time works just fine, since there are no existing pages to try
> > to zero), and rejects them as not supported (ENOTSUP).
>
> Isn't ENOTTY the normal return value for this?  Or even ENOSYS?

I'm unsure.

Since errno(3) says ENOTTY means "Inappropriate I/O control operation"
that makes me think it's meant to be used only for ioctls?

I tried ENOSYS, but checkpatch warns me it's meant to be used for
"invalid syscall nr" and nothing else.

ENOTSUP / ENOTSUPP / EOPNOTSUPP all have their own share of
weirdnesses too, though. There's the whole ENOTSUP / ENOTSUPP mess,
and then also the fact that glibc says ENOTSUP == EOPNOTSUPP, whereas
POSIX says EOPNOTSUPP should be distinct and used specifically for
sockets...
