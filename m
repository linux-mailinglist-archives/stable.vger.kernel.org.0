Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75A46185E9
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 18:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiKCRM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 13:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiKCRMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 13:12:03 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6D310F4;
        Thu,  3 Nov 2022 10:11:33 -0700 (PDT)
Received: by mail-qk1-f170.google.com with SMTP id f8so1570963qkg.3;
        Thu, 03 Nov 2022 10:11:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FmNP3uoYCzkfLKfdvSNP8vmEQ9HQi+Gv2smq8ORE26I=;
        b=lJ0rfpe70ZdQ7IoLsjcUFjjps9k55NQeKReYbakfGX90hljAJ+NoY3BnurUS9f8xS/
         i7E9NFcnF+p/t8Y4pAdViKA2jddV5nzKdrBcvZW+nzkTdQOgqoDDopxC303e3It0iIkR
         EWA09ZVIwoCUjVu17hgmAOFpxs5LTo23zDkSxUTpKAMsd2taaQQlDJDFAwCNB5TqLays
         7MBDSxJhCh3LId89ftLRdGbDrkKl4T4hsZNsY8gTwNc4Cv7hslU0B1abUJh1PD47x+su
         AAK/4o49BtfpHHsrb4yKuqhitRMGvixDvCyMctcoLylHBY+v8Wp9+XFXURycCDbGPbs7
         SPWQ==
X-Gm-Message-State: ACrzQf0HhJ/D4DyIZ0PVjHkCuWe8dilg8oU2bcfTLrRWDrPeV4z2MLXq
        avEsLuVNOU26IXOPQCP/wF1rmJwIUKhe43C0VbE=
X-Google-Smtp-Source: AMsMyM5eMLeKCzeXzgK2daRJrdAyD7SYnj03/JEE2uZJrtWBHJW8NrHuSIJvhUAObKxVgJmvPRJf3hW3UsoKs+xz1Zw=
X-Received: by 2002:a05:620a:d89:b0:6cf:c98b:744c with SMTP id
 q9-20020a05620a0d8900b006cfc98b744cmr22344544qkl.443.1667495492970; Thu, 03
 Nov 2022 10:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <20221101022840.1351163-1-tgsp002@gmail.com> <20221101022840.1351163-3-tgsp002@gmail.com>
In-Reply-To: <20221101022840.1351163-3-tgsp002@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 3 Nov 2022 18:11:22 +0100
Message-ID: <CAJZ5v0gWBfL4y6RAhDHMx2tbGDFppLJdjb2TFU1aEPn3d+FJqQ@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] PM: hibernate: add check of preallocate mem for
 image size pages
To:     TGSP <tgsp002@gmail.com>
Cc:     rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
        huanglei@kylinos.cn, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiongxin <xiongxin@kylinos.cn>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 1, 2022 at 3:28 AM TGSP <tgsp002@gmail.com> wrote:
>
> From: xiongxin <xiongxin@kylinos.cn>
>
> Added a check on the return value of preallocate_image_highmem(). If
> memory preallocate is insufficient, S4 cannot be done;
>
> I am playing 4K video on a machine with AMD or other graphics card and
> only 8GiB memory, and the kernel is not configured with CONFIG_HIGHMEM.
> When doing the S4 test, the analysis found that when the pages get from
> minimum_image_size() is large enough, The preallocate_image_memory() and
> preallocate_image_highmem() calls failed to obtain enough memory. Add
> the judgment that memory preallocate is insufficient;

So I'm not sure what the problem is.  Can you please explain it in more detail?

The if (pages < alloc) appears to be false in your case, so there
should be enough free pages to create an image.

Maybe reserved_size is too low?
