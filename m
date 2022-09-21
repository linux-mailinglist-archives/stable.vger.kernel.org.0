Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC695E54E2
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 23:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiIUVEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 17:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIUVEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 17:04:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570DD54642;
        Wed, 21 Sep 2022 14:04:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hy2so12818491ejc.8;
        Wed, 21 Sep 2022 14:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=FLr9Abps22poUV5QNewM4+l1Irbxsm19q2GuUdCv3TA=;
        b=Rnkb+MkaSEROZiIIlWBkPUqd4z4uxntZ2u0pX/1yLJxw80BGwHcnmd/QDsp5kl3/8I
         oGeCoC0/HinKag0gYfkXFmInDj8rEH6GdhhbR0nYQpCWzCRUdx1K8KbWDzge5lkkta+l
         7C9y7c9SCelq5p03BupSea6S5Hwdc740aBMkWoWV7Xa+pTPnwzdaocfrdTGjY9Z9m4Ps
         sIdeJs3PbDUffdQ6vBkLZ9QkFNqZOcXX0VXS4yKjk+Zvhfl9WrpK0mcP8wRBazayrj2j
         Gkhsb9IOiAhIFKiujJrOxkkI229KYqZ9lrSo8h1tUsqGHzeRApV4L5Z2D1vVg48s1XEK
         Jbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=FLr9Abps22poUV5QNewM4+l1Irbxsm19q2GuUdCv3TA=;
        b=St9EU9IsBVH+KPzdXSF/WzMF2cxXeZCbiZQBoYk4xNbHmfZdsx64pi4YqzfIP7Sujs
         RgxEeUVvjqSMlPxbIL3rSAWC4Z73ZSYi9lx4xoM4vyevEtzIWvaxvAUPUAYCpbx1c4E8
         wuLJD/FStX5RzLiqDYPs/haT1i/geNwnAwuHTekQ/lP064QTx8EpAHymlfJNyfeBd65o
         7UsVMvpLS0uWxMbsOTjQGMpW+KfHy6QyviIgiaswGUWiTbm0qRJYH2+BdPEpE+tnQV6v
         NkCmnFYL5ixtb/KvzFy1Q/98RNc7AeEZfeJ36++0dHuF6WP8zCCPbu+GM5kLduMNVgkr
         VN0Q==
X-Gm-Message-State: ACrzQf3tvd+0iZ/yoeFBWYyCZDM6r9Da8Ivac8S6oZ4AArcWw4Pw2IRD
        bXxDxwGdX0goZR5eTjf9s8pGJxkyRby93qWic2Y=
X-Google-Smtp-Source: AMsMyM6+tLv/G8UIHxwsFf18WlJsZgf6ULy/sunP0kiQcokmlh9B3TJCNi3rCyBnfqdvtKgpdNZtW1pfUsSZGCG40O4=
X-Received: by 2002:a17:906:99c5:b0:73d:70c5:1a4f with SMTP id
 s5-20020a17090699c500b0073d70c51a4fmr144110ejn.302.1663794289747; Wed, 21 Sep
 2022 14:04:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220921082738.7938-1-memxor@gmail.com>
In-Reply-To: <20220921082738.7938-1-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Sep 2022 14:04:38 -0700
Message-ID: <CAEf4BzZ7t6s7TvP11Os3+zP2VMpxfdNVvzgUm9YOGqN1ew6PZg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Gate dynptr API behind CAP_BPF
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, stable@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joanne Koong <joannelkoong@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 1:27 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This has been enabled for unprivileged programs for only one kernel
> release, hence the expected annoyances due to this move are low. Users
> using ringbuf can stick to non-dynptr APIs. The actual use cases dynptr
> is meant to serve may not make sense in unprivileged BPF programs.
>
> Hence, gate these helpers behind CAP_BPF and limit use to privileged
> BPF programs.
>
> Fixes: 263ae152e962 ("bpf: Add bpf_dynptr_from_mem for local dynptrs")
> Fixes: bc34dee65a65 ("bpf: Dynptr support for ring buffers")
> Fixes: 13bbbfbea759 ("bpf: Add bpf_dynptr_read and bpf_dynptr_write")
> Fixes: 34d4ef5775f7 ("bpf: Add dynptr data slices")
> Cc: stable@vger.kernel.org # v5.19+
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/helpers.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 41aeaf3862ec..f57a08b6dddb 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1607,26 +1607,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>                 return &bpf_ringbuf_discard_proto;
>         case BPF_FUNC_ringbuf_query:
>                 return &bpf_ringbuf_query_proto;
> -       case BPF_FUNC_ringbuf_reserve_dynptr:
> -               return &bpf_ringbuf_reserve_dynptr_proto;
> -       case BPF_FUNC_ringbuf_submit_dynptr:
> -               return &bpf_ringbuf_submit_dynptr_proto;
> -       case BPF_FUNC_ringbuf_discard_dynptr:
> -               return &bpf_ringbuf_discard_dynptr_proto;
>         case BPF_FUNC_strncmp:
>                 return &bpf_strncmp_proto;
>         case BPF_FUNC_strtol:
>                 return &bpf_strtol_proto;
>         case BPF_FUNC_strtoul:
>                 return &bpf_strtoul_proto;
> -       case BPF_FUNC_dynptr_from_mem:
> -               return &bpf_dynptr_from_mem_proto;
> -       case BPF_FUNC_dynptr_read:
> -               return &bpf_dynptr_read_proto;
> -       case BPF_FUNC_dynptr_write:
> -               return &bpf_dynptr_write_proto;
> -       case BPF_FUNC_dynptr_data:
> -               return &bpf_dynptr_data_proto;
>         default:
>                 break;
>         }
> @@ -1659,6 +1645,20 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>                 return &bpf_for_each_map_elem_proto;
>         case BPF_FUNC_loop:
>                 return &bpf_loop_proto;
> +       case BPF_FUNC_ringbuf_reserve_dynptr:
> +               return &bpf_ringbuf_reserve_dynptr_proto;
> +       case BPF_FUNC_ringbuf_submit_dynptr:
> +               return &bpf_ringbuf_submit_dynptr_proto;
> +       case BPF_FUNC_ringbuf_discard_dynptr:
> +               return &bpf_ringbuf_discard_dynptr_proto;
> +       case BPF_FUNC_dynptr_from_mem:
> +               return &bpf_dynptr_from_mem_proto;
> +       case BPF_FUNC_dynptr_read:
> +               return &bpf_dynptr_read_proto;
> +       case BPF_FUNC_dynptr_write:
> +               return &bpf_dynptr_write_proto;
> +       case BPF_FUNC_dynptr_data:
> +               return &bpf_dynptr_data_proto;
>         default:
>                 break;
>         }
> --
> 2.34.1
>
