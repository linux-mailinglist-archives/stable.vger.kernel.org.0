Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD7B2CEF32
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 15:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbgLDODD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 09:03:03 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40584 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbgLDODD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 09:03:03 -0500
Received: by mail-lj1-f194.google.com with SMTP id y10so6726597ljc.7;
        Fri, 04 Dec 2020 06:02:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SzMGLrWLNHR2uzHXkA7fVFrIiRthHhSpOA3S/SFE9xY=;
        b=TzUjj/BpaZfivNUeAp7DAG1igfiRj5tHGg5seiN6pCpGZkRlVcT5ZFXJKVFoDwCwkk
         6UxTkP5ZJd5zcAk075mbpjnP6tq0Fs992sdW8izzbu99pz/GSyksSXFGJAJPfJ+PktMq
         094Y4l2Lh2Kb7WCvbnxdoDfASju6yGjA+/YBSMhPzPo/7oUjZNVXMNE7XiCUyvbmauO+
         hEJVT5OSH5PiZBe7kA2WFirXvVbRI3pSDAKwvgQ8LA05SRNHg8uZIKh/85cHsyqInmY0
         +RyTIu9efPdgQFJS9WqnB3PEVXqQNqYpeLxAEQ9VE1Uck4G93elfrnpz4Y/UxaMSX94J
         l9cw==
X-Gm-Message-State: AOAM530olr8BrLUT2/YkFKavRDKPF8JRFl5DTIJTBZotoFCRYpV6O19R
        wf0bfSmxYEfufIs6jE2MfDc=
X-Google-Smtp-Source: ABdhPJzinbl8W6GNnuh2d0iNrH45Uu5Od1aTjnKkRJ/b/Lo8Z2zvuOe5aiVnx94/T6QOmdOgJLSiFA==
X-Received: by 2002:a2e:5853:: with SMTP id x19mr3739427ljd.232.1607090540012;
        Fri, 04 Dec 2020 06:02:20 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id r141sm1684042lff.55.2020.12.04.06.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 06:02:19 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1klBfh-0004K0-Ao; Fri, 04 Dec 2020 15:02:53 +0100
Date:   Fri, 4 Dec 2020 15:02:53 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Frank Rowand <frowand.list@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        linux-arch@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/8] of: fix linker-section match-table corruption
Message-ID: <X8pBjbZlbaWaOFxe@localhost>
References: <20201123102319.8090-1-johan@kernel.org>
 <20201123102319.8090-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123102319.8090-2-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rob,

On Mon, Nov 23, 2020 at 11:23:12AM +0100, Johan Hovold wrote:
> Specify type alignment when declaring linker-section match-table entries
> to prevent gcc from increasing alignment and corrupting the various
> tables with padding (e.g. timers, irqchips, clocks, reserved memory).
> 
> This is specifically needed on x86 where gcc (typically) aligns larger
> objects like struct of_device_id with static extent on 32-byte
> boundaries which at best prevents matching on anything but the first
> entry. Specifying alignment when declaring variables suppresses this
> optimisation.
> 
> Here's a 64-bit example where all entries are corrupt as 16 bytes of
> padding has been inserted before the first entry:
> 
> 	ffffffff8266b4b0 D __clk_of_table
> 	ffffffff8266b4c0 d __of_table_fixed_factor_clk
> 	ffffffff8266b5a0 d __of_table_fixed_clk
> 	ffffffff8266b680 d __clk_of_table_sentinel
> 
> And here's a 32-bit example where the 8-byte-aligned table happens to be
> placed on a 32-byte boundary so that all but the first entry are corrupt
> due to the 28 bytes of padding inserted between entries:
> 
> 	812b3ec0 D __irqchip_of_table
> 	812b3ec0 d __of_table_irqchip1
> 	812b3fa0 d __of_table_irqchip2
> 	812b4080 d __of_table_irqchip3
> 	812b4160 d irqchip_of_match_end
> 
> Verified on x86 using gcc-9.3 and gcc-4.9 (which uses 64-byte
> alignment), and on arm using gcc-7.2.
> 
> Note that there are no in-tree users of these tables on x86 currently
> (even if they are included in the image).
> 
> Fixes: 54196ccbe0ba ("of: consolidate linker section OF match table declarations")
> Fixes: f6e916b82022 ("irqchip: add basic infrastructure")
> Cc: stable <stable@vger.kernel.org>     # 3.9
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---

Could you pick this one up for 5.11?

Johan
