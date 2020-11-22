Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F622BC67F
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 16:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgKVPcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 10:32:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44433 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbgKVPcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 10:32:45 -0500
Received: from mail-ej1-f69.google.com ([209.85.218.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1kgrM3-0007SM-0Y
        for stable@vger.kernel.org; Sun, 22 Nov 2020 15:32:43 +0000
Received: by mail-ej1-f69.google.com with SMTP id q2so4855844ejj.16
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 07:32:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g9evwnH39CJFfcj3FvZu2zi+TDnPYv0kuormvhxYBAA=;
        b=Y78TOAJ8blTnY1mSQAoNEHekUjLmZQrZLk6PR6vJnIg4Gstcmu+4n6oZurmnL5I3jA
         +zHJcCSLLDBA+vPxsuM5tPEQowHEDEFnOYwwVAM7fcO64QF4wx4q3qbDYfv2BhwzCPYW
         XtQGoN+x8mDYRR+kCxs3YjgRWdYQbX6x7A4SnZS2pNNoEj+AIx7+FTiArHiTN9cBbAwR
         0oPZV3B2f83Y5+egqU8Ps2Rq9SPsOQU+o/iaB+3F405Hps5XhRyuth9XeBRA1PC+jmnO
         ECGk65FH/VWF+e/NcB5JNgvAPzUCjzy6Ca8QIW8Cot+WamYM8lolB/Y6r/l5Bor3osvt
         q6YQ==
X-Gm-Message-State: AOAM531dOyCD5iR665m68NpgYMgV6Zzc070muB+10/wVSOfH8dHgY+Bj
        cS7vIDp3RI+RlanaDkEitWVZF/vdc2P0sVQLhiXvCu9/JJQNDNl/I0+6bkEhjWkMwq7YYwCULGD
        XRmBtfT7DME1i7uhnRbct5SfC592WgYbSUtoKP0UpFh1PFYkVXQ==
X-Received: by 2002:a17:906:c244:: with SMTP id bl4mr19269105ejb.430.1606059162568;
        Sun, 22 Nov 2020 07:32:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnEWK3w+i2158MoX6RM4KiZ/7sCV4gPqKTsqAdtmrUEEmnYH/vrzA+/LOucs/sVWiFMzq0TUHBOTV4uu1By1Y=
X-Received: by 2002:a17:906:c244:: with SMTP id bl4mr19269067ejb.430.1606059162349;
 Sun, 22 Nov 2020 07:32:42 -0800 (PST)
MIME-Version: 1.0
References: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
 <CACPcB9e8p5Ayw15aOe5ZNPOa7MF3+pzPdcaZgTc_E_TZYkgD6Q@mail.gmail.com>
 <AC36B9BC-654C-4FC1-8EA3-94B986639F1E@oracle.com> <CACPcB9d7kU1TYaF-g2GH16Wg=hrQu71sGDoC8uMFFMc6oW_duQ@mail.gmail.com>
In-Reply-To: <CACPcB9d7kU1TYaF-g2GH16Wg=hrQu71sGDoC8uMFFMc6oW_duQ@mail.gmail.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Sun, 22 Nov 2020 12:32:06 -0300
Message-ID: <CAHD1Q_yB1B4gu7EDqbZJ5dxAAkr-dVKa9yRDK-tE3oLeTTmLJQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86
 and ARM
To:     Kairui Song <kasong@redhat.com>, Dave Young <dyoung@redhat.com>
Cc:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, Baoquan He <bhe@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kexec mailing list <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        =?UTF-8?Q?Diego_Elio_Petten=C3=B2?= <flameeyes@flameeyes.com>,
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dave and Kairui, thanks for your responses! OK, if that makes sense
to you I'm fine with it. I'd just recommend to test recent kernels in
multiple distros with the minimum "range" to see if 64M is enough for
crashkernel, maybe we'd need to bump that.
Cheers,


Guilherme
