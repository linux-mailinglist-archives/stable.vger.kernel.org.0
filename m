Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72A2449AE0
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 18:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240722AbhKHRlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 12:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbhKHRlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 12:41:13 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F0EC061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 09:38:28 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so65044800edz.2
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 09:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JTGgAXnMTwt/K4mnzOi+SzlfvHmh4Tm6eD79URpaTGw=;
        b=QQZO9ZJ5F1dX16Idd6+ZOJigiZJUz4I5EIHN0VbLBcbwM6R0n/AS7cpWC8tgF55mcj
         nW/7rdpjotzDq2ID60mPSLTq9WJGe5RfCpJOunXlmeRjNRPLe3kkKYbJdOpPOvj4VHo8
         2MFnlNA0euK2g7HYa97MOWegOpKgawiWfIv0/JUcL+E71A+eNLZafk20a4YD4heAqbLA
         OVY3cq9Fln6ZtB5AnpUYWiq1ieS/hLYOXFipupOIQFeXdLZtUMWNYemjkU0+8ytog68M
         dP9cfbpTQCbScnsGe7cmIXPuo7i5pZAr5oIk4A1ZcDQiXH6HHCzhYIN++gtIjRUvtYf2
         XiNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JTGgAXnMTwt/K4mnzOi+SzlfvHmh4Tm6eD79URpaTGw=;
        b=Wb60fhihhOzQL20UgZ1l5VdvHt+mksFEdtqZDBHkQZsOsh85wS0YVOk7HGMOtf+3BM
         w9Sygu2QbPo7EKvkkWZg9keQDRtzgZrhJs/w0dGP4SVX4iVJ4rOU/TFBhqSopg2BAlmG
         wC3nvTbgYh3oBSBQALDDZr3dtMlvQuNV39pXCOHutB3uXvVvu4K553v/Fh5qOtHAuhOy
         FxBKAtthl8KZhD3cNTTo0HMUrOpRA3SMHIA43OvOh7E/KDtxokYjsF1/thz9o8lHUqUp
         VYkOJlfb5Ir1hEoaAqYeUR5w/FJdWHTjGDZpgD0YKUMOgDra/7qc2b/bYuS2Ze/RXHkV
         U9Og==
X-Gm-Message-State: AOAM531sh5ErcpJJiqh89ofwLa3ThdSTxaje2yauBH3YuDTT0GjpPOeF
        7k1xCayM+/LsSH/AZVCT9q1/Lw8OeovWGxRsnRvBzyzzedi+jw==
X-Google-Smtp-Source: ABdhPJwXOtPIM3Ff22fSFsPTjlk/jwA2crG8sllFkY5vkBQVxobNVMHBe993fkh/cOOArDymY69A4dOUNnDXyJE05dk=
X-Received: by 2002:a17:906:7b42:: with SMTP id n2mr1212737ejo.428.1636393107032;
 Mon, 08 Nov 2021 09:38:27 -0800 (PST)
MIME-Version: 1.0
From:   Brian Geffon <bgeffon@google.com>
Date:   Mon, 8 Nov 2021 12:37:51 -0500
Message-ID: <CADyq12yY25-LS8cV5LY-C=6_0HLPVZbSJCKtCDJm+wyHQSeVTg@mail.gmail.com>
Subject: XSAVE / RDPKRU on Intel 11th Gen Core CPUs
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Guenter Roeck <groeck@google.com>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

We (ChromeOS) have run into an issue which we believe is related to
the following errata on 11th Gen Intel Core CPUs:

"TGL034 A SYSENTER FOLLOWING AN XSAVE OR A VZEROALL MAY LEAD TO
UNEXPECTED SYSTEM BEHAVIOR" [1]

Essentially we notice that the value returned by a RDPKRU instruction
will flip after some amount of time when running on kernels earlier
than 5.14. I have a simple repro that can be used [2].

After a little digging it appears a lot of work was done to refactor
that code and I bisected to the following commit which fixes the
issue:

  commit 954436989cc550dd91aab98363240c9c0a4b7e23
  Author: Thomas Gleixner <tglx@linutronix.de>
  Date:   Wed Jun 23 14:02:21 2021 +0200

    x86/fpu: Remove PKRU handling from switch_fpu_finish()

I backported this patch to 5.4 and it does appear to fix the issue
because it avoids XSAVE. However, I have no idea if it's actually
fixing anything or if the behavior is working as intended. So we're
curious, does it make sense to pull back that patch, would that patch
be enough? Any guidance here would be appreciated because this does
seem broken (because of how it was previously implemented) for those
CPUs prior to 5.14, which is why I'm CCing stable@.

Thanks in advance,
Brian

1. https://cdrdv2.intel.com/v1/dl/getContent/631123?explicitVersion=true
2. https://gist.github.com/bgaff/9f8cbfc8dd22e60f9492e4f0aff8f04f
