Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64819139A49
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 20:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgAMTor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 14:44:47 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:35592 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgAMToq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 14:44:46 -0500
Received: by mail-lj1-f169.google.com with SMTP id j1so11491324lja.2
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 11:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wPAvecB831XwECXLNHT/jipdJ8QCTyIHynNy8tewQr4=;
        b=FK0vItQAusk78N59VNKD5q6yeGqREAJio/AJqlKLNDwM1HMi9cvpnSNBm4zX3mh+ce
         7RXDwy4PHImlGjWKKoyeDH13SoA8NaJMAIEvXv3vHkgB93VujlAZhkGJOUJSQrNxvDxs
         8UBoCzWU2Dt7Re03GPBHR2VRz7rgkGuTbXhR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wPAvecB831XwECXLNHT/jipdJ8QCTyIHynNy8tewQr4=;
        b=kAQHJOPRR+BsWCURg12VfB9b6Zf2q0W1MToIagJZVMbdLjw1olkVsJv6H9KPnP7th9
         +Yyq6B7zg0haQJgxrSM93TdEcBz4Q1w15KXUvoMUPC1P4J+4LOM/ZZtrlCzeY4/LVe4y
         f6o0DlAiqNgpDGdGiKA/feMEjWYBd8b5ClSGk0dNhe8NHs2uVDW35HyxadMsFdZR2Lng
         PrHCJygNlhNqDXm16jJ1GETZLLg1OqzvSkVzTiXdakinKuR00AawmWrssrnalpTUxIvq
         wB5yfIvKh8Q2GGbMbt04qOFxwYCE1Mx9alOsI3NbkY0a218y2qtfq4oCC3dfIOR4i+TF
         Ijsw==
X-Gm-Message-State: APjAAAXd73u6L3Hxp8s4pzNokMMLAh4C6avEjsmvbQVIkfR2XdHaspae
        lDJGrVjd/45dWdvA9zPVPrlS5mAGDFk=
X-Google-Smtp-Source: APXvYqywjVz6BVystJKGjMAxNy/gLKG6XoorZSexp11sJJBHFpuDhxFldK/fQbMgpF1AHSwCtXMiTg==
X-Received: by 2002:a2e:7a13:: with SMTP id v19mr11887297ljc.43.1578944683245;
        Mon, 13 Jan 2020 11:44:43 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id b1sm7339348ljp.72.2020.01.13.11.44.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 11:44:42 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id y1so7802620lfb.6
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 11:44:42 -0800 (PST)
X-Received: by 2002:a19:22cc:: with SMTP id i195mr10887464lfi.148.1578944681789;
 Mon, 13 Jan 2020 11:44:41 -0800 (PST)
MIME-Version: 1.0
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <20200113154739.GB11244@42.do-not-panic.com>
In-Reply-To: <20200113154739.GB11244@42.do-not-panic.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 13 Jan 2020 11:44:25 -0800
X-Gmail-Original-Message-ID: <CAHk-=wja2GChi_JBu0xBkQ96mqXC3TMKUp=YvRhgPy0+1m5YNw@mail.gmail.com>
Message-ID: <CAHk-=wja2GChi_JBu0xBkQ96mqXC3TMKUp=YvRhgPy0+1m5YNw@mail.gmail.com>
Subject: Re: Fix built-in early-load Intel microcode alignment
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Jari Ruusu <jari.ruusu@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>, johannes.berg@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 7:47 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> So I'd like to determine first if we really need this. Then if so,
> either add a new global config option, and worst comes to worst
> figure out a way to do it per driver. I don't think we'd need it
> per driver.

I really don't think we need to have a config option for some small
alignment. Increasing the alignment unconditionally to 16 bytes won't
hurt anybody.

Now, whether there might be other firmware loaders that need even more
alignment, that might be an interesting question, and if such an
alignment would be _huge_ we might want to worry about actual memory
waste.

But 16-byte alignment for a fw blob? That's nothing.

                Linus
