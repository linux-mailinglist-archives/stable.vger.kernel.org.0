Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0337530A402
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhBAJGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:06:46 -0500
Received: from verein.lst.de ([213.95.11.211]:40230 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232254AbhBAJGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 04:06:43 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6907568AFE; Mon,  1 Feb 2021 10:05:59 +0100 (CET)
Date:   Mon, 1 Feb 2021 10:05:59 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/11] x86/fault: Fix AMD erratum #91 errata fixup for
 user code
Message-ID: <20210201090559.GA8210@lst.de>
References: <cover.1612113550.git.luto@kernel.org> <7aaa6ff8d29faea5a9324a85e5ad6c41c654e9e0.1612113550.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7aaa6ff8d29faea5a9324a85e5ad6c41c654e9e0.1612113550.git.luto@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 31, 2021 at 09:24:32AM -0800, Andy Lutomirski wrote:
> While we're at it, disable the workaround on all CPUs except AMD Family
> 0xF.  By my reading of the Revision Guide for AMD Athlon™ 64 and AMD
> Opteron™ Processors, only family 0xF is affected.

I think it would be better to have one no risk refression fix that
just probes both user and kernel addresses and a separate one to
restrict the workaround.

> +	if (likely(boot_cpu_data.x86_vendor != X86_VENDOR_AMD
> +		   || boot_cpu_data.x86 != 0xf))

Normally kernel style would be to have the || on the first line.
