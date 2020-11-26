Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8572C5CA0
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 20:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733047AbgKZTdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 14:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgKZTdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 14:33:36 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1B1C0613D4;
        Thu, 26 Nov 2020 11:33:35 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id t22so3510229ljk.0;
        Thu, 26 Nov 2020 11:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Gz+M9IfD+qGLBaMKNLa97bF26clyC9BCzo6sAtKUI8=;
        b=jgPQcCxNavgwQSFkaOL1RzAPSSbAWhb5D8LceQW6OTW12eBdjZr7dd+SB8bH8qYxD1
         c8ZTcL+5TfOi5pljot/npbolUrPbA6MHR+fAPBPi2JubA+n100BaC2ZpIWizKW91wDFZ
         /NkpWbXRb3VcRPDv0j3qen8+mVmrGCFhSmUiv4sP6QFMIyCybUnIALR56kfpTj1DgGlv
         bQ5nNYDnNX+L1ZgdgBKkw1ywD6akayuMYDw1KHZ2muoQpbE6ybxtPmRJ/sVjY6hiVYX7
         ISADAXqsnlH2rQB9cbeY+VNOZZXgnnQ3NFsj4SfoTl8VX+ufd9t0QoyufpOlkTzjFXxU
         SxSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Gz+M9IfD+qGLBaMKNLa97bF26clyC9BCzo6sAtKUI8=;
        b=ohcOhTpP125esbcRXRVUqCpp8l11mNsnVrHXQ9vIdx+BhJE8X4/phqY8UuS8mOpA6j
         IQIZJA+y4qnuubvNKddbI8ZwwJOYq5UrT+DxtspXgLa1EG3yHyDQv8Q83KQjEybJuLph
         e+8jE85pjwyh7ekVwzcHTaE/MeeNTPMZm4oiDS5vNlcc/EEzdZ0XyREde9FEiZHxQRTs
         Zbx8Jf3SvkLMCWLQaN5ptMwk2VHEuKF4DndZh+xmNQcqhQViUv0qEiLSdqB0TLviukb4
         UarNft7b7JT59EYvSucD0mCNmajXL5zNyOrMH6pVGOYHihTi9A3h7SfO5x1qdPjnyEx7
         YDNQ==
X-Gm-Message-State: AOAM531+PuLC7kLf3M9CF8MFZv1DzoebJHSfaU7hl8mBI+/VIeAdg2lU
        kK4KQyOMlpg9DXqCtvVgmUdp7vU+EpHLag==
X-Google-Smtp-Source: ABdhPJwJLck7QX/0Y/7/+O4AocTsS9qJNaemJ9an7USw23rpqW9T4yoSV3EC9/d4FOSUyoJlRAGntg==
X-Received: by 2002:a2e:8745:: with SMTP id q5mr1819437ljj.347.1606419213990;
        Thu, 26 Nov 2020 11:33:33 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:4282:4e35:1b33:42ef:d169:a655? ([2a00:1fa0:4282:4e35:1b33:42ef:d169:a655])
        by smtp.gmail.com with ESMTPSA id f26sm417449lfl.159.2020.11.26.11.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 11:33:33 -0800 (PST)
Subject: Re: [PATCH v2 2/5] memory: renesas-rpc-if: Fix unbalanced
 pm_runtime_enable in rpcif_{enable,disable}_rpm
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-renesas-soc@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>, stable@vger.kernel.org
References: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20201126191146.8753-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <0d051546-4c91-8f2b-f189-5bd8848a9f69@gmail.com>
Date:   Thu, 26 Nov 2020 22:33:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201126191146.8753-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/26/20 10:11 PM, Lad Prabhakar wrote:

> rpcif_enable_rpm calls pm_runtime_enable, so rpcif_disable_rpm needs to
> call pm_runtime_disable and not pm_runtime_put_sync.
> 
> Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
> Reported-by: Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>

   Reported by reported? :-)

> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]

MBR, Sergei
