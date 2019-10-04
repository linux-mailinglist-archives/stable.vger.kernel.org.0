Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 283A7CC119
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 18:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbfJDQxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 12:53:09 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43817 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfJDQxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 12:53:09 -0400
Received: by mail-lf1-f68.google.com with SMTP id u3so4932863lfl.10
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 09:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xmm2BP8a9DWuDP+xds0k8TTHnrVyUujhwbGGQwiP4BU=;
        b=eXmEOfmog2EGekU7f6PlODmT8wkU1BJJwHVJjyillhE8vzFgDkJ/psUWheGVhia7JV
         UbbKj5qJD+z7tqKIFDLuguKIW4wE5mESUBF8Tn31nyynoCIy7mxChKbdwtBG8NclsAdk
         pT9e7uSJS8FK1k3lnsW2QtcdPrg3UdPesIjO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xmm2BP8a9DWuDP+xds0k8TTHnrVyUujhwbGGQwiP4BU=;
        b=sbTxQt+W/Eau0SlA+beXBUGhTq6o5YUhB4Gk+XFYbaHtTwt2M15r2Cx01iKH2G8eoV
         m7BXc6mk8y8hEzD/NCnqyWtzROnQ6sySJ7bXnysDjQ1wCNu4FXn+OOM3wEH/R8WNwl+J
         0BfxfP3byQ2TF/sBtixNt/y64mAlsqYLwKj4imcOGAkxgOhwCaVL1WCcky1UJJATuyGk
         dqPCcs2syrJoWapA8DWtRUfFMKD7yC5tJfy1tzRj/MWLjhAw2g6saIjw4p4OJuiTEty0
         X0CbiFtR07u3c1f9+kERcXyb9N58tNazC89b0j02YRV2loQYO5lrH1Hm2HVx+p1O/N2v
         ee/Q==
X-Gm-Message-State: APjAAAXXR+hmEDzQ23bm2v1dsbasFgKwww/JK1oLzFwdSThkZcUCiaoZ
        ckQC9m6XhlgPkdD7VbNVLREOWUlMSME=
X-Google-Smtp-Source: APXvYqw9puFVJKQVCONeqcYvmFJFyr1pCm2WuLwDWv7A9yjeT+EBTj6vzwlD0jRBs8/JELx4odE2Jg==
X-Received: by 2002:a19:c017:: with SMTP id q23mr9298302lff.174.1570207986934;
        Fri, 04 Oct 2019 09:53:06 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id t24sm1381668ljc.23.2019.10.04.09.53.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 09:53:06 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id d17so4956275lfa.7
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 09:53:05 -0700 (PDT)
X-Received: by 2002:a19:7d55:: with SMTP id y82mr9520991lfc.106.1570207985437;
 Fri, 04 Oct 2019 09:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191004140503.9817-1-christian.brauner@ubuntu.com> <20191004142748.GG26530@ZenIV.linux.org.uk>
In-Reply-To: <20191004142748.GG26530@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 4 Oct 2019 09:52:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wih7tK-PoRTSUXgarpgR-WA8kN_voiMynQr8eysvPPgfA@mail.gmail.com>
Message-ID: <CAHk-=wih7tK-PoRTSUXgarpgR-WA8kN_voiMynQr8eysvPPgfA@mail.gmail.com>
Subject: Re: [PATCH] devpts: Fix NULL pointer dereference in dcache_readdir()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Varad Gautam <vrd@amazon.de>, stable <stable@vger.kernel.org>,
        Jan Glauber <jglauber@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 4, 2019 at 7:27 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, vfs.git#fixes (or #next.dcache) ought to deal with that one.

Dang, I thought this already got merged. But we only discussed it
extensively and I guess it got delayed by all the discussions about
possible fixes for the d_lock contention.

Al, mind sending me that one - and honestly, I'd take the "cursors off
the list at the end" patch too. That may not be stable material, but I
still think it's going to help the d_lock contention at least
partially in practice.

               Linus
