Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A65100C4C
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 20:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKRTkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 14:40:10 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38589 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfKRTkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 14:40:09 -0500
Received: by mail-io1-f67.google.com with SMTP id i13so20200102ioj.5
        for <stable@vger.kernel.org>; Mon, 18 Nov 2019 11:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ga2QOfLsmfhUnk6OwFJIP/FQLzU959KChsQqy2SkK0Y=;
        b=PU7Vz9tJaqQojCfLRboG837OeLoOtQZpwQCf8MXYQXSQ0yEub51VGxshLMUi7epDOd
         xs+ageFwVejd8Guw1fRAXgEkqH5NWGUoacZvQfZWOkGi80u8rFvFiXygRzqdO93LGI9O
         /MW3unwEs6/Z15UUIOpA7rZOHQ4/OQN65nOlUo7xT2tBFkRhqtgqGAOaiaWZ8tV6kExX
         ntZIlMGXS6u7FIBlN3BkxP/gLBPtlaR5VxLFMN6yC0qEx5Igeop/GgHvvuIt9/yuJYp0
         mN3Wtbhb2oT1mZTHHc5opIaQaFnOs2AbGTP7nWs5zvpHRMt2yHHC01KX+EMXVYsiVqHT
         ndWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ga2QOfLsmfhUnk6OwFJIP/FQLzU959KChsQqy2SkK0Y=;
        b=NQljsYbIo9+66kyTmion6b5tDZwrVXLJemAHp9mwlHb/U26KTXp3l9luiP19MPATZd
         95zCbsMbbtw5RU3KHvuDFevk3nQ2tkabHIoKpUJWVYDfwSDkXJfuQtjfZylYL6BrJ7W+
         pc9Z48ECaRSwe42V4DuEjQ+MwJe+Jo7qngsd5jBcZewYHrgPCtP0gibpdv02vZ55GCRp
         zql27CRktXpa5U8rBo5l5LZaYBz6Aam6J4zONhZFbA723aP4haHCsU3UUgx5L3gMZP0B
         bXE35fWO7KfmX38GWoBj9+aDETRgwsm0crXEcWuCuv9bj4fdlvLaD9xMCmHblAlQQ04h
         218w==
X-Gm-Message-State: APjAAAXXjWRfi0NihgwbLd9i56cPOFET24GX16f6llAons1rYiqaw1AC
        Rips72v7+xHv/WtHqRF8wzAcqNsKaCVBQPyoO0whrw==
X-Google-Smtp-Source: APXvYqw+d2zHth6qS/TxDmab4ggByifB0NaAT7RS/+ysk4DVgF/PlEVHyn1tIEWtnKHuSz1obEsITYvKNRASyR77Icc=
X-Received: by 2002:a5d:9b08:: with SMTP id y8mr7466853ion.108.1574106008870;
 Mon, 18 Nov 2019 11:40:08 -0800 (PST)
MIME-Version: 1.0
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com> <1574101067-5638-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1574101067-5638-2-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 18 Nov 2019 11:39:57 -0800
Message-ID: <CALMp9eQjkp7H5oj_XrmqbTsQjrjq1LrbYfxqeNUzWfT4a_Tg8Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 10:17 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> KVM does not implement MSR_IA32_TSX_CTRL, so it must not be presented
> to the guests.  It is also confusing to have !ARCH_CAP_TSX_CTRL_MSR &&
> !RTM && ARCH_CAP_TAA_NO: lack of MSR_IA32_TSX_CTRL suggests TSX was not
> hidden (it actually was), yet the value says that TSX is not vulnerable
> to microarchitectural data sampling.  Fix both.

I actually think kvm should virtualize IA32_TSX_CTRL for VMs that have
exclusive use of their cores (i.e. the same VMs for which we disable
MWAIT and HLT exiting).
