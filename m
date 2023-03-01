Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE066A7138
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCAQeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCAQeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:34:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A0748E02;
        Wed,  1 Mar 2023 08:33:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FA1161419;
        Wed,  1 Mar 2023 16:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A67C4339C;
        Wed,  1 Mar 2023 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688337;
        bh=ekrTEQ0q++a5WN0k+M9CsbiFIswHRa1ALpiUlb9/+Ss=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ERmXI7DGtKb9LcGMfEQ9/+M6ZnbmAUY0ZfJPVeSzg7W2ejlNRDuR+Efot3y4zi6Cg
         h8vho9xMiuJJt0oQd7H0XgLt1t/2SeqimD6w2w92PUnQuFZqBnqwVqvfs/7101Mi7W
         ZkpaNfjaJ3fBjHaTv+N0iD9o61AkcLtwrsPQXVPr0AgVN45boozfk0zcR5CnJJL99b
         8AzGg53PMt2miEMAnIGyXMA+Zq0zm7kqjlcDy1zQ78+US6TFbIN15nZ80SgbDBnW9C
         qwDFYG52tOc8I56gy3WyYn+KWQNrgkRy/NRhsZLoml3A6bSpqppm7wqqIs5idY14Bp
         R+yEc3WoxVEQA==
Received: by mail-lf1-f46.google.com with SMTP id s20so18354567lfb.11;
        Wed, 01 Mar 2023 08:32:16 -0800 (PST)
X-Gm-Message-State: AO0yUKWHYaXUnx3c8kQuOPdSCXChUd0VQcEufl2y2l9eimbjKGrbrnE0
        TH/ZPTJQBn78ivHBUK9ku/Asr0CEPIhrIg5W7G8=
X-Google-Smtp-Source: AK7set/M2Nfpk9X74vLkcmD7YCh7TktabSF9X0DWVKPaWKcauR+EAc/JbF2/DWvTlI/NjyV9vOKO0LPHdeObIXkiW4g=
X-Received: by 2002:ac2:5974:0:b0:4e2:337d:65d6 with SMTP id
 h20-20020ac25974000000b004e2337d65d6mr2039204lfp.7.1677688335107; Wed, 01 Mar
 2023 08:32:15 -0800 (PST)
MIME-Version: 1.0
References: <20230301163026.1303278-1-sashal@kernel.org> <20230301163026.1303278-2-sashal@kernel.org>
In-Reply-To: <20230301163026.1303278-2-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 1 Mar 2023 17:32:03 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEVXPaY4bM1R1gSvuANjz=xKjw1LtD0d9+BACbp5OUODA@mail.gmail.com>
Message-ID: <CAMj1kXEVXPaY4bM1R1gSvuANjz=xKjw1LtD0d9+BACbp5OUODA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 2/3] efi: efivars: prevent double registration
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Mar 2023 at 17:30, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Johan Hovold <johan+linaro@kernel.org>
>
> [ Upstream commit 0217a40d7ba6e71d7f3422fbe89b436e8ee7ece7 ]
>
> Add the missing sanity check to efivars_register() so that it is no
> longer possible to override an already registered set of efivar ops
> (without first deregistering them).
>
> This can help debug initialisation ordering issues where drivers have so
> far unknowingly been relying on overriding the generic ops.
>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

NAK this is not a bugfix.

> ---
>  drivers/firmware/efi/vars.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index e619ced030d52..462e88b9d2ba4 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -1195,19 +1195,28 @@ int efivars_register(struct efivars *efivars,
>                      const struct efivar_operations *ops,
>                      struct kobject *kobject)
>  {
> +       int rv;
> +
>         if (down_interruptible(&efivars_lock))
>                 return -EINTR;
>
> +       if (__efivars) {
> +               pr_warn("efivars already registered\n");
> +               rv = -EBUSY;
> +               goto out;
> +       }
> +
>         efivars->ops = ops;
>         efivars->kobject = kobject;
>
>         __efivars = efivars;
>
>         pr_info("Registered efivars operations\n");
> -
> +       rv = 0;
> +out:
>         up(&efivars_lock);
>
> -       return 0;
> +       return rv;
>  }
>  EXPORT_SYMBOL_GPL(efivars_register);
>
> --
> 2.39.2
>
