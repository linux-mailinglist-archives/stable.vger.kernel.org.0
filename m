Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDFB4A70F7
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 13:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbiBBMly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 07:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiBBMlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 07:41:53 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2703FC061714
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 04:41:53 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h21so38142682wrb.8
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 04:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w12hfnlUx4/pOCh1W8YlWAwS7+a2yvj3EoaEijgezAA=;
        b=Tu6DsDY6f0SCgtjaCV+etroECR6ZauaPdFYRPuXyo8S0p/A6A5HPN+Wso2VvjQ37l8
         JUw+p6YPwPOPW8nVTKYmcYsr64N8YsWsQi2Dxc/8Ia/9D4IgVYaSLCIl6TER8KwIufSY
         2mA6vE0lMwrflR1jlRwSKRo9a/zO1cyWztEejpzpfhxEvG+iZxDx49uguXSjEojeY7yP
         IPfFP/riy/lPcqSBKtEsZ4GH9k5x7/uzs0D+AS8jXoOwhnzYFuovMJTTln+v/NT1QCzY
         2AKxqeGy030ABeWZiumumlwg8eQQ72sP3aOiI07N4MdL40GmyZOtl6i5kweew/UOyMd0
         Lf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w12hfnlUx4/pOCh1W8YlWAwS7+a2yvj3EoaEijgezAA=;
        b=0zcVbx/7Qpai9ldstruueQEgF5Uw5LU+TE2Sth7l+8jHkakUc4Kc+Y7SzdFfvvemgC
         jMi80MDgkZTkhJV9tojz/57kzVMCeV2PRtiAUyzdxsHzyDHyzX4zaeV/K6HM8lfSr/NI
         pA/SMgaBvubwDulOCwmb+e4dymnQzjED/wImRXwb5oWDGvGfnpJ7ROoxFNFlA9SczhCr
         C+JtReDeQr1dfIqXSQgPDG3/9i+sdMQK3cenH7l5xY+6zbQ6hCpL/fgPpbIFbNG2zh2p
         9BwgDnFJ/KLihxp1wFUQ0FXAOFCp9dWxaJ8iiTPDbwy9tNmjsnUWuTp2TfLwr0rPHtof
         Lp+A==
X-Gm-Message-State: AOAM531tyj1wh92CRm0N+upHnolkhasnhY3GW0B//ILM5owpSLfh7qg1
        2rJ0rks6Bw2QMcC7VNhqCYkBzQ==
X-Google-Smtp-Source: ABdhPJzPvVXT7H31WWFqYWDpIQRnZRhuZ+64ysq1TgJQl7mPMweafbgxdMdWEGs9cIT/3aH8BgEhiQ==
X-Received: by 2002:a5d:4e81:: with SMTP id e1mr25500537wru.513.1643805711803;
        Wed, 02 Feb 2022 04:41:51 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:4fc2:8dd5:e6cc:1f2a])
        by smtp.gmail.com with ESMTPSA id a1sm17882833wrf.42.2022.02.02.04.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 04:41:51 -0800 (PST)
Date:   Wed, 2 Feb 2022 12:41:49 +0000
From:   Alessio Balsini <balsini@android.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Alessio Balsini <balsini@android.com>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, lee.jones@linaro.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 4.14] bpf: fix truncated jump targets on heavy expansions
Message-ID: <Yfp8DeOdtlyEGG1W@google.com>
References: <20220201170544.293476-1-balsini@android.com>
 <YfmHThlq0pv2TOjf@mussarela>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfmHThlq0pv2TOjf@mussarela>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thadeu,

On Tue, Feb 01, 2022 at 04:17:34PM -0300, Thadeu Lima de Souza Cascardo wrote:
> 
> Hi, Alessio.
> 
> This matches the backport I had prepared, but didn't manage to submit in time.
> 
> Thanks.
> Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> 

Argh! I wish I spotted your backport in the Ubuntu kernel patchworks
earlier. :)
I tested this change with LTP's bpf_map01 and bpf_prog[1-4].
Can we consider this ready for being queued up?

Thanks,
Alessio
