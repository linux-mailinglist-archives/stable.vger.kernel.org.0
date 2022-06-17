Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A9354F11B
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 08:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbiFQGjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 02:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiFQGjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 02:39:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC6E56F9B;
        Thu, 16 Jun 2022 23:39:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id d14so130089pjs.3;
        Thu, 16 Jun 2022 23:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3nq0sEVdb/x1ukcdXtYcrvwvNzqDSLocc4o0m2aVSjk=;
        b=dPPVfjCWxsXxpFGOHcqPC1fV/pXZ22W1hnFF4jLJBIkdlTzQPC4jQnXeALFShf5UXP
         Viml177LUX8WdXFfPhqlGOweqgVY+2mDCh3j/jZP7z04R8pggPhjAPzX/OAgN7C/b3pV
         9gnIUYYPygjp6S24Cz6oL6nJSlA56+fYY3chmnnx+GESAAlmIm2/hmCK6GPhfVN0lvvf
         dAtTfPRfNrNu354w3i/JVwUoTGPir8GmZjw3dfyyu+ZyRr06kbfDTsnQ+6qgWuhXp+3l
         l+Cy/WvN4ius6CCYO/Rx4ge0E9/RwEqrM3UTgzwhezMS6mFg4jm7Je/idEJKemYV9R7e
         an0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3nq0sEVdb/x1ukcdXtYcrvwvNzqDSLocc4o0m2aVSjk=;
        b=SHp5j6Q0Ya9OS4Q4XagsbIVzjN9BLas3RJqGj7e7SDv+R5OwKLBP+rpBOe1hXFVCll
         lnTIkMPCZYX5ZEPfesE5MUzQVvrqsjLRbBQRRBabqS1eDQxkIA9wrOUCA/4OvMVomU1+
         MJofTNuUXCasc5CEikr0Isyfv1Np4UCAda4h7MXSZMUfoQq1qQux3H9gidOgs5pGCPwO
         wtJgDeXmSxkK7P/Vwkli0gqNm7+TfMuByoa18kmVoSZVtQAMGi2Kqp7Wn9j5kIW7Fu4g
         AzdqFlzOajflc2Z9oJmx41mrTih5Sg1gVxWmSEQ0mrLF6hQZOSmidzCl7xM52rJYfxGw
         i2pQ==
X-Gm-Message-State: AJIora9t0gpumCxliMYMKUfbfnCNPSYvfTCEE5bFKbCUi8cKMTbirYMN
        m3sbIGqARm9Bqali98t0/H0MYZey4BV3B4L2
X-Google-Smtp-Source: AGRyM1ubEnpcjWuy2vE5xi70Fmbu5aLG0TLkWtOCP3AWGVcX09v8zJplUrZBh470nxoZgU1bVMBm3g==
X-Received: by 2002:a17:902:aa0c:b0:168:faa0:50a1 with SMTP id be12-20020a170902aa0c00b00168faa050a1mr8271195plb.57.1655447941168;
        Thu, 16 Jun 2022 23:39:01 -0700 (PDT)
Received: from VM-155-146-centos.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id o1-20020a62f901000000b0052285857864sm2937781pfh.97.2022.06.16.23.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 23:39:00 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     dave.hansen@intel.com
Cc:     bhe@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
        luto@kernel.org, mingo@redhat.com, peterz@infradead.org,
        stable@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        ytcoode@gmail.com
Subject: Re: [PATCH] x86/mm: Fix possible index overflow when creating page table mapping
Date:   Fri, 17 Jun 2022 14:38:55 +0800
Message-Id: <20220617063855.1999092-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <8e2c9b2b-d8ad-5e9a-7aa6-23e0c599c2e9@intel.com>
References: <8e2c9b2b-d8ad-5e9a-7aa6-23e0c599c2e9@intel.com>
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

On Thu, 16 Jun 2022 07:20:40 -0700, Dave Hansen wrote:
> On 6/16/22 07:15, Yuntao Wang wrote:
> > On Thu, 16 Jun 2022 07:02:56 -0700, Dave Hansen wrote:
> >> On 6/16/22 06:55, Yuntao Wang wrote:
> >>> There are two issues in phys_p4d_init():
> >>>
> >>> - The __kernel_physical_mapping_init() does not do boundary-checking for
> >>>   paddr_end and passes it directly to phys_p4d_init(), phys_p4d_init() does
> >>>   not do bounds checking either, so if the physical memory to be mapped is
> >>>   large enough, 'p4d_page + p4d_index(vaddr)' will wrap around to the
> >>>   beginning entry of the P4D table and its data will be overwritten.
> >>>
> >>> - The for loop body will be executed only when 'vaddr < vaddr_end'
> >>>   evaluates to true, but if that condition is true, 'paddr >= paddr_end'
> >>>   will evaluate to false, thus the 'if (paddr >= paddr_end) {}' block will
> >>>   never be executed and become dead code.
> >> Could you explain a bit how you found this?  Was this encountered in
> >> practice and debugged or was it found by inspection?
> > I found it by inspection.
>
> Dare I ask how this was tested?

Due to some limitations, I didn't test the changes thoroughly, I just built
the kernel and booted it in QEMU.

Considering that the patch was not fully tested, I spent a lot of time
reviewing the code I changed and tried my best to make it correct.
