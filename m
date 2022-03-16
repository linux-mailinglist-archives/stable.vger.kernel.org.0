Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C814DB5EC
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357459AbiCPQTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357477AbiCPQTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:19:41 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57988237ED
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:18:21 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso1698769wmz.4
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=A+59yFsYVoDK+at5g7PvFGFDwqhNlmSfcoynwM/AfCw=;
        b=t4W4+rEBdAZOfy5a/oTq9bvr6aR6ef24myKd+Lzw4J1JrH03ZpjPcrFjQsXfupZ9Bl
         ywkeRHKrunCqq98zyxSr2U8yrXNxHetS7vxzQP/+eMK+Pu81/3eNedR66dbmzdfyqRMO
         GiyfwrOtDF65nxUngwTdjqPL4oO4ENsjwPlW8F+wMbkll/qSg8PrAQYcLZrTyndghdQN
         0ShN254evo9Smd4rkXnD/I8s09s2fTS210LEJsbl4pAa2ZOd9xUY/D3Pl9IKh43b3/8L
         AeVmilqyp3WJdQSJD9EmobfXSlbxyUW3BHsw0geBck693102T4CaHgle8I4hqsPSviut
         D7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=A+59yFsYVoDK+at5g7PvFGFDwqhNlmSfcoynwM/AfCw=;
        b=fiy48f9O5NiCAFRvvmEBv3hSXN4H2XO4LXQN9VenHE+tzPASsfIRWrWh45GvI1SSnQ
         dxp+ikB2PPCz5ahRvqiVQY2JNTl4sXyjunE8QSBIe8Ci/atZofGyU9foPASPniRRhEw1
         IRY3/m3u98hkge++pJ5cKYM2eTDDegqpe/wboiEWRNcsynFx0dFvF7ZbibVApftNNdH/
         AtcOdi2XcqS1uuxRCOiir7PlGhhu64eiK8+MXJIRDa5L+1E7Bx+wflOWUoBX3Za9M1og
         yerKrmtE9XKnxbpdQq7VEc3ThB9iCZQ4fKHoo7N2WO/weuho272zPPg3WhXoIeQaIqr2
         JHOA==
X-Gm-Message-State: AOAM533mRcJoI5EzKmUPlNcRLKsI6RCO3HtJ5f3M93JTNC+bzixXPFo9
        r/RXs3XJpwIx4Hx4tfxEOLPVgdZEP1p+vg==
X-Google-Smtp-Source: ABdhPJxZplXaKqtlacyb/vCEKzev5Rge+fc9+IWR79ChHZDyrVbAJByWIm6Cl2Q/Vh66bHbDPTOD6Q==
X-Received: by 2002:a05:600c:1ca6:b0:389:ab9a:b040 with SMTP id k38-20020a05600c1ca600b00389ab9ab040mr359701wms.111.1647447499772;
        Wed, 16 Mar 2022 09:18:19 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id f22-20020a1cc916000000b00380d3e49e89sm2005319wmb.22.2022.03.16.09.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 09:18:19 -0700 (PDT)
Date:   Wed, 16 Mar 2022 16:18:16 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: return back safer resurrect
Message-ID: <YjINyFwcvPs+a8uq@google.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
 <7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable Team,

> Revert of revert of "io_uring: wait potential ->release() on resurrect",
> which adds a helper for resurrect not racing completion reinit, as was
> removed because of a strange bug with no clear root or link to the
> patch.
> 
> Was improved, instead of rcu_synchronize(), just wait_for_completion()
> because we're at 0 refs and it will happen very shortly. Specifically
> use non-interruptible version to ignore all pending signals that may
> have ended prior interruptible wait.
> 
> This reverts commit cb5e1b81304e089ee3ca948db4d29f71902eb575.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)

Please back-port this as far as it will apply.

Definitely through v5.10.y.

It solves a critical bug.

Subject: "io_uring: return back safer resurrect"

Upstream commit:: f70865db5ff35f5ed0c7e9ef63e7cca3d4947f04

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
