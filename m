Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DFA6B0BA3
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 15:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjCHOmS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 8 Mar 2023 09:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjCHOl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 09:41:59 -0500
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6904A5AB4D
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 06:40:06 -0800 (PST)
Received: by mail-qv1-f51.google.com with SMTP id f1so11158403qvx.13
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 06:40:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678286404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4f2+lpxLP4ODbLRB2au6aR5Gha4EMlW5QIi2wJfZcUA=;
        b=ixBbkLoFUVUKeNBxk+KQhjoRy5RzGb1j+qknzCM0Ehfrl/s8piVW6hcC0ubp3EaFJl
         yXa5Pw9RnGe/xJl+ifOTWPUYGcvMDbz32BnKZ6IzhHNwiDF3Z7ZntmHwVLltqPTaZbcr
         ZYXUki+Inj13K9V+QPt+Xz4Xf9ZX02D8W0m+wNd+8HkOZvriwkIed9va4suO+sQEiVsB
         /2T49Jlt4AYvaAazLKjZoJ+98QlreZQFJFNCLq4Lfu9dYgmIsgj5z8++wnxCe+YiPtqT
         f5MTBNcwNi4dDZmELf2ZOMjkEiFADEu0ckB/yKEt5BlgvNoegA9sCK9xZestmQccHoik
         RkfA==
X-Gm-Message-State: AO0yUKUP86Ulv9phhcubp1Fii5j9PsBcuGqNgtUvG26qmLk07HpUuyYQ
        /64L+Rfjc/r2cVS6c47RP6e9EzUD3YM4p02G4cI=
X-Google-Smtp-Source: AK7set8pB2gnZCbycMkMUIJnUm5Xu5aMQzuKY2dv/+7RS7kIv3lki1QYeOYrYrm1P/og9QA8oXa0ZVI2MvdQlL6NMSg=
X-Received: by 2002:a05:6214:1768:b0:56f:a4:d7f4 with SMTP id
 et8-20020a056214176800b0056f00a4d7f4mr4898337qvb.9.1678286404269; Wed, 08 Mar
 2023 06:40:04 -0800 (PST)
MIME-Version: 1.0
References: <ZAgnmbYtGa80L731@sol.localdomain> <ZAgogdFlu69QlYwu@kroah.com>
 <CAG+Z0CuAQsq-1DNaX0_qHnqSBt1YrUBbBaypxgwT0USFyOkk4g@mail.gmail.com> <4e731dfbe197f5c0a6c1093aee503b7f4d76cc1a.camel@gnu.org>
In-Reply-To: <4e731dfbe197f5c0a6c1093aee503b7f4d76cc1a.camel@gnu.org>
From:   Dmitry Goncharov <dgoncharov@users.sf.net>
Date:   Wed, 8 Mar 2023 09:39:53 -0500
Message-ID: <CAG+Z0CsQB9MqWCoQTBjMMGfbkV1=P5fA2JFTFOodWcfFQPh2tA@mail.gmail.com>
Subject: Re: No progress output when make 4.4.1 builds Linux 4.19 and earlier
To:     psmith@gnu.org
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@kernel.org>, bug-make@gnu.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 8, 2023 at 8:58 AM Paul Smith <psmith@gnu.org> wrote:
> Does anyone know why this commit is using a make version comparison?

Kernel build system is expected to work with gnu make-3.82.
make-3.82 puts long options before short ones.

$ cat makefile
$(info at parse time makeflags=$(MAKEFLAGS))
all:; $(info at build time makeflags=$(MAKEFLAGS))
$ make-3.82 --warn-undefined-variables -sR
at parse time makeflags= --warn-undefined-variables -sRr
at build time makeflags= --warn-undefined-variables -sRr

regards, Dmitry
