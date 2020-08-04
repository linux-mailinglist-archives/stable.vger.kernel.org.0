Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA30323B440
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 06:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgHDEpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 00:45:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:39845 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgHDEpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 00:45:33 -0400
IronPort-SDR: kfL1hhR3qfjjTNV8hfCpcsrQLwfs0AIYwjw1nvIbAcvD/VvqQ936dkHnrblIdVV/CwIN+AP2fc
 ooqeyh1UxnVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="151475754"
X-IronPort-AV: E=Sophos;i="5.75,432,1589266800"; 
   d="scan'208";a="151475754"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 21:45:32 -0700
IronPort-SDR: yT+NnfDzkBBqZocXS5Cm5LSqUA6iXDA0PdiYx2LJzMwyVMnoKnfAmSFyjlrUPndNHDPKGRzR/+
 LEl1MtaDPn8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,432,1589266800"; 
   d="scan'208";a="292419767"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga006.jf.intel.com with ESMTP; 03 Aug 2020 21:45:32 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 40984301C06; Mon,  3 Aug 2020 21:45:32 -0700 (PDT)
Date:   Mon, 3 Aug 2020 21:45:32 -0700
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
Message-ID: <20200804044532.GC1321588@tassilo.jf.intel.com>
References: <20200731230820.1742553-1-keescook@chromium.org>
 <20200731230820.1742553-14-keescook@chromium.org>
 <20200801035128.GB2800311@rani.riverdale.lan>
 <20200803190506.GE1299820@tassilo.jf.intel.com>
 <20200803201525.GA1351390@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803201525.GA1351390@rani.riverdale.lan>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Why is that? Both .text and .text.hot have alignment of 2^4 (default
> function alignment on x86) by default, so it doesn't seem like it should
> matter for packing density.  Avoiding interspersing cold text among

You may lose part of a cache line on each unit boundary. Linux has 
a lot of units, some of them small. All these bytes add up.

It's bad for TLB locality too. Sadly with all the fine grained protection
changes the 2MB coverage is eroding anyways, but this makes it even worse.

> regular/hot text seems like it should be a net win.

> 
> That old commit doesn't reference efficiency -- it says there was some
> problem with matching when they were separated out, but there were no
> wildcard section names back then.

It was about efficiency.

-Andi
