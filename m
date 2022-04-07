Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA624F740C
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 05:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiDGDiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 23:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240677AbiDGDhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 23:37:35 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13798237FD3;
        Wed,  6 Apr 2022 20:35:25 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id bq8so8113862ejb.10;
        Wed, 06 Apr 2022 20:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4H2T8JJWjYpt3XRuRhcXEKbniAwe816BUUeRliUgkw=;
        b=RYYfcvd5j+SVV/sd5xTnMZnGZGK5WJeopGbkKSiIaFlplxy/lUvGU0BeF+Hj7cUQi/
         YwXHsGAtNA5aYLC8HHzJ7wmtEVcC9G6qOh0WavFyKinlkK6cnHU0tnWPvL6J+4Fz+rqu
         83JC0zexGRoU8GVxbnhGqK0cYymzxSMj0KSBkJY9MUR02ugeCFvxzWawMU0mqFKGNMGt
         GsIz6sj9Qb44ZG3LTfhgmuuGYj05RNIfk/hPym5qIUGgyWqMr2OnSDCtGJejCWk/BwG1
         vbCBTZnWhpx4c1RvA2cv8Txp8wzfAjMxFiXNvNPgfKivp/v1I2pdTJ6BJmxm5I3vvaKj
         G9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s4H2T8JJWjYpt3XRuRhcXEKbniAwe816BUUeRliUgkw=;
        b=NNnwzpui2KkcD17IjyJmt1k3PuO0E4bDhrM2H+8Db7wmTxTGz0IcicFGwRAR250biR
         403b0o2/fvi1JDnvD0CXUfYGO5EmbLvRtfadYTlvyn6GPZeWn0lojqDcgPhT0fJGeyxg
         K5ggSCFBJpVWUI7XMzCND3FUWDujSMZO5ywQp6sGrCWfNITuGC/BagQx7nM0Vwj+MUQT
         oCkTI83c0UTU7EY8qW4SbFwOLKjipUw4CCmEezuRMpecNcfAguId/hTiGkOFRjE+k2PI
         qX8Tt5aN5O7I3wwyDbzrsHxjniUmMOygrA0xxvyIY7/kO8ck5hpEtNmLFT8x/dcMsy/H
         84aQ==
X-Gm-Message-State: AOAM5328VWi1eJVpkBDHMrUsZPxYK3fVlSj1JnVqL9d5cexLyQlsQLQ5
        rRakej62psKI/kkNZHHTZG1vI4AOQKVUzRqkgxg=
X-Google-Smtp-Source: ABdhPJyrpOKbsN9sg7QHzokqGzRTkcBC9jLm5ASAzAbKnmphjqIK3b+O1o1mqT8GFMRkTvjd4qHlCwwh8vAQ5Ct+z6k=
X-Received: by 2002:a17:907:8a19:b0:6e8:a7e:5f50 with SMTP id
 sc25-20020a1709078a1900b006e80a7e5f50mr11570936ejc.322.1649302524167; Wed, 06
 Apr 2022 20:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220406142819.730238-1-guoren@kernel.org>
In-Reply-To: <20220406142819.730238-1-guoren@kernel.org>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Wed, 6 Apr 2022 20:35:12 -0700
Message-ID: <CAMo8BfK6uo5fPCbo8Wp3oRYOUXoz0jv_zJMHuVHhFgh3DSSqNQ@mail.gmail.com>
Subject: Re: [PATCH V3] xtensa: patch_text: Fixup last cpu should be master
To:     Guo Ren <guoren@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Chris Zankel <chris@zankel.net>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>,
        Guo Ren <guoren@linux.alibaba.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 6, 2022 at 7:28 AM <guoren@kernel.org> wrote:
>
> From: Guo Ren <guoren@linux.alibaba.com>
>
> These patch_text implementations are using stop_machine_cpuslocked
> infrastructure with atomic cpu_count. The original idea: When the
> master CPU patch_text, the others should wait for it. But current
> implementation is using the first CPU as master, which couldn't
> guarantee the remaining CPUs are waiting. This patch changes the
> last CPU as the master to solve the potential risk.
>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@kernel.org>
> Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/xtensa/kernel/jump_label.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks. Applied to my xtensa tree.

-- Max
