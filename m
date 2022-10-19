Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACFC604F9D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 20:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJSSaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 14:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiJSSaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 14:30:19 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2B4132DCC
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 11:30:17 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id y129so8705679vkg.8
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 11:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gWWNrY8VteoxjjIT/dMuzEL5eZa4lwQJRKCrAGYQAX4=;
        b=OUtKKTl4yxhB4jfwUVoif8rQfqUPGTn+x9nmD513lwknbKJPxU8LX7ocCUL+zj+dpU
         DnOGWVXZceZOI2fyRmh6MDNCfvQUsXdO6DX8ebZE2tSGPR4uvaAMWTq2ezgzx5C8MyQZ
         wdMQW5ImTEL2zGGeTDgqSHhxCna+yCQqN0wALrPxtS0cncoDcjynifs3KRKUc+3NAZvA
         qtcAK3G96DkktWOTxJEofzkjIVRioPcc1x2aSN35E7+ImW7KiypcuA5OWF4dLmwdZyK1
         CDUJeT0VuxSEP6JDFtDicq6dxp7QpSZJFCMrj5O3riSc/10jJhN/8pXhTUUkxeydV+xQ
         z8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gWWNrY8VteoxjjIT/dMuzEL5eZa4lwQJRKCrAGYQAX4=;
        b=swMwSziIznUtcVeAjlA6DFXwcX28giVVAc/2woNxf1eJm/52W4o8z0acP5m7ON+u/u
         TeZPpKg7sSGx1ng/mJe/WhxPnrBkRpwSXhd0MOuri5h86vmzS/T/AHwdCXtUnSHUQ7is
         lh41viwt5E9fJx5wx3dWayCZB/nyw56QlVBqNcZj+ofuBP5J2icIncR916gMMZLPbH7f
         p5hOTbZpjR85X/xf4FlXMOSi8ebyGRtiN/35MVRHmvXs81ldT10kqcgqH7i6ci4aZIV+
         eCrt9egs/WEeXfL/N1/UIu9zdO5WVhn9SLDYB0Hk+yFAXEKTFzevx1drNNwJ1aY35F5B
         38Ng==
X-Gm-Message-State: ACrzQf3ntRdkwOt3AAGrTRp7XErHp5LxoOziDz08eNbom7jp3HgMU+0o
        x8AexVx7mZ3QcRLi8HxX5Um9kuU5xvc/eDG0I8bfaD8V2E/1bQ==
X-Google-Smtp-Source: AMsMyM65Qr0Y6shBS9EM2GlUZA98lwe4HsH0CWLPDU2Ruhs25KkQ8inF2lXKJainIy8h5Bke2IsbJcU6n1misDLJ2SU=
X-Received: by 2002:a1f:4843:0:b0:3ae:c4a3:d653 with SMTP id
 v64-20020a1f4843000000b003aec4a3d653mr4699971vka.1.1666204216868; Wed, 19 Oct
 2022 11:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAFKCwrhcszDEzW8S2Y_aCZW2o5H6S=Z-Ao1ASpzPw3ZOm9UAtw@mail.gmail.com>
 <Y0/i9FPtzJ1HmA2N@arm.com>
In-Reply-To: <Y0/i9FPtzJ1HmA2N@arm.com>
From:   Evgenii Stepanov <eugenis@google.com>
Date:   Wed, 19 Oct 2022 11:30:05 -0700
Message-ID: <CAFKCwrj56rvKedhxoNWeaUWHEs+ee6SXCAHDE8DZ-+QCn_9MCg@mail.gmail.com>
Subject: Re: backport of arm64: mte: move register initialization to C
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 4:43 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Oct 18, 2022 at 03:33:08PM -0700, Evgenii Stepanov wrote:
> > please backport the following commits to 5.15-stable:
> >
> > commit 973b9e37330656dec719ede508e4dc40e5c2d80c upstream.
> >
> > Please note that the extra backport below can be avoided with a
> > trivial change in the above patch. Let me know if that's preferable.
> >
> > Cc: <stable@vger.kernel.org> # 5.15.y: e921da6: arm64/mm: Consolidate TCR_EL1 fields
> > Signed-off-by: Evgenii Stepanov <eugenis@google.com>
>
> If cherry-picking commit e921da6 is sufficient for the backport, I'd go
> with that. Note that I haven't tried, does it work for both 5.15 and
> 5.10?

5.10 is missing arm64.nomte logic in the first place (commit 7a062ce3
upstream). No need to backport this change.
