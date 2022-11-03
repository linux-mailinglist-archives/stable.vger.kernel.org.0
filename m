Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D11618441
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 17:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKCQZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 12:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiKCQZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 12:25:57 -0400
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF431B1C4;
        Thu,  3 Nov 2022 09:25:56 -0700 (PDT)
Received: by mail-qt1-f179.google.com with SMTP id x15so1535671qtv.9;
        Thu, 03 Nov 2022 09:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9gjhCPJCfzSZsQpHkvf5XJYJR8ZLs4RZeQXTnmRRfgU=;
        b=G8hD1+eDOrKbp+hZ3UFufAsDD6Cwi4hJcSjuVPN3uRYnMNfWIY50wHicl6cIHrZK1T
         iHqsWEUFRIfwp93Wc6FVjEOr0TcMFjWkPGi6A6ZDnRmUafoM2vIWGSg3QOcVjWTDb8+9
         sh0DPsw7smWQ/WVvdkU8Xm51lIW1MssdsmuzCl6aHcmk914XaRJsG6/etVNtX0c0UQJX
         w6xKPHIVchsLGJizoupL6w6/JqkGGG3RhBZLNBliXk4CfHB1/2Rpuml6dPsObyZuXtsi
         GF6rq0XaU7JKUtAs3RdCjuVMVsmvhCiVP7r9A0zgU/FGhEA7Kt/vMUx156KNMj0CbGzj
         MgVQ==
X-Gm-Message-State: ACrzQf0PFtznfS1FJU41Zl5RSAZFfAD0aPaTCnT5FOUO37YmcUbb8okX
        sNIUqCZR43WoMjVUES3IdQZjrEXMcIV8iKGzJY8=
X-Google-Smtp-Source: AMsMyM6yvyrZ7NWy3i/4QUBAU6erlkf78B3kudKRnMAKNl0LLgW+Ajz9l40UDOVpEhNMaKNsm+H+05C8uzvenP/Nm24=
X-Received: by 2002:ac8:7d15:0:b0:3a5:449:87c3 with SMTP id
 g21-20020ac87d15000000b003a5044987c3mr25275935qtb.357.1667492755456; Thu, 03
 Nov 2022 09:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20221101022840.1351163-1-tgsp002@gmail.com> <20221101022840.1351163-2-tgsp002@gmail.com>
In-Reply-To: <20221101022840.1351163-2-tgsp002@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 3 Nov 2022 17:25:43 +0100
Message-ID: <CAJZ5v0iPFPbbconOoQ7x_4X5yJ31pP7aduLqG4dq6KgAsprKbA@mail.gmail.com>
Subject: Re: [PATCH -next 1/2] PM: hibernate: fix spelling mistake for annotation
To:     TGSP <tgsp002@gmail.com>
Cc:     rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
        huanglei@kylinos.cn, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiongxin <xiongxin@kylinos.cn>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 1, 2022 at 3:28 AM TGSP <tgsp002@gmail.com> wrote:
>
> From: xiongxin <xiongxin@kylinos.cn>
>
> The actual calculation formula in the code below is:
>
> max_size = (count - (size + PAGES_FOR_IO)) / 2
>             - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);
>
> But function comments are written differently, the comment is wrong?

It is, and it is more serious than just a spelling mistake.

> By the way, what exactly do the "/ 2" and "2 *" mean?

Every page in the image is a copy of an existing allocated page, so
room needs to be made for the two, except for the "IO pages" and
metadata pages that are not copied.  Hence, the division by 2.

Now, the "reserved_size" pages will be allocated right before creating
the image and there will be a copy of each of them in the image, so
there needs to be room for twice as many.

I'll adjust the changelog and queue up the path for 6.2.

> Cc: stable@vger.kernel.org

I'll add a Fixes tag instead.

> Signed-off-by: xiongxin <xiongxin@kylinos.cn>
> ---
>  kernel/power/snapshot.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 2a406753af90..c20ca5fb9adc 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -1723,8 +1723,8 @@ static unsigned long minimum_image_size(unsigned long saveable)
>   * /sys/power/reserved_size, respectively).  To make this happen, we compute the
>   * total number of available page frames and allocate at least
>   *
> - * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2
> - *  + 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
> + * ([page frames total] - PAGES_FOR_IO - [metadata pages]) / 2
> + *  - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
>   *
>   * of them, which corresponds to the maximum size of a hibernation image.
>   *
> --
> 2.25.1
>
