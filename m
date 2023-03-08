Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A9D6B0849
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCHNRW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 8 Mar 2023 08:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjCHNQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:16:45 -0500
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CB3B8578
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 05:13:40 -0800 (PST)
Received: by mail-qk1-f177.google.com with SMTP id g20so5621083qkm.7
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 05:13:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678281192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQn8Ji9x/B6BK2H/4wZbT0N2VKWgD1WXH07kqwgnaL0=;
        b=UxuxMIwO9jdEnehX0BCvUUfN/Qudk0RrCvQrXrIJuvriD3MZXJl6NGWn0jBmF4YA7C
         lF9vxmxy/m9K1i2h/MrbTs/jqS66+C2gs08aHNQj8MuReHZpdYo6ZdYYO+zmgpwiJtPu
         wZNKT06pYwa/PZ46/wUPv3QQ5NgiMaPoVZUYNveaqNtHrGl7FkcC3jGxCzVkV/5LWdxC
         QZZKXlclwxTFgvIDR++0W+LTFm6/ANIF+M3I2mnjnK0zkcfdRut9NoYEGOBwLhEDxCZu
         w0vHtdDIydN5OgfanIWbcq1DGKd0mLgXf+Yyc42IX1zZmzYzK0GUGtH4S43moJ3M+9Xi
         3vrQ==
X-Gm-Message-State: AO0yUKU446ppPKiaDuky9P+UlZjqZCyPSffej6VP3QZ8uMzz8oB3oZg/
        4bgu3tdg5jVGu2YJqBmTQBVQp5tKsxRpXvvFLMA=
X-Google-Smtp-Source: AK7set+8uTIZ3iwDe630oKv7+9UjamK+Ztwa/SiNrKyPOd4d9nuI2OKqWgPKIGrVXvV0Mw5aDbAam0H5L2VP2LK8/B8=
X-Received: by 2002:ae9:ea14:0:b0:742:7f24:4cd9 with SMTP id
 f20-20020ae9ea14000000b007427f244cd9mr3949903qkg.1.1678281191766; Wed, 08 Mar
 2023 05:13:11 -0800 (PST)
MIME-Version: 1.0
References: <ZAgnmbYtGa80L731@sol.localdomain> <ZAgogdFlu69QlYwu@kroah.com>
In-Reply-To: <ZAgogdFlu69QlYwu@kroah.com>
From:   Dmitry Goncharov <dgoncharov@users.sf.net>
Date:   Wed, 8 Mar 2023 08:12:57 -0500
Message-ID: <CAG+Z0CuAQsq-1DNaX0_qHnqSBt1YrUBbBaypxgwT0USFyOkk4g@mail.gmail.com>
Subject: Re: No progress output when make 4.4.1 builds Linux 4.19 and earlier
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, bug-make@gnu.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 8, 2023 at 1:37 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Mar 07, 2023 at 10:13:45PM -0800, Eric Biggers wrote:
...
> > Is this an intentional breakage from the 'make' side?
No it is not an intentional breakage.
This is a fix for https://savannah.gnu.org/bugs/?63347.

> The fact that kernels 5.4 and newer imply to me that there is
> a kernel build fix that should resolve this if someone can take the time
> to bisect it...

Kernel makefile was updated to work with old and new make in
4bf73588165ba7d32131a043775557a54b6e1db5.
If you wanted to backport, try this commit.

regards, Dmitry
