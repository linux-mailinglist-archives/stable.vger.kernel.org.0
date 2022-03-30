Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B7E4EBF94
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343528AbiC3LKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243071AbiC3LKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:10:01 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139FE13DDA
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:08:16 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id bi13-20020a05600c3d8d00b0038c2c33d8f3so980166wmb.4
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VXGNgRbX5zzXTfazB6dGH6LW7wWMhmUwmg/iheU3cUY=;
        b=E0yP/pJe81sE+7rJL82pO0PteXBegCXJNhm9FTqkE8dtUPrARA6Z002H5Obj5wSQor
         oVmxi7pd6YYAUQe+K6sDyYPW4DJ3m4P+yNe0Qoeh0IPS+YS/4oau3ZUQIqz+t/pEEfMh
         fvp+aiMPXQw8vLkSUf11IeKnCPQYhCOLZGPrr0rqqwNRbeHmNACYwQNIrIocU4hGpY0w
         ieLeUVXwzF+Yp9oPqZx6lYqYph78uXe4pR38OXG1/cDX2RdtjnlW6FLoZvn8+QyOSPg0
         7Jd7fcZzeyxkFxKrrU7jcddyFSC2Y79Yc9xVYEgA/ocrbLcmKl2P7reYU5BgRpVi2T+K
         w3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VXGNgRbX5zzXTfazB6dGH6LW7wWMhmUwmg/iheU3cUY=;
        b=qrceisjiuCDYwaShMmfpzcXIefA5fxv5yYIsTO8qVna121h6gDkcbUA4/J2v/iCsc2
         O39TNGYMp5UcRLKFoJaLJfJECrkNRAtTR/t0ckPVKbsAGJ+8US7dS+6cP5WZ+8pPpjQk
         LQoRDoI/qlObXPiKqQzw+F0LMPmSjqXB9XFY6CKvCi/3EJMqtothYPEtM0Qa2ITWkdFr
         wzdHvVRqX87qojAJWYgxM4QpaBK7P4wdgCjvsw8yp4UTGJH8+otiDmUbSNR9J62K+7eT
         LTqxTpOw6L1cCyejkx5DZp/D28NtAgbWR1+vHiHZlUBPFssxFp3gkH9i3VM6SRYbMl7S
         MQog==
X-Gm-Message-State: AOAM531iSb4kkBadJ67tNj4AYrm2VUUPrzuBYRp9X8lsrZpyk9+N5Acn
        j037hcG3RtLkRcvyptyA/66J9MsVG14r1w==
X-Google-Smtp-Source: ABdhPJzXuYhGPInWTClYbCyRzKKwLzDZ6QogdaeT06z1iH/a5fWcqzpAZ1FSLRL8TdbDgp7m7FAG3w==
X-Received: by 2002:a05:600c:1910:b0:38c:bff7:b9db with SMTP id j16-20020a05600c191000b0038cbff7b9dbmr3938613wmq.182.1648638494276;
        Wed, 30 Mar 2022 04:08:14 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id c5-20020a5d63c5000000b002040822b680sm24761119wrw.81.2022.03.30.04.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:08:13 -0700 (PDT)
Date:   Wed, 30 Mar 2022 12:08:12 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: Add a helper to validate the block size
Message-ID: <YkQ6HC/dsCiMTIyb@google.com>
References: <20220330110107.465728-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220330110107.465728-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Mar 2022, Lee Jones wrote:

> From: Xie Yongji <xieyongji@bytedance.com>
> 
> [ Upstream commit 570b1cac477643cbf01a45fa5d018430a1fddbce ]
> 
> There are some duplicated codes to validate the block
> size in block drivers. This limitation actually comes
> from block layer, so this patch tries to add a new block
> layer helper for that.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> Link: https://lore.kernel.org/r/20211026144015.188-2-xieyongji@bytedance.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/blkdev.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index d5338b9ee5502..8cc766743270f 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -59,6 +59,14 @@ struct blk_stat_callback;
>   */
>  #define BLKCG_MAX_POLS		5
>  
> +static inline int blk_validate_block_size(unsigned int bsize)
> +{
> +	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  typedef void (rq_end_io_fn)(struct request *, blk_status_t);
>  
>  /*

These 2 are for linux-5.4.y.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
