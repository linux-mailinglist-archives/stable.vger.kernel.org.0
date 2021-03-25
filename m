Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D891349CF3
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 00:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhCYXhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 19:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhCYXgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 19:36:45 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666AAC06175F
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 16:36:45 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id l123so3636322pfl.8
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 16:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8ub3+KaVHR67U2QACzlICSww+btiIMyI8S4cGZM+QbM=;
        b=YNP3csUtke1uWeppGyLz3d/mgtKAW3dwkcruzfL+2fTZ9nCh9raBIGfyKTsPQgdbdd
         RNO3cYBsYF4/4yjZ7h+dF05qxq6/lb7hjDmm1od/dg7dmW9SUazvNNUWdtSarZhh4oMR
         bhf2VaYwkD+R02AHCM41L9lJSqs+Ha24dbFD2A3iTZjx/hNHeYjXQ5vdY5crbT+w8cu9
         N//W8D8jy2WtBCkYL9naqXhCCF+dCQxR/lKsQtMnq4Ml38nim+7M7y8QzDZ5NmgdwDKa
         l+jMnJE3i38tUeQfjk4F7KAMwYzbtIqpLpwqLlCLrkzo1p+9Mlk2SEAZqwbiuok83yQy
         RF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8ub3+KaVHR67U2QACzlICSww+btiIMyI8S4cGZM+QbM=;
        b=WTWQ8eYYxKhvFIjnugfMRgKKTF3XjvQXafe2oqqGqZqRIyeVG0ahOrG6LvQmDr388C
         A8edkhvYvQsPEu9XX0UtPMnmxhsxmRjl4ehUrr3cOvwwEZVic/PVE8V3O86iwqZqT7kq
         0GxbVp0oAtbDvC4VrRJLa5F5zPXAGpGFyCTRMi84gyfBHYl+Nknb4tO4W+PVvlzXKZMG
         SbnEEFippkRCR03p9qKbwvzOag6XGYTk7bfEnwiw/thUbkRjDIU+VcnwJjoMXJAJVh8l
         wqM+P+dUO/nhrXHANP3xNslOmtx+r4UZ/liGLkFRn+gxuGJKC0p/8bE8fLHvwfGP9bmu
         L6Yw==
X-Gm-Message-State: AOAM532BESlMBzD4EYzoLBtbGKWcmMDnw2B44F/tlvUHP0OMJXzWw/jA
        aK8PDKfH0o0GwzqW9UXtjJlxWA==
X-Google-Smtp-Source: ABdhPJxeSjRgYZMHzSWbNBum6+QgRSNLMUeyLP99yS84q++2Qmz+Pr18oxx1VuVkVBZwVk53X4csDg==
X-Received: by 2002:aa7:942d:0:b029:1f2:cbc6:8491 with SMTP id y13-20020aa7942d0000b02901f2cbc68491mr10125053pfo.53.1616715404666;
        Thu, 25 Mar 2021 16:36:44 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:1532:a374:78cc:c35c])
        by smtp.gmail.com with ESMTPSA id j3sm6263561pjf.36.2021.03.25.16.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 16:36:44 -0700 (PDT)
Date:   Thu, 25 Mar 2021 16:36:40 -0700
From:   Fangrui Song <maskray@google.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] scripts/recordmcount.pl: Fix RISC-V regex for clang
Message-ID: <20210325233640.jzi7uvaohvqwixiu@google.com>
References: <20210325223807.2423265-1-nathan@kernel.org>
 <20210325223807.2423265-2-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210325223807.2423265-2-nathan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-25, Nathan Chancellor wrote:
>Clang can generate R_RISCV_CALL_PLT relocations to _mcount:
>
>$ llvm-objdump -dr build/riscv/init/main.o | rg mcount
>                000000000000000e:  R_RISCV_CALL_PLT     _mcount
>                000000000000004e:  R_RISCV_CALL_PLT     _mcount
>
>After this, the __start_mcount_loc section is properly generated and
>function tracing still works.
>

R_RISCV_CALL_PLT can replace R_RISCV_CALL in all use cases.
R_RISCV_CALL can/may be deprecated:
https://github.com/ClangBuiltLinux/linux/issues/1331#issuecomment-802468296

Reviewed-by: Fangrui Song <maskray@google.com>


>Cc: stable@vger.kernel.org
>Link: https://github.com/ClangBuiltLinux/linux/issues/1331
>Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>---
> scripts/recordmcount.pl | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
>index 867860ea57da..a36df04cfa09 100755
>--- a/scripts/recordmcount.pl
>+++ b/scripts/recordmcount.pl
>@@ -392,7 +392,7 @@ if ($arch eq "x86_64") {
>     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
> } elsif ($arch eq "riscv") {
>     $function_regex = "^([0-9a-fA-F]+)\\s+<([^.0-9][0-9a-zA-Z_\\.]+)>:";
>-    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL\\s_mcount\$";
>+    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL(_PLT)?\\s_mcount\$";
>     $type = ".quad";
>     $alignment = 2;
> } elsif ($arch eq "nds32") {
>-- 
>2.31.0
>
>-- 
>You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20210325223807.2423265-2-nathan%40kernel.org.
