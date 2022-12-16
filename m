Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F9A64EC87
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 15:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiLPODF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 09:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPODE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 09:03:04 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AF1A19D
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 06:03:02 -0800 (PST)
Received: from fsav315.sakura.ne.jp (fsav315.sakura.ne.jp [153.120.85.146])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2BGE30pY022162;
        Fri, 16 Dec 2022 23:03:00 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav315.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp);
 Fri, 16 Dec 2022 23:03:00 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2BGE2xnN022155
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 16 Dec 2022 23:03:00 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <86bdfea2-7125-2e54-c2c0-920f28ff80ce@I-love.SAKURA.ne.jp>
Date:   Fri, 16 Dec 2022 23:02:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] fbcon: Use kzalloc() in fbcon_prepare_logo()
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cad03d25-0ea0-32c4-8173-fd1895314bce@I-love.SAKURA.ne.jp>
 <CAMuHMdUH4CU9EfoirSxjivg08FDimtstn7hizemzyQzYeq6b6g@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAMuHMdUH4CU9EfoirSxjivg08FDimtstn7hizemzyQzYeq6b6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/12/15 18:36, Geert Uytterhoeven wrote:
> The next line is:
> 
>         scr_memsetw(save, erase, array3_size(logo_lines, new_cols, 2));
> 
> So how can this turn out to be uninitialized later below?
> 
>         scr_memcpyw(q, save, array3_size(logo_lines, new_cols, 2));
> 
> What am I missing?

Good catch. It turned out that this was a KMSAN problem (i.e. a false positive report).

On x86_64, scr_memsetw() is implemented as

        static inline void scr_memsetw(u16 *s, u16 c, unsigned int count)
        {
                memset16(s, c, count / 2);
        }

and memset16() is implemented as

        static inline void *memset16(uint16_t *s, uint16_t v, size_t n)
        {
        	long d0, d1;
        	asm volatile("rep\n\t"
        		     "stosw"
        		     : "=&c" (d0), "=&D" (d1)
        		     : "a" (v), "1" (s), "0" (n)
        		     : "memory");
        	return s;
        }

. Plain memset() in arch/x86/include/asm/string_64.h is redirected to __msan_memset()
but memsetXX() are not redirected to __msan_memsetXX(). That is, memory initialization
via memsetXX() results in KMSAN's shadow memory being not updated.

KMSAN folks, how should we fix this problem?
Redirect assembly-implemented memset16(size) to memset(size*2) if KMSAN is enabled?

