Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412F74D2469
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 23:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350750AbiCHWjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 17:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238847AbiCHWjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 17:39:51 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17904338AB
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 14:38:54 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id s25so621036lji.5
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 14:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=smV9KKIwtal78N+VJZFIhUWRO8IPPNUi5IDr0t+R4Ws=;
        b=d7vkIVIst9qON4US7u/M+bn/C/BeUE6U9qwyhC9PV8E7Xetpk/M923PcFvBg18HAhu
         BQwikQ1caXfO1kWZhaKKYcfUB0Wk1kTF9YHyw1o8SAGG+3zLJMYzKqUVzRgL31ahnaS5
         +a3NaaZsU5xX2oqtPCO1AqgKdE4cJ0laGtRkRYiA3Faq1qNGgWjpO/49bTPNAifihSvH
         3OmP9hmDuJwJEyH8yv3pnVGGMhDssfJ/DfHDMFK+0CiNXC2IXtXQRV6i4qKDCF1V8DZC
         kadkd/hhJnPG++pAqbLcJq7k7+lRVNlLQN1QqQTFILJ6tqWb9rmzbxdy0Ke8+Wx7/yHa
         5d5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=smV9KKIwtal78N+VJZFIhUWRO8IPPNUi5IDr0t+R4Ws=;
        b=qOyZCy9r13CtZhy9cbAJdsVDWK2ZAPi5lxthdvBvBs+n9klErzD0K6baaaA30h0jHu
         XWH5VajJCudVI5vBF6NUP/NHR0TZAk0UIof8f8Pz7Rz7aNn0omZ8ZKK/xsJxpRgpeRmp
         XQ0F84rz/3MevdGUxZuVzqNpEaR2gPDkbS7RGLWkngmXQbrpfKrz6SAXGVUnI4eeprY0
         QuiYp3mqo84tACsHCvhmhP2NNH5vthRlevezdYT2cxBojkPlI1r6np18UGhXzqTrRLlW
         7DzbtreZPnUcOYYRzp2QxnUQ+plntGX3Okf1tD8Mq5xxFv3cZ3V6PA9+9jgX1UMeqHSv
         22lA==
X-Gm-Message-State: AOAM5305itW9QZkFoWWxTYqQGsF+bqty5QRWssplmM7thdlV897+4fBu
        60u7tbJLX/7iXOxvOIcIqlKX+hvZ8VSEsTgsWWR17Q+2Gd1ieBCI
X-Google-Smtp-Source: ABdhPJxN6GAvKr/FHemE3wibga1rWVqYX3/0uF9F+WUQsl0hJRH54Hys/fVjglz6Axqr0JadcVAj4Oi2AwcLXYREc5M=
X-Received: by 2002:a05:651c:1791:b0:243:94bd:d94c with SMTP id
 bn17-20020a05651c179100b0024394bdd94cmr11875831ljb.468.1646779132243; Tue, 08
 Mar 2022 14:38:52 -0800 (PST)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 8 Mar 2022 14:38:40 -0800
Message-ID: <CAKwvOd=iOS3HEUH1w-R4vYSNMwAzE7kr30FcXNZg0e1WBvpenQ@mail.gmail.com>
Subject: arm64 memcpy+memove 5.10 patch
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Manoj Gupta <manojgupta@google.com>,
        Denis Nikitin <denik@google.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, llvm@lists.linux.dev,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable kernel maintainers,
Please consider cherry-picking

commit 6c23d54f4cb8 ("arm64: Import latest memcpy()/memmove() implementation")

to v5.10.y.  It first landed in v5.14-rc1.

It fixes a linkage failure observed when building kernels for ChromeOS
under AutoFDO:

ld.lld: error: arch/arm64/lib/lib.a(memmove.o):(function __memmove:
.text+0x8): relocation R_AARCH64_CONDBR19 out of range: -6331272 is
not in [-1048576, 1048575]; references __memcpy
>>> defined in arch/arm64/lib/lib.a(memcpy.o)

(The prior version of memmove used assembler conditional branches to
memcpy; under AutoFDO the linker will decide where best to place
memmove; it may be > 1MB away from memcpy. After this patch, memcpy
and memmove are the same function).
-- 
Thanks,
~Nick Desaulniers
