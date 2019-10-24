Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A96EE29B7
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 07:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408390AbfJXFCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 01:02:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43970 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfJXFCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 01:02:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id l24so8539369pgh.10;
        Wed, 23 Oct 2019 22:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:to:cc:cc:cc:subject
         :references:in-reply-to;
        bh=8F5ySKRZr9V5FEeQpHSOPXmmMaNr3Mx87NU9ELmhZRg=;
        b=lr+7ZbCyrjy+yaZ0aCEKVdNJtdHCoJi8GUFJqQLUH7PnKAD3o2925gQqQBn0hkS5Vy
         QMJv4OH869DUxdEIhXojQhoHpqOlUmRCYM4hIP8G3V+srqaZ772jYiCLrrLAmk8InSdX
         /PVoFqJhM6gkCJ4wsDGrzIfd3qsnCk3bZsOefKWfJ1QBbclEaWBLY0UfTFje5pFf6L8x
         oMCa9fUxXbxKY5jlZ123JTspCYKnKhB3n6oQyrQ+LIX7yHG+NclN9Czy0Ot/puYU3tAw
         mqURt9ZlrxpQ92vYH7ESU1ThNR0tm88iL9803evkmfQsWoIN8dA+EgztmjzS4XGK4tAJ
         UBww==
X-Gm-Message-State: APjAAAVLLFYKZ9yY+Q26p7j1HG96o7EBJHkfWY8Vgg2yzLyHmFxdEjXo
        X/G0DswLhoCVuQQ0FOOUunc=
X-Google-Smtp-Source: APXvYqy7cMtcmkSp77OgFZBCPky6lqO8/DWsIDXUzPHZ7nfD7tr2WBu36bw90v+aFO2aTDUDvsn62Q==
X-Received: by 2002:a17:90a:8c02:: with SMTP id a2mr4543343pjo.79.1571893340916;
        Wed, 23 Oct 2019 22:02:20 -0700 (PDT)
Received: from localhost ([2601:646:8a00:9810:5cfa:8da3:1021:be72])
        by smtp.gmail.com with ESMTPSA id f21sm21876384pgh.85.2019.10.23.22.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 22:02:20 -0700 (PDT)
Message-ID: <5db1305c.1c69fb81.3345f.9763@mx.google.com>
Date:   Wed, 23 Oct 2019 22:02:19 -0700
From:   Paul Burton <paulburton@kernel.org>
To:     Paul Burton <paulburton@kernel.org>
CC:     linux-mips@vger.kernel.org
CC:     linux-kernel@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Dmitry Korotin <dkorotin@wavecomp.com>, stable@vger.kernel.org
CC:     linux-mips@vger.kernel.org
Subject: Re: [PATCH] MIPS: tlbex: Fix build_restore_pagemask KScratch restore
References:  <20191018223848.1128468-1-paulburton@kernel.org>
In-Reply-To:  <20191018223848.1128468-1-paulburton@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Paul Burton wrote:
> build_restore_pagemask() will restore the value of register $1/$at when
> its restore_scratch argument is non-zero, and aims to do so by filling a
> branch delay slot. Commit 0b24cae4d535 ("MIPS: Add missing EHB in mtc0
> -> mfc0 sequence.") added an EHB instruction (Execution Hazard Barrier)
> prior to restoring $1 from a KScratch register, in order to resolve a
> hazard that can result in stale values of the KScratch register being
> observed. In particular, P-class CPUs from MIPS with out of order
> execution pipelines such as the P5600 & P6600 are affected.
> 
> Unfortunately this EHB instruction was inserted in the branch delay slot
> causing the MFC0 instruction which performs the restoration to no longer
> execute along with the branch. The result is that the $1 register isn't
> actually restored, ie. the TLB refill exception handler clobbers it -
> which is exactly the problem the EHB is meant to avoid for the P-class
> CPUs.
> 
> Similarly build_get_pgd_vmalloc() will restore the value of $1/$at when
> its mode argument equals refill_scratch, and suffers from the same
> problem.
> 
> Fix this by in both cases moving the EHB earlier in the emitted code.
> There's no reason it needs to immediately precede the MFC0 - it simply
> needs to be between the MTC0 & MFC0.
> 
> This bug only affects Cavium Octeon systems which use
> build_fast_tlb_refill_handler().

Applied to mips-fixes.

> commit b42aa3fd5957
> https://git.kernel.org/mips/c/b42aa3fd5957
> 
> Signed-off-by: Paul Burton <paulburton@kernel.org>
> Fixes: 0b24cae4d535 ("MIPS: Add missing EHB in mtc0 -> mfc0 sequence.")

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paulburton@kernel.org to report it. ]
