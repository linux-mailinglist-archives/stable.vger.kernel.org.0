Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80EA5501DC
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 04:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiFRCKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 22:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiFRCKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 22:10:47 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3F76A42A;
        Fri, 17 Jun 2022 19:10:46 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m14so5250114plg.5;
        Fri, 17 Jun 2022 19:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bKGt0hsaV9UBpUb8BfBMtZle9TT7MgYbuRFAfQpmoe8=;
        b=djo5HdCOJ56+WlvWYC472DY0DLxOdji4GThYtWGogh2eUdgAg0M0TEbkIHOVDcr4Cd
         xdFLMy3Muf3GgIkvPdA1Zb+CEyp3BgGplZfLFYoPML3zx/E5yvW4ZAwq+iMdlWW+vBDQ
         MSdHj8hz9jjRtB+lWRF1GThWkiT/UUYUHJcPsbIbx+ZuMgh/WBnMLsZ8rB7aKWEl1FGN
         G38cvjFnwKSnz9VIN6FKtQA3j5EZgOc5Njn0faSsR0YuLMxM7migVBsoAZLG9DSJyOJX
         autoU3ftqqAl1axjkD/QKgiBRIbv5aulItjUAKzjt+v8Dj3XaJ79aqbu15hfN2GmdApe
         oIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bKGt0hsaV9UBpUb8BfBMtZle9TT7MgYbuRFAfQpmoe8=;
        b=LrwcHwLaO4IK3nXLhUU8kT+d+l/d8if7h3N+I3vqLllrlICrzDdaDGc0aNvz4znkEr
         hQBKUtDv2ArZ48Hx653XSZcN/dRbT0tPzcdUXfvrr/WG3d5pSjo+h9NfSNq6mxrRInu8
         cBduP1P0ini0MrptkpdCeJGAdyLnHOzyOHC1ftFO5xy99SUMOTtJn3QUgwaHug9Ftf4F
         4p06DVyoWi3UmcN1fB0mN3QDWsctMsB6gVsXq4XYQNOOcPkNGfiCe24R8O7GGvANx9Z1
         5SszmI0dBGo/mCmJQNAAT6oXupw5p9FYRQRYAP90nGV3V0eM+GxsyWbuH6F1Jy9Gdyt8
         ESOA==
X-Gm-Message-State: AJIora8iP9iTL8mG0JkMdHILNgxJ2grqtVK1l/+jg2SLYqVPWFDKkHJ6
        oa9wBpEceOd3Zemaq7q8JDU=
X-Google-Smtp-Source: AGRyM1sdjAp661MLhJkwcwihtNZam8/ba+IkBAAv+7gmRK+te8qht5RH6Lb3MlY4KPhEFdBPNpci+Q==
X-Received: by 2002:a17:90b:4a12:b0:1e3:15ef:81e1 with SMTP id kk18-20020a17090b4a1200b001e315ef81e1mr24685049pjb.246.1655518246170;
        Fri, 17 Jun 2022 19:10:46 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id o12-20020a62f90c000000b0051b4e53c487sm4340928pfh.45.2022.06.17.19.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 19:10:45 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     kirill@shutemov.name
Cc:     bhe@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@kernel.org,
        mingo@redhat.com, peterz@infradead.org, stable@vger.kernel.org,
        tglx@linutronix.de, x86@kernel.org, ytcoode@gmail.com
Subject: Re: [PATCH] x86/mm: Fix possible index overflow when creating page table mapping
Date:   Sat, 18 Jun 2022 10:08:09 +0800
Message-Id: <20220618020809.81443-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220618002220.panwk4zwnigayboy@box.shutemov.name>
References: <20220618002220.panwk4zwnigayboy@box.shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 18 Jun 2022 03:22:20 +0300, Kirill A. Shutemov wrote:
> On Thu, Jun 16, 2022 at 09:55:10PM +0800, Yuntao Wang wrote:
> > There are two issues in phys_p4d_init():
> > 
> > - The __kernel_physical_mapping_init() does not do boundary-checking for
> >   paddr_end and passes it directly to phys_p4d_init(), phys_p4d_init() does
> >   not do bounds checking either, so if the physical memory to be mapped is
> >   large enough, 'p4d_page + p4d_index(vaddr)' will wrap around to the
> >   beginning entry of the P4D table and its data will be overwritten.
> > 
> > - The for loop body will be executed only when 'vaddr < vaddr_end'
> >   evaluates to true, but if that condition is true, 'paddr >= paddr_end'
> >   will evaluate to false, thus the 'if (paddr >= paddr_end) {}' block will
> >   never be executed and become dead code.
> > 
> > To fix these issues, use 'i < PTRS_PER_P4D' instead of 'vaddr < vaddr_end'
> > as the for loop condition, this also make it more consistent with the logic
> > of the phys_{pud,pmt,pte}_init() functions.
> 
> Hm. I don't see why you changed phys_p4d_init(), but not
> __kernel_physical_mapping_init(). It does exactly the same thing, just
> pgd_index() is hidden a bit deeper than p4d_index().

The reason I chose to change phys_p4d_init() is that:

- Currently the 'if (paddr >= paddr_end) {}' block in phys_p4d_init() is
  dead code, changing __kernel_physical_mapping_init() does not fix that.

- Changing phys_p4d_init() to the 'for (i < PTRS_PER_P4D) {}' form makes
  it more consistent with phys_pud/pmt/pte_init() as they are all using
  the 'for (i < PTRS_PER_PUD/PMD/PTE) {}' forms. Meanwhile, this change
  also fixes the dead code issue.

thanks,

Yuntao Wang
