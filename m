Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA821C9733
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgEGRLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:11:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:38339 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgEGRLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 13:11:22 -0400
IronPort-SDR: vqewH9RqpvIF2HfBFBS/eeMHxGv+I0SE/DFpJmJ1Z4WVItWKRHhsBv1KX8IzpyGaWACAXyI6bJ
 LoZY2gk4nG2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 10:11:21 -0700
IronPort-SDR: xovuzeNxm5Eyvbfr5qAPChVR8MHb8RH+uPFI4/1jnxkDYJPXbmfmBWz5Y57uJGyoFfhoYnfPC6
 D3xC5yGPYtsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="370177288"
Received: from yyu32-desk.sc.intel.com ([143.183.136.146])
  by fmsmga001.fm.intel.com with ESMTP; 07 May 2020 10:11:21 -0700
Message-ID: <a40f3834f953da91dee719c1a801761405dc4780.camel@intel.com>
Subject: Re: [PATCH] x86/fpu/xstate: Clear uninitialized xstate areas in
 core dump
From:   Yu-cheng Yu <yu-cheng.yu@intel.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Rik van Riel <riel@surriel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        sam <sunhaoyl@outlook.com>, Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Date:   Thu, 07 May 2020 10:11:25 -0700
In-Reply-To: <20200507165652.s2cuaxasa2t5wkhx@linutronix.de>
References: <20200507164904.26927-1-yu-cheng.yu@intel.com>
         <20200507165652.s2cuaxasa2t5wkhx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-05-07 at 18:56 +0200, Sebastian Andrzej Siewior wrote:
> On 2020-05-07 09:49:04 [-0700], Yu-cheng Yu wrote:
> > In a core dump, copy_xstate_to_kernel() copies only enabled user xfeatures
> > to a kernel buffer without touching areas for disabled xfeatures.  However,
> > those uninitialized areas may contain random data, which is then written to
> > the core dump file and can be read by a non-privileged user.
> > 
> > Fix it by clearing uninitialized areas.
> 
> Is the problem that copy_xstate_to_kernel() gets `kbuf' passed which
> isn't zeroed? If so, would it work clean that upfront?

Alexander Potapenko's patch (in the Link:) fixes the buffer in
fill_thread_core_info().  My patch prevents the same issue if this function is
called from somewhere else in the future.

Yu-cheng

