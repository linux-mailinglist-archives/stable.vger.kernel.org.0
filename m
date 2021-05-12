Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27C137ED99
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387807AbhELUkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379137AbhELTSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:18:50 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0D1C061358;
        Wed, 12 May 2021 12:15:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g14so28401271edy.6;
        Wed, 12 May 2021 12:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Abiitb1gjpYOc5fE4sslTKMLhdObSvKxFOMEoYm7P2c=;
        b=PyAtDsTpzjMsXiCdFuCTC/A7LfgEe9WVPpqJX4dNc7lhvYPg+rC00sMvh/N0ljYh4a
         JcC6Un/z7NXqG9zcPb6k2pd98lliHuetm1c7sDUUHS/bylBKU3rSpNje6Wjs4vum9zcr
         TKRTYZBqeS48l/f08po56XXlfSVfe3s3bI07eEYY39DnNmmP22znmZCA8SvDSP8285Ub
         oBwjdH79+86MaRdfkIEoKd/wd2HpI6jA3PdjFi2cCwlWTVpcRFQkpKf2Cl+wt3H0enZl
         +TUvXYtBqBqwRb9djoDeNC9vr618oyrT+Z/QE3PxQJqtZbTjTsTe8JOVIOF1a8NzEYAe
         185Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=Abiitb1gjpYOc5fE4sslTKMLhdObSvKxFOMEoYm7P2c=;
        b=PWQfWEeH+j5EuLjQZMow1Y1ggiCpWv1eLkIyvOAHzEj3bLpx+Kt8/24vTcy+iuOFwm
         Jsno6xkOA7DweXpTR8/tXSg0FwfHi9oOGZQzr2DPF5P+EOrzR9nG84UTu4Vgx3uFZWmO
         VqbAyUZQ7qyP/BxGh9hINbE4bIf4kruZ6yl+VgbDM2r1/BAcOixeRjx92LUUMwrdwggN
         7kOT+tUklEVrnggEooVno3ETKTALpHWLtEqSw2Pgq0NzXxAyx+FMG5kNgEXUn4wn+uca
         tqfcWhAkAAa0Omf7nhRyIXM6bA7SEmLhtmJphDqjfVt9Q4khtyoiB3dCxdFUw2tcKqRu
         Nxtw==
X-Gm-Message-State: AOAM530+exT1kIagtLtQQOje1ICQxwHZsbh734kZH1ILOFTpM942+Xc8
        noQTIGiW2/7Hvxd3b/u0BR0=
X-Google-Smtp-Source: ABdhPJxKHE4B77rInpeA6gyqxxAPLgDGnTCIGF4ic7+B3W5zPICiW0m/2J7aoEGN0xTx7fP1eNq89g==
X-Received: by 2002:a05:6402:2550:: with SMTP id l16mr45471115edb.249.1620846934772;
        Wed, 12 May 2021 12:15:34 -0700 (PDT)
Received: from gmail.com (0526E777.dsl.pool.telekom.hu. [5.38.231.119])
        by smtp.gmail.com with ESMTPSA id q16sm558524edv.61.2021.05.12.12.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 12:15:34 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Wed, 12 May 2021 21:15:32 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Huang Rui <ray.huang@amd.com>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Nathan Fontenot <nathan.fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <YJwpVA2UHGBuag0w@gmail.com>
References: <20210425073451.2557394-1-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210425073451.2557394-1-ray.huang@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Huang Rui <ray.huang@amd.com> wrote:

> Some AMD Ryzen generations has different calculation method on maximum
> perf. 255 is not for all asics, some specific generations should use 166
> as the maximum perf. Otherwise, it will report incorrect frequency value
> like below:
> 
> ~ → lscpu | grep MHz
> CPU MHz:                         3400.000
> CPU max MHz:                     7228.3198
> CPU min MHz:                     2200.0000

It would have been useful to also quote the 'after' part.

> +u32 amd_get_highest_perf(void)
> +{
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +
> +	if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> +			       (c->x86_model >= 0x70 && c->x86_model < 0x80)))
> +	    return 166;
> +
> +	if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> +			       (c->x86_model >= 0x40 && c->x86_model < 0x70)))
> +	    return 166;

I fixed these stray 4-space tabs.

Looks good otherwise - queued up in tip:sched/urgent.

Thanks,

	Ingo
