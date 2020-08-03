Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2C723ACBB
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 21:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHCTFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 15:05:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:47829 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgHCTFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 15:05:17 -0400
IronPort-SDR: /4xYqsQ05M2uR13ZPzMJ1t3c50JhloS2n5IOA3RaBRglrQdPd/T/gOABLq+rH3iOAQlZ5RGNok
 iEcG37saVgCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="151414459"
X-IronPort-AV: E=Sophos;i="5.75,431,1589266800"; 
   d="scan'208";a="151414459"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 12:05:07 -0700
IronPort-SDR: oJ59usHZIo/V2XvsaaF2ffeauJiMzYoWD+G0LHQLHWJK+qHUC5lg/k5XEvs4GeYnlYUIdwSTxl
 25ocyzJZIrTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="314888731"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by fmsmga004.fm.intel.com with ESMTP; 03 Aug 2020 12:05:07 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id E5E5E301C06; Mon,  3 Aug 2020 12:05:06 -0700 (PDT)
Date:   Mon, 3 Aug 2020 12:05:06 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <jiancai@google.com>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michal Marek <michal.lkml@markovi.net>
Subject: Re: [PATCH v5 13/36] vmlinux.lds.h: add PGO and AutoFDO input
 sections
Message-ID: <20200803190506.GE1299820@tassilo.jf.intel.com>
References: <20200731230820.1742553-1-keescook@chromium.org>
 <20200731230820.1742553-14-keescook@chromium.org>
 <20200801035128.GB2800311@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801035128.GB2800311@rani.riverdale.lan>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> However, the history of their being together comes from
> 
>   9bebe9e5b0f3 ("kbuild: Fix .text.unlikely placement")
> 
> which seems to indicate there was some problem with having them separated out,
> although I don't quite understand what the issue was from the commit message.

Separating it out is less efficient. Gives worse packing for the hot part
if they are not aligned to 64byte boundaries, which they are usually not. 

It also improves packing of the cold part, but that probably doesn't matter.

-Andi
