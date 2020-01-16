Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3168413D1A2
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 02:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgAPBlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 20:41:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37860 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730040AbgAPBlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 20:41:09 -0500
Received: by mail-pg1-f195.google.com with SMTP id q127so9062160pga.4
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 17:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=OTEN+f/OFDFOflzljVl06WSTKGl4G9efSvtH+vtLVCk=;
        b=a9z0/vEjwCgcJhluy2sV74yhyTqZI4IAwJW5XSYHITPA2cJlC25Q5ybA/PV57kbqGJ
         CdEJicUEv842cLlpm9m4vt1SjvOccjM6nchQNTiulZcad6a3LHHNY77k4rc23cUXz6Ds
         Q9eiaQaf8PoqU/qc0UH15GhajakhSSy3JyqL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=OTEN+f/OFDFOflzljVl06WSTKGl4G9efSvtH+vtLVCk=;
        b=oovirT0b4DZLjXxx3/LMdmmNTzsUNTRmdvrz+QPH3ygURLdMK7lzcW04XNn2JOzoOt
         ZzX+hCwXMoqAm2HUsaQcpM2DSPL6lvLU3bJdEI1CEvKc58RN0c47uABI5jhjZBKG5019
         esFIvWTEpS94HhAUxGmTvb0w0mNaCWB+kIjmt0mNFQYd3drG+iYlxK2PRJgZ44axYgcB
         BPOw0hmMX2rjui+UE363oTd87d20GBoxY/sxMcBB73kPUt7SU4lkHyd2om/V2ICYF1sa
         +zOgSDS11SRQ/G5RS28/TGjlDkkXOZuPgx6HjbIpGioTqk56FkKRMnjC/1srMgGG5PoZ
         fUjw==
X-Gm-Message-State: APjAAAWwTQVZdC352TNaAJucwmVdlDnQuBkbX+HC4BrWJx0RZ4dTJTLI
        8kddy4Gll6wlQgpJSfLpecXT9g==
X-Google-Smtp-Source: APXvYqwko7/eiJ5B1g+qPyMVpFjrrCYDGNoAn09PUhy5/3CawL8kYiM3i/txwkk8UB0ercGf9+mVwQ==
X-Received: by 2002:a65:52ca:: with SMTP id z10mr37248183pgp.47.1579138868892;
        Wed, 15 Jan 2020 17:41:08 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i127sm24380442pfe.54.2020.01.15.17.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 17:41:08 -0800 (PST)
Date:   Wed, 15 Jan 2020 17:41:07 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Subject: missing backports for x86 syscall function prototype cleanups
Message-ID: <202001151737.F00EC408@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

Sami pointed out to me that 4 of 6 patches in Linus's tree that were
cleaning up the x86 syscall function prototypes didn't make it into
-stable.

These were backported:

8661d769ab77 ("syscalls/x86: Use the correct function type in SYSCALL_DEFINE0")
	(as e79138ba8e0ec84f3ab5daa4761e4d534bbc682d)
f53e2cd0b8ab ("x86/mm: Use the correct function type for native_set_fixmap()")
	(as a823d762a57519adeb33f5f12f761d636e42d32e)

But these are missing, leading to some confusion when working with v5.4
under CFI:

cf3b83e19d7c928e05a5d193c375463182c6029a
00198a6eaf66609de5e4de9163bb42c7ca9dd7b7
f48f01a92cca09e86d46c91d8edf9d5a71c61727
6e4847640c6aebcaa2d9b3686cecc91b41f09269

Can these get added please?

Thanks!

-- 
Kees Cook
