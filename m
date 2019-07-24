Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3630B72C5E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 12:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfGXKdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 06:33:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43563 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfGXKdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 06:33:14 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hqEa0-0004EB-AS; Wed, 24 Jul 2019 12:33:04 +0200
Date:   Wed, 24 Jul 2019 12:33:03 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Nick Desaulniers <ndesaulniers@google.com>
cc:     mingo@redhat.com, bp@alien8.de, peterz@infradead.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        yamada.masahiro@socionext.com, stable@vger.kernel.org,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Alistair Delva <adelva@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        Uros Bizjak <ubizjak@gmail.com>,
        Chao Fan <fanc.fnst@cn.fujitsu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>
Subject: Re: [PATCH v3 1/2] x86/purgatory: do not use __builtin_memcpy and
 __builtin_memset
In-Reply-To: <20190723212418.36379-1-ndesaulniers@google.com>
Message-ID: <alpine.DEB.2.21.1907241231480.1972@nanos.tec.linutronix.de>
References: <20190723212418.36379-1-ndesaulniers@google.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Jul 2019, Nick Desaulniers wrote:
> Instead, reuse an implementation from arch/x86/boot/compressed/string.c
> if we define warn as a symbol. Also, Clang may lower memcmp's that
> compare against 0 to bcmp's, so add a small definition, too. See also:
> commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> 
> Cc: stable@vger.kernel.org
> Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
> Link: https://bugs.chromium.org/p/chromium/issues/detail?id=984056
> Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Debugged-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Debugged-by: Manoj Gupta <manojgupta@google.com>
> Suggested-by: Alistair Delva <adelva@google.com>
> Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

That SOB chain is weird. Is Vaibhav the author?

> +/*
> + * Clang may lower `memcmp == 0` to `bcmp == 0`.
> + */
> +int bcmp(const void *s1, const void *s2, size_t len) {
> +	return memcmp(s1, s2, len);
> +}

foo()
{
}

please.

Thanks,

	tglx
