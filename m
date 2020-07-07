Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4762176D4
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 20:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgGGSfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 14:35:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45341 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgGGSfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 14:35:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id s10so46249089wrw.12;
        Tue, 07 Jul 2020 11:35:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IxxgOhn0lGIUx68pkNi/zBk9PHmI9Ujpy6Yy6N+FauI=;
        b=FgAzOPoSbQS7H5NUrBteka9wxpaJl14c625k9Hy3qlI5tc5quG6DzUwc9BGloAfIiP
         WOgM+7+l6pDf0UQiFOT53oJJ+nl7TQM86UswiWBsHKtsuFP/VWlex2JMRHOaiWOC8Doo
         JTLiVBePwGeHPXz5VP9JjWtG3jzb1VVnMxlN3HU52SknroXsdm/OSlZX+fw1+YSr6kLV
         Hi4PrSrfSHIran3HZ3qIJ2fnOLu/Zku1cDhy96nACmVewLDCKcsJAC4He3o3ZHzSYcl5
         V/vHtnrx+XWxD3oWpGlAYtEetvEIIr7dojgaUWNE4BWuAGCOlmxNZZ92TqxYHiwsR5+5
         Y+tw==
X-Gm-Message-State: AOAM530lkgKkQPd4Ek09Rzil4XSmDXONfZHSJ+8MjF+6KSN8qbkE5N92
        QUFjpUXfgrgk92M3B/GGUTk3yZi5
X-Google-Smtp-Source: ABdhPJwEe7e5O3OlbWSEfsZM3Pa/ieXK1xVYvlYr9ZySVMUNyMBSRt113UYGI5z3UF8RjUIzHDx07w==
X-Received: by 2002:a5d:40c9:: with SMTP id b9mr53122600wrq.425.1594146902779;
        Tue, 07 Jul 2020 11:35:02 -0700 (PDT)
Received: from kozik-lap ([194.230.155.195])
        by smtp.googlemail.com with ESMTPSA id y16sm2058180wro.71.2020.07.07.11.35.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jul 2020 11:35:02 -0700 (PDT)
Date:   Tue, 7 Jul 2020 20:34:59 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Tom Vaden <tom.vaden@hpe.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org
Subject: Re: [RFT PATCH] ia64: Fix build error with !COREDUMP
Message-ID: <20200707183459.GB3442@kozik-lap>
References: <20200604201842.29482-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200604201842.29482-1-krzk@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 04, 2020 at 10:18:42PM +0200, Krzysztof Kozlowski wrote:
> Fix linkage error when CONFIG_BINFMT_ELF is selected but CONFIG_COREDUMP
> is not:
> 
>     ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_phdrs':
>     elfcore.c:(.text+0x172): undefined reference to `dump_emit'
>     ia64-linux-ld: arch/ia64/kernel/elfcore.o: in function `elf_core_write_extra_data':
>     elfcore.c:(.text+0x2b2): undefined reference to `dump_emit'
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 1fcccbac89f5 ("elf coredump: replace ELF_CORE_EXTRA_* macros by functions")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> Please let kbuild test it for a while before applying. I built it only
> on few configurations.
> 
> This is similar fix to commit 42d91f612c87 ("um: Fix build error and
> kconfig for i386") although I put different fixes tag - the commit which
> introduced this part of code.

Kernel-test-robot did not complain anymore so I think build tests
passed.

Any comments here?

Best regards,
Krzysztof

