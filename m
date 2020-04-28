Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DF31BB344
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 03:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgD1BLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 21:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD1BLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 21:11:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A028EC03C1A8;
        Mon, 27 Apr 2020 18:11:37 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d184so9882585pfd.4;
        Mon, 27 Apr 2020 18:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iv9VG1ml9YtdubxTkSVKWnfhCAm26tdpMZmL56nVCYc=;
        b=en/JylFl8KERUCoB06g3lH9RTFt6u/pTLuDKe6cjSmoQ/jz0G8pmGFKwYMOT4X0fn3
         EEwjVaRfYwGFygNhQZNxFnWQ4y4K/g7TQwr9HCUw/YaW66/Yb44ptlT8uiXlxypxao6D
         3TE/MngCCXMHbpwafPDK9jg0BRrVuet52wxuH7uC/n2PUKW4AgpNT5F2nwrg2xSmVWlT
         ji7pfJhI8LHCfbV2mRBtMXEK0yM1yoKgwcA+S2NFJyYQgi52v88JaqEISqezul0Um9FO
         yrzvSZMH3W/YAyogV070gXVIo7aa3GqChkh7WZYanrXfTGbOE7BJQqdfOpq7bz6KJ8uP
         2PiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iv9VG1ml9YtdubxTkSVKWnfhCAm26tdpMZmL56nVCYc=;
        b=paimORPPK4KqHMQf2TILNf1p1RdM36kX9TfLErX9Y862pik1aK5VDw2DF9+f7RN727
         AoUanG/DFFB7yBAzPKyzwMCXDx6bZ+d4dsCGKNNIsLnysAe2wxakTra09PVymf5fjTGn
         sU2AyHElDWNWSwCzX5d28wVxewU16fdapfuE8QIv/dDKQWd06fFFN61ltXFaf2JDuQDG
         8MTd3y43O0LL/v4QJeFuItJl+vNcW6Ovsp3f0Cg+eLpycmetF9sdDV07Y20+CU710dhC
         OZYcfwxUrGVhB1l1ruXmaET+/Bm/VUB9gLCS+RZBZT+khWOBMpcDgASTQ+ynSVKwOqVK
         io3w==
X-Gm-Message-State: AGi0PuaiEg4ezBIVoy250MIulRdoUg2c2NWfJxauB2jfGcYxWKWCP4KL
        1moJNay8xvtFbuez150so+A=
X-Google-Smtp-Source: APiQypJB9eoHpfKd85W5XG6LcAJS6p+QLoEsa2/CGJqTZyMNhrDTGELNXXx6D+FPslZDHI2wzSjwmQ==
X-Received: by 2002:a63:4c08:: with SMTP id z8mr25135272pga.175.1588036296910;
        Mon, 27 Apr 2020 18:11:36 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3c2a:73a9:c2cf:7f45])
        by smtp.gmail.com with ESMTPSA id 138sm13429682pfz.31.2020.04.27.18.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 18:11:36 -0700 (PDT)
Date:   Mon, 27 Apr 2020 18:11:34 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Evan Green <evgreen@chromium.org>
Cc:     stable@vger.kernel.org,
        Nick Desaulniers <nick.desaulniers@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Andrew Duggan <aduggan@synaptics.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Enrico Weigelt <info@metux.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics-rmi4 - Really fix attn_data
 use-after-free
Message-ID: <20200428011134.GV125362@dtor-ws>
References: <20200427145537.1.Ic8f898e0147beeee2c005ee7b20f1aebdef1e7eb@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427145537.1.Ic8f898e0147beeee2c005ee7b20f1aebdef1e7eb@changeid>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 27, 2020 at 02:55:48PM -0700, Evan Green wrote:
> Fix a use-after-free noticed by running with KASAN enabled. If
> rmi_irq_fn() is run twice in a row, then rmi_f11_attention() (among
> others) will end up reading from drvdata->attn_data.data, which was
> freed and left dangling in rmi_irq_fn().
> 
> Commit 55edde9fff1a ("Input: synaptics-rmi4 - prevent UAF reported by
> KASAN") correctly identified and analyzed this bug. However the attempted
> fix only NULLed out a local variable, missing the fact that
> drvdata->attn_data is a struct, not a pointer.
> 
> NULL out the correct pointer in the driver data to prevent the attention
> functions from copying from it.
> 
> Fixes: 55edde9fff1a ("Input: synaptics-rmi4 - prevent UAF reported by KASAN")
> Fixes: b908d3cd812a ("Input: synaptics-rmi4 - allow to add attention data")
> 
> Signed-off-by: Evan Green <evgreen@chromium.org>
> 
> Cc: stable@vger.kernel.org
> Cc: Nick Desaulniers <nick.desaulniers@gmail.com>

Ugh, this is all kind of ugly, but I guess that's what we have now.
Applied, thank you.

> ---
> 
>  drivers/input/rmi4/rmi_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
> index 190b9974526bb..c18e1a25bca6e 100644
> --- a/drivers/input/rmi4/rmi_driver.c
> +++ b/drivers/input/rmi4/rmi_driver.c
> @@ -205,7 +205,7 @@ static irqreturn_t rmi_irq_fn(int irq, void *dev_id)
>  
>  	if (count) {
>  		kfree(attn_data.data);
> -		attn_data.data = NULL;
> +		drvdata->attn_data.data = NULL;
>  	}
>  
>  	if (!kfifo_is_empty(&drvdata->attn_fifo))
> -- 
> 2.24.1
> 

-- 
Dmitry
