Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1057E4C21CA
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 03:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiBXCle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 21:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiBXCld (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 21:41:33 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18006187E2A;
        Wed, 23 Feb 2022 18:41:03 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so816698pja.1;
        Wed, 23 Feb 2022 18:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=EyCz/npgrvK3wpbga7/cyV5B/USjVvhtf8rmko5Ci44=;
        b=OJgUqWsSYFDXMW2sk/xBn7Dewz4VOyeBPLsINElsaZ7NKuWAfaIWyYvNOn1xtvm3Lf
         3eI5xv7A8DlDwu6OWAaMZJLYOOsUQxo5n87KDSpotcAoO45Omd4/8+zfyx7i6G31kJYy
         j8CXnXG1MEeNqivSFTyvFeqMS7pE+/cTSh9Pssv52IFjnpcWFYG8MAairObWsYJMcSt2
         QTal643N9GTg4iBzl6GxbpOk2e9nX3o0+WHR1P6eWo307dlaAEYfZ2tYGpHG+JsscMw7
         PDYKuSH6XpHiUxNwq1epytPAVW+feSZtv2GFfeesftXhaHQRyAodhpl8b6x44k3iQ/ao
         pYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=EyCz/npgrvK3wpbga7/cyV5B/USjVvhtf8rmko5Ci44=;
        b=sCjvtQQd0fNqhMKw7uAa5s391qbhODnyeplgaBaJ7r5vKsUdhM/FVlAyxfAdQoDixe
         ucV7OnzJDUrJEHlSD6dVH7nMCFDxs945SqGgBcC1yPmqfLeV3RvBJ8ubxJp3PpPO9mK0
         7SQU/TMUV5hineo5A80QbfU9rirb3JcIRYlCmTdwu7RbIJJy3Zhz5VoEx7xCQCe7euvY
         Ab8ycwkdtLUCdVne6cxQVCzIDgbm7hm7A2zqTTvJg8/E/Jb1tPAMz7cDe/yg0qPNQlPa
         D6EgsdfH9XXI25n0AtL/fF21/Kudbi84z9kwCRiagTXXzfOW4EOhMOPnOVIKCJOfTcZm
         odPA==
X-Gm-Message-State: AOAM532KZzskAn+7q73Fx/feale2IFwg8A61Gj7NPboP3zm7RFanUkp9
        Gr/IWQ4KqeQEGwTo/j7r3tstDPzridY=
X-Google-Smtp-Source: ABdhPJzLyhj73Fo6tspeW72DSqxDKpnxx2XzGLuzmSvGZw8cXuc6R3oLeUpxJPFg8bAMvJnoBz67RQ==
X-Received: by 2002:a17:90a:aa98:b0:1b8:5adb:e35f with SMTP id l24-20020a17090aaa9800b001b85adbe35fmr612568pjq.192.1645670462502;
        Wed, 23 Feb 2022 18:41:02 -0800 (PST)
Received: from localhost (115-64-212-59.static.tpgi.com.au. [115.64.212.59])
        by smtp.gmail.com with ESMTPSA id j5sm882941pfu.185.2022.02.23.18.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 18:41:02 -0800 (PST)
Date:   Thu, 24 Feb 2022 12:40:57 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/3] powerpc: lib: sstep: fix 'sthcx' instruction
To:     Anders Roxell <anders.roxell@linaro.org>, mpe@ellerman.id.au
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
In-Reply-To: <20220223135820.2252470-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Message-Id: <1645670438.z6ynuisobl.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Anders Roxell's message of February 23, 2022 11:58 pm:
> Looks like there been a copy paste mistake when added the instruction
> 'stbcx' twice and one was probably meant to be 'sthcx'.
> Changing to 'sthcx' from 'stbcx'.
>=20
> Cc: <stable@vger.kernel.org> # v4.13+
> Fixes: 350779a29f11 ("powerpc: Handle most loads and stores in instructio=
n emulation code")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Good catch.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/lib/sstep.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
> index bd3734d5be89..d2d29243fa6d 100644
> --- a/arch/powerpc/lib/sstep.c
> +++ b/arch/powerpc/lib/sstep.c
> @@ -3389,7 +3389,7 @@ int emulate_loadstore(struct pt_regs *regs, struct =
instruction_op *op)
>  			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
>  			break;
>  		case 2:
> -			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
> +			__put_user_asmx(op->val, ea, err, "sthcx.", cr);
>  			break;
>  #endif
>  		case 4:
> --=20
> 2.34.1
>=20
>=20
