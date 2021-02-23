Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A95B323191
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 20:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhBWTlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 14:41:16 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:41412 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbhBWTlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 14:41:12 -0500
Received: by mail-wr1-f50.google.com with SMTP id c7so7025522wru.8
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 11:40:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sns0MeQxWwav8lrRZ1YtEH+ncu6WHJJ5CzQoTX7IQn8=;
        b=V6YiG8DMB4AXYC+f7e/0DnVbCBrqt+M8u1aWrY2pUxeZ1cPYBCbSu12fu/0Lp6A4uz
         SjG/3HVZjshmz01hnDLTdm0hwM6hCYuSoqKP5nGgH91xecZHqMT37aA2KEoxbMSmOFlp
         QEWm4hZKW7Cg2ecklnM0YdP9XYNfK6HTnY2Z9fs1WHJtiZPznCraqsEa/8ROdkxG0+KO
         Gep27g/ZK0ITtBUkjhkxLXuQHhOOhJDlrriotNczGr/c4cXhcmCWfRPPP96uaoNIaP9I
         xiTEc/XVyLwbOs/Ut0btoD+S17DmyIGMKYZ34h8bxWa1XZBfdq6zmfpFJqfV9wJAIT3c
         w8Fw==
X-Gm-Message-State: AOAM532HwFw4cuCiabY3wNNObPy7ZpPXiROSk1r0oK/JNEAHklxzKmY1
        SEy6jPh93WQMRf0hROZ2F6k=
X-Google-Smtp-Source: ABdhPJw2kO99MyQhBFmwwOVdeQtUTiieSVx1G4g8al0ncg0nM0PcNXZoJ8qZrygGB8HBqP9aElXo8Q==
X-Received: by 2002:adf:e60a:: with SMTP id p10mr2683770wrm.291.1614109230300;
        Tue, 23 Feb 2021 11:40:30 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id j125sm3538982wmb.44.2021.02.23.11.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 11:40:29 -0800 (PST)
Date:   Tue, 23 Feb 2021 20:40:27 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/6] ASoC: samsung: tm2_wm5510: fix check of of_parse
 return value
Message-ID: <20210223194027.2efq23dxuwrbpqp2@kozik-lap>
References: <20210222213306.22654-1-pierre-louis.bossart@linux.intel.com>
 <20210222213306.22654-2-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210222213306.22654-2-pierre-louis.bossart@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 03:33:01PM -0600, Pierre-Louis Bossart wrote:
> cppcheck warning:
> 
> sound/soc/samsung/tm2_wm5110.c:605:6: style: Variable 'ret' is
> reassigned a value before the old one has been
> used. [redundantAssignment]
>  ret = devm_snd_soc_register_component(dev, &tm2_component,
>      ^
> sound/soc/samsung/tm2_wm5110.c:554:7: note: ret is assigned
>   ret = of_parse_phandle_with_args(dev->of_node, "i2s-controller",
>       ^
> sound/soc/samsung/tm2_wm5110.c:605:6: note: ret is overwritten
>  ret = devm_snd_soc_register_component(dev, &tm2_component,
>      ^
> 
> The args is a stack variable, so it could have junk (uninitialized)
> therefore args.np could have a non-NULL and random value even though
> property was missing. Later could trigger invalid pointer dereference.
> 
> This patch provides the correct fix, there's no need to check for
> args.np because args.np won't be initialized on errors.
> 
> Fixes: 75fa6833aef3 ("ASoC: samsung: tm2_wm5110: check of_parse return value")
> Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2board")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
