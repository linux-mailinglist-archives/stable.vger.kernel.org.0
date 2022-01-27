Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E08D49DABC
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 07:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiA0Gce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 01:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiA0Gce (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 01:32:34 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE02C06173B
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 22:32:33 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id z7so2812672ljj.4
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 22:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hn+2ril8pqAtt7/6Z1JQegT9LE4NfpF4eSDSr3S6Kuo=;
        b=yoJPLJc6p/zsMhYPBqvSer6vmRAMjwQNpelLD881lDqdAZoCWvvHeuhX7VsG4Anrr2
         DjP/+uB17Zmdrwi8P1Saj3EWMVt1mtdfIZmuLItnEdy3r1BqDjQmEUrB68Bi6I/exOP2
         JPc9lVr1SJPoYJu2qt9Slhtavi8Zwga8kyMzzI78AAiGWVVPLdVgKbXSMc6+3qVzLIw1
         F70PYmZwnhEDsJbgV9tRs+fEJKOcp0ucB1muBDtoCsMA3WRcYqEHayBvqmGkBIRGVh/m
         dBPCH09XTcCIXzpCUnYp7knTdu/ZMReTbf69Q+dX8pScVcKpZMBKIhm2+H37fT0vuhYt
         bC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hn+2ril8pqAtt7/6Z1JQegT9LE4NfpF4eSDSr3S6Kuo=;
        b=XOWcmVMYIdSTzHozTddWx7e+zee2sNMRBlaKE/ty0G0WW9WS8NTBwd65AAUTjdC7Bg
         Gc9cMxVilvj5POWHfHoFGR+rNXoakID4zM7mNWjEeF+SGvN2/gmESrSdEi3ELCkjCqzh
         NuSbCEybXkaUBPKtV5qaBhxkLoLh0NhMMbyfhviqE22khu2dcNYOEOMDE0+d6qc3Lw6q
         azuTfyPfTmgcA+oATvr96MNQOQbL/YoGMzZDgjMwa/j9ULBr0nszpzFoYJUuNJpiGJnl
         nlFqYoGQbOYZ27SbGxLdO49DAQwZ/TPhva5DMdTuNpJZeVRv93HS+EoqmzQE28Nb7xUb
         goFg==
X-Gm-Message-State: AOAM533J44vGLLK7jd5XWQQUpRs0m5H+t+l1t8ps3RewOgRDugypDDJg
        ff6WHHpSJ9scQJRrjpyzhd7MgC9lbjBJciOvCbTu1Q==
X-Google-Smtp-Source: ABdhPJyMxVPHIEwyGfcRTB1wsGy3jRnjlmkwcLDAWwtPcJDFG8egBQZEUwGhYb2qEeY9RZ6tRP2GIF0MNLFb3L0UJQs=
X-Received: by 2002:a05:651c:1987:: with SMTP id bx7mr1916173ljb.136.1643265152075;
 Wed, 26 Jan 2022 22:32:32 -0800 (PST)
MIME-Version: 1.0
References: <20220125162938.838382-1-jens.wiklander@linaro.org> <20220125162938.838382-8-jens.wiklander@linaro.org>
In-Reply-To: <20220125162938.838382-8-jens.wiklander@linaro.org>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 27 Jan 2022 12:02:20 +0530
Message-ID: <CAFA6WYOLRqU4m5RJGJac9AtcpD7pt9Owd7D+XN8GjWRMAPBNuw@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] optee: use driver internal tee_contex for some rpc
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        David Howells <dhowells@redhat.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        stable@vger.kernel.org, Lars Persson <larper@axis.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Lars

Hi Jens,

On Tue, 25 Jan 2022 at 21:59, Jens Wiklander <jens.wiklander@linaro.org> wrote:
>
> Uses the new driver internal tee_context when allocating driver private
> shared memory. This decouples the shared memory object from its original
> tee_context. This is needed when the life time of such a memory
> allocation outlives the client tee_context.
>
> Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
> Cc: stable@vger.kernel.org
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
>  drivers/tee/optee/ffa_abi.c | 17 +++++++++--------
>  drivers/tee/optee/smc_abi.c |  7 ++++---
>  2 files changed, 13 insertions(+), 11 deletions(-)
>

As this commit fixes multiple issues seen earlier due to pre-allocated
SHM cache in client's context. I think it makes sense to separate this
as a standalone fix with few bits from patch #6 to target 5.17
release. As otherwise it will take a long path via 5.18 and then
backport to stable trees. In the meantime there can be other side
effects noticed similar to one from Lars.

-Sumit

> diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
> index 954e88866968..fb7345941024 100644
> --- a/drivers/tee/optee/ffa_abi.c
> +++ b/drivers/tee/optee/ffa_abi.c
> @@ -424,6 +424,7 @@ static struct tee_shm_pool *optee_ffa_shm_pool_alloc_pages(void)
>   */
>
>  static void handle_ffa_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
> +                                             struct optee *optee,
>                                               struct optee_msg_arg *arg)
>  {
>         struct tee_shm *shm;
> @@ -439,7 +440,8 @@ static void handle_ffa_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
>                 shm = optee_rpc_cmd_alloc_suppl(ctx, arg->params[0].u.value.b);
>                 break;
>         case OPTEE_RPC_SHM_TYPE_KERNEL:
> -               shm = tee_shm_alloc_priv_buf(ctx, arg->params[0].u.value.b);
> +               shm = tee_shm_alloc_priv_buf(optee->ctx,
> +                                            arg->params[0].u.value.b);
>                 break;
>         default:
>                 arg->ret = TEEC_ERROR_BAD_PARAMETERS;
> @@ -492,14 +494,13 @@ static void handle_ffa_rpc_func_cmd_shm_free(struct tee_context *ctx,
>  }
>
>  static void handle_ffa_rpc_func_cmd(struct tee_context *ctx,
> +                                   struct optee *optee,
>                                     struct optee_msg_arg *arg)
>  {
> -       struct optee *optee = tee_get_drvdata(ctx->teedev);
> -
>         arg->ret_origin = TEEC_ORIGIN_COMMS;
>         switch (arg->cmd) {
>         case OPTEE_RPC_CMD_SHM_ALLOC:
> -               handle_ffa_rpc_func_cmd_shm_alloc(ctx, arg);
> +               handle_ffa_rpc_func_cmd_shm_alloc(ctx, optee, arg);
>                 break;
>         case OPTEE_RPC_CMD_SHM_FREE:
>                 handle_ffa_rpc_func_cmd_shm_free(ctx, optee, arg);
> @@ -509,12 +510,12 @@ static void handle_ffa_rpc_func_cmd(struct tee_context *ctx,
>         }
>  }
>
> -static void optee_handle_ffa_rpc(struct tee_context *ctx, u32 cmd,
> -                                struct optee_msg_arg *arg)
> +static void optee_handle_ffa_rpc(struct tee_context *ctx, struct optee *optee,
> +                                u32 cmd, struct optee_msg_arg *arg)
>  {
>         switch (cmd) {
>         case OPTEE_FFA_YIELDING_CALL_RETURN_RPC_CMD:
> -               handle_ffa_rpc_func_cmd(ctx, arg);
> +               handle_ffa_rpc_func_cmd(ctx, optee, arg);
>                 break;
>         case OPTEE_FFA_YIELDING_CALL_RETURN_INTERRUPT:
>                 /* Interrupt delivered by now */
> @@ -581,7 +582,7 @@ static int optee_ffa_yielding_call(struct tee_context *ctx,
>                  * above.
>                  */
>                 cond_resched();
> -               optee_handle_ffa_rpc(ctx, data->data1, rpc_arg);
> +               optee_handle_ffa_rpc(ctx, optee, data->data1, rpc_arg);
>                 cmd = OPTEE_FFA_YIELDING_CALL_RESUME;
>                 data->data0 = cmd;
>                 data->data1 = 0;
> diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
> index b1082a34cda2..0dc383c974a3 100644
> --- a/drivers/tee/optee/smc_abi.c
> +++ b/drivers/tee/optee/smc_abi.c
> @@ -621,6 +621,7 @@ static void handle_rpc_func_cmd_shm_free(struct tee_context *ctx,
>  }
>
>  static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
> +                                         struct optee *optee,
>                                           struct optee_msg_arg *arg,
>                                           struct optee_call_ctx *call_ctx)
>  {
> @@ -650,7 +651,7 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
>                 shm = optee_rpc_cmd_alloc_suppl(ctx, sz);
>                 break;
>         case OPTEE_RPC_SHM_TYPE_KERNEL:
> -               shm = tee_shm_alloc_priv_buf(ctx, sz);
> +               shm = tee_shm_alloc_priv_buf(optee->ctx, sz);
>                 break;
>         default:
>                 arg->ret = TEEC_ERROR_BAD_PARAMETERS;
> @@ -746,7 +747,7 @@ static void handle_rpc_func_cmd(struct tee_context *ctx, struct optee *optee,
>         switch (arg->cmd) {
>         case OPTEE_RPC_CMD_SHM_ALLOC:
>                 free_pages_list(call_ctx);
> -               handle_rpc_func_cmd_shm_alloc(ctx, arg, call_ctx);
> +               handle_rpc_func_cmd_shm_alloc(ctx, optee, arg, call_ctx);
>                 break;
>         case OPTEE_RPC_CMD_SHM_FREE:
>                 handle_rpc_func_cmd_shm_free(ctx, arg);
> @@ -775,7 +776,7 @@ static void optee_handle_rpc(struct tee_context *ctx,
>
>         switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
>         case OPTEE_SMC_RPC_FUNC_ALLOC:
> -               shm = tee_shm_alloc_priv_buf(ctx, param->a1);
> +               shm = tee_shm_alloc_priv_buf(optee->ctx, param->a1);
>                 if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
>                         reg_pair_from_64(&param->a1, &param->a2, pa);
>                         reg_pair_from_64(&param->a4, &param->a5,
> --
> 2.31.1
>
