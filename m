Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18A1C96EA
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 18:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgEGQ5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 12:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726222AbgEGQ5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 12:57:13 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14A0C05BD43;
        Thu,  7 May 2020 09:57:13 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jWjpN-0000lH-1s; Thu, 07 May 2020 18:56:53 +0200
Date:   Thu, 7 May 2020 18:56:52 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Yu-cheng Yu <yu-cheng.yu@intel.com>
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
Subject: Re: [PATCH] x86/fpu/xstate: Clear uninitialized xstate areas in core
 dump
Message-ID: <20200507165652.s2cuaxasa2t5wkhx@linutronix.de>
References: <20200507164904.26927-1-yu-cheng.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507164904.26927-1-yu-cheng.yu@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-07 09:49:04 [-0700], Yu-cheng Yu wrote:
> In a core dump, copy_xstate_to_kernel() copies only enabled user xfeatures
> to a kernel buffer without touching areas for disabled xfeatures.  However,
> those uninitialized areas may contain random data, which is then written to
> the core dump file and can be read by a non-privileged user.
> 
> Fix it by clearing uninitialized areas.

Is the problem that copy_xstate_to_kernel() gets `kbuf' passed which
isn't zeroed? If so, would it work clean that upfront?

Sebastian
