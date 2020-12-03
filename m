Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A59E2CDF5F
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 21:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbgLCUIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 15:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCUIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 15:08:46 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23ABC061A4E;
        Thu,  3 Dec 2020 12:08:05 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id x22so3787654wmc.5;
        Thu, 03 Dec 2020 12:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZM2r5b4lXD214hqcvABnHLyj4afHtDGMeqHleqjKQEY=;
        b=XF+VTW60xoaxj1ynZIO6ayG2xJUZSyqJ9G+m2MIWTgMwE37M/OElI+7YxX7z4gwnPC
         LRs7h3/Mcf31buwR9enp6hfoQJJcMOS8zKLvodFXe16n7HG2meE3PuxVFAsTJpaEkm07
         GhyevuC455rj+FpOcFiQLavfvgaFOHtK3iHpuZE2CV3g/53wsowhYXdz57Ptvcd/CYXb
         a8ht0TyMtRKzxGAj2J+Du8w5MjBjzIPapmAzYXakYgUSPmn1n3uxPFJEcZWQ9f7CIHmw
         leXnROQp+abYAgEUvZItw/0nUpbi5j7ni7BsSUA+AOpYz+TmihSuFKHZA2jqqXczpMTJ
         fq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZM2r5b4lXD214hqcvABnHLyj4afHtDGMeqHleqjKQEY=;
        b=oN8mSnruPACxTZvKeYOZieELYcDmUx8pUtanxK0d2gKdefu7StXGb/Kw5DEmMeMlzG
         3oXS33Tk/kCqh8uqsd2OlBev4yokcvQujPmtVeJa2/dkBPywZpD0Wflxx0TKLBslg+sf
         /s7KmYwiXH/axNdeGuvQtqGK+47maHyXuIk6N0G8xMGt8QG57O8wCQJ7hP1gAeTfW1m+
         97NeaWTlLpWHR+o+2bBDWUJhbebTx88KZ8hovq6u6UjpGVMjf37BeEY2oor5SmZ8++4b
         IdygX535UbeDDqsX0LKcRl8GiZa9ua6tzsmGWEjMrXqKP3eUnBzoXB3ivEcab6xE5Ide
         91VQ==
X-Gm-Message-State: AOAM531g5Li2+dVaGsr2LzDt0OGjjvv3aekV//ZVZDgvelgF071FhQyp
        UA7fLpI2AOU1al1jOykJiW54AsTzcA==
X-Google-Smtp-Source: ABdhPJzJXWK4gnYmR65ar+HasjjFJBTnlWLAN1DVHCrW76QDB6Rx2VUnt9ngzJXFk4NP3s2GLle9ZQ==
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr538783wmf.134.1607026084652;
        Thu, 03 Dec 2020 12:08:04 -0800 (PST)
Received: from localhost.localdomain ([46.53.251.73])
        by smtp.gmail.com with ESMTPSA id o203sm528538wmb.0.2020.12.03.12.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 12:08:03 -0800 (PST)
Date:   Thu, 3 Dec 2020 23:08:01 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        Alexander Viro <viro@ftp.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 05/10] proc: use %u for pid printing and slightly less
 stack
Message-ID: <20201203200801.GA3323724@localhost.localdomain>
References: <20201203183204.63759-1-wenyang@linux.alibaba.com>
 <20201203183204.63759-6-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201203183204.63759-6-wenyang@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 02:31:59AM +0800, Wen Yang wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> 
> [ Upstream commit e3912ac37e07a13c70675cd75020694de4841c74 ]
> 
> PROC_NUMBUF is 13 which is enough for "negative int + \n + \0".
> 
> However PIDs and TGIDs are never negative and newline is not a concern,
> so use just 10 per integer.
> 
> Link: http://lkml.kernel.org/r/20171120203005.GA27743@avx2
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Alexander Viro <viro@ftp.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: <stable@vger.kernel.org> # 4.9.x

A what? How does this belong to stable?
