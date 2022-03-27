Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A354E889C
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 17:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiC0QBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 12:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbiC0QBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 12:01:19 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887FE40900;
        Sun, 27 Mar 2022 08:59:40 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id v15so9645204qkg.8;
        Sun, 27 Mar 2022 08:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ZnzCFRByXntSU7k5TRZSgVAD599ZPHNRY98L+OsrQw=;
        b=DqBfb5jIk2ktmkrV+knoXXQmcfSvVoQoTGiplm8hYemtLvRyRO0gCc9VF/3i6MWNEh
         P3Kg5/MCveBJhKIZ5HfuscK8u1hQP20FZslvKQNhbYKkjqUjRfBbEZhOZCR5UsCZKb4I
         rwHgIioqNxZEzAQn8z7BLR8cSQQS4WT/b+mcXAljKFnjXpWFhVWYTkHXYfaMJ/zHfbjI
         wchaEKOaK1D0lz/vzsjvJ5vhjNm7ylxVJzdDbKcd8w+PzS4KRNTO9L2JHmoqOl+1gV8O
         KBSFOj0Z5ThEMhqbqT/h3lX1mE96yhGdAkHgM2j5JKiKDeplMIsG77RHO7dUaOXTtZsP
         Jmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ZnzCFRByXntSU7k5TRZSgVAD599ZPHNRY98L+OsrQw=;
        b=yQnGtyQSIY06bGQSpT/9CohFA8bMiys75D2JxMvpmdcFOfE5nJ2SWfOWpI21oe3bpK
         zhYnIjil1xFe0TLrZ+L7klBkWd1T18X0OsnuRYHmoNx1XTSrsPe7AxcGjO+bOHQpCy+i
         WDDZsglgWxrBmlrQ27WKdy7TgifpvLgdOVw2LZTs5Mv4RgFqBMwx5PLcxH45WtFN5+3f
         jWi3NQDRpYya+AsXZ8bmhHlFZuGo5kM7XFJ8flYQw3l9CvbKe+yQv/OrwfeVwq02NJLt
         sCO//mdi9/c/lNjJ+QR0YUEglnm8MAjpgc2O5Y0fDqCV9dBxgdkYO+egEptNvsKEcD8r
         Xbfg==
X-Gm-Message-State: AOAM532wRG6WbYkgDuSUVoBgJgodfFGU9c8Fdr3EXMdtHzdQzY/qN3j2
        R1ovfq7UPT/cqBWlLkj73b8VcBWZHcjiHYHRNEU=
X-Google-Smtp-Source: ABdhPJxdniX0MXVep0Yv4bjS9+PKe9AQZapJOFcqCjRTA5QaiGCa9suZ8apvfMlweJa5b3areRFbKMEWvgqcTmDfwtQ=
X-Received: by 2002:a05:620a:1a87:b0:680:cba9:ed5c with SMTP id
 bl7-20020a05620a1a8700b00680cba9ed5cmr2151933qkb.482.1648396779731; Sun, 27
 Mar 2022 08:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220327073925.11121-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220327073925.11121-1-xiam0nd.tong@gmail.com>
From:   Emil Velikov <emil.l.velikov@gmail.com>
Date:   Sun, 27 Mar 2022 16:59:28 +0100
Message-ID: <CACvgo50pK3rr5UH_FyfR1pADmPRjEawi43cAecoaz7nM5AFgBg@mail.gmail.com>
Subject: Re: [PATCH] dispnv50: atom: fix an incorrect NULL check on list iterator
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     Ben Skeggs <bskeggs@redhat.com>, Karol Herbst <kherbst@redhat.com>,
        Lyude <lyude@redhat.com>, Dave Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        ML nouveau <nouveau@lists.freedesktop.org>,
        yangyingliang@huawei.com,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        "# 3.13+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 27 Mar 2022 at 08:39, Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>
> The bug is here:
>         return encoder;
>
> The list iterator value 'encoder' will *always* be set and non-NULL
> by drm_for_each_encoder_mask(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty or no element found.
> Otherwise it will bypass some NULL checks and lead to invalid memory
> access passing the check.
>
> To fix this bug, just return 'encoder' when found, otherwise return
> NULL.
>

Isn't this covered by the upcoming list* iterator rework [1] or is
this another iterator glitch?
IMHO we should be looking at fixing the implementation and not the
hundreds of users through the kernel.

HTH
-Emil
[1] https://lwn.net/Articles/887097/
