Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1746F6C54C2
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjCVTSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjCVTSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:18:07 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC0A49FE
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:18:06 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-3e0965f70ecso116301cf.0
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679512685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8PRA3sJfD9HyXGCWY9YipToyHM8CgMwmCisB96ydq2w=;
        b=K+UJ6vN1HBrHL49EqL+cQLNjpgeYs0ZZfba7+cBZsajsgvOih5RT3oaw7Nq3w9QGgZ
         Xc2S6ojNlCtmHEb7w9gTCHQYhr8rYG/Js+XHeOTHupKwPGYzwbp5l0Cmc/LCOyOUCkxW
         r94pL7Y+mv8INEqWrTIXJRRfhr/y6JcPFyqE0tpPtmDEFq5CGQvrByxQFkcvD6EhFhGT
         DHLEEmeOX6QJ/qIfY2ocFi18K6rnipyc5Rg3WCshHWugTZHbrVEO0LtkBdetOH0Naq4Q
         HAnvQ/4/4XaWwtZ/u6xaQhRzHvHs7TbVxmHIFsgopok8as+HmXmpkzXSfs4yc9Yo5RPY
         uy+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679512685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8PRA3sJfD9HyXGCWY9YipToyHM8CgMwmCisB96ydq2w=;
        b=0IZiIFP3fhpkvVlp6VW1eYprtA2MGaftWibbO8HiovBRJqNs23UDvbkUJQkpEj5EbR
         Om+i+NURkBafXgNVdEJ/M0MwuqE5pB6l8YTHOIVAu6cOVgo2Hzc+GBRVeq1wSDW8OyDl
         NSfrC5iipq/yc3yfHTXag+hWZOTjWkKOjDScyuoz1qUrQ0VmZkbXwm273TNfzzpRuBZN
         rWpMZh3XWGydMyxURffZJWzeH5zJRID1V5CzAx+kntq5tbJG5qjtbF5P2mBvNIrgL3rF
         d5Ji6q3/34lyUdtMeJOlpYI8ja5x+M7rG9LZVryvB9g/gLWgv0EWEHSrhMhZWqWehl9E
         Nyxg==
X-Gm-Message-State: AO0yUKV2KTbjXwKUtTspcMjfZa7vQfFyPCHUXAuSQYZxEiqj/JSAoAQz
        5ppsoYPP/2Gcm4gYpk51MgytJOmq+QteUEl6Vvgrbg==
X-Google-Smtp-Source: AK7set+QkZ7RQk9Y3huVY+lyevn/umcM6E8n28dvKLKep1HsTt0CKUG843S0Og+iIA0aw2BCe0wCbvNkIo228kEuWms=
X-Received: by 2002:ac8:7d14:0:b0:3ab:6af8:4182 with SMTP id
 g20-20020ac87d14000000b003ab6af84182mr459356qtb.3.1679512685381; Wed, 22 Mar
 2023 12:18:05 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 22 Mar 2023 12:17:55 -0700
Message-ID: <CANP3RGeiFUsO4X_qQszO5JRY7UDSQVxuC+57aCscL0p+dmjyKA@mail.gmail.com>
Subject: 5.10 LTS - Request for inclusion of getsockopt(SO_NETNS_COOKIE)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@google.com>,
        Sasha Levin <sashalevin@google.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Could we please get:
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3De8b9eab99232c4e62ada9d7976c80fd5e8118289
  'net: retrieve netns cookie via getsocketopt'

included in 5.10 LTS.

This is technically a feature, but it's absolutely trivial - it just
adds a new getsockopt to fetch a u64.
Using netns cookies from bpf without it is pretty annoying.

It doesn't cherrypick to 5.10 cleanly, due to trivial conflicts in
header files (previous constants haven't yet been defined),
and because of a post 5.10 change from atomic64_t to u64 - which
requires adding in an atomic_read(&).

I've uploaded a compiling version to:
  https://android-review.googlesource.com/c/kernel/common/+/2503056
I think you should be able to cherrypick it via:
  git fetch https://android.googlesource.com/kernel/common
refs/changes/56/2503056/2 && git cherry-pick FETCH_HEAD

Thanks!

Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
