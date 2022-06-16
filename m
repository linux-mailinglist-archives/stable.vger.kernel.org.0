Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B7754E323
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 16:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiFPOPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 10:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiFPOPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 10:15:31 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CF4240AA;
        Thu, 16 Jun 2022 07:15:31 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y6so1413724plg.0;
        Thu, 16 Jun 2022 07:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B0DQXMmFX31kqRJ9DZJX0TzqdWP4QoC1D09Sqllu00Y=;
        b=TV4RowDFldGjX129RqQ1x7Pme6uKViaPCDsSD7lX8BgMbAoph0jL/mtyAqyfBhw6Ql
         OgoxlQTVPdWOOlla+UCCTGijvikIMQ3W1p9QdGfoBCSP0R2yRtrJCIDKGxZPqn/bnDs3
         +CiinEG572B2WJYA+KIyZp0A2G5Amkkuu6B8Edjt4/HoSWinBUMuC5GEBfduoH76ZKGv
         dGk6Y15aR7OTVoTB8c4QCyYRQpBZgwx+KnuamGeTL+Rn/uBBoqOGz7NXlHcekM4WHFHx
         UDPRIjh7QULu7iIXQeHM27cMy+yRLqTsISCj1UvEwM0IlXiGQ+G1IW6swJ3HH0W391wG
         X9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0DQXMmFX31kqRJ9DZJX0TzqdWP4QoC1D09Sqllu00Y=;
        b=UYbG6fuFhXjZmPZRDYGyWYp0tApE3U7mxhVIIiYQO06MaT7Z618xoGar85JsIIoREg
         TYcqIjPAmBFbLN0BgQ2/IBlZ65pwS5Jx12KwamrXaIQSk9Mpv+qGj0uWhMOgEjGUXrDN
         uqKhSzIMTTR1bkVSFdkxVgnRz3ITfziw78FrpUchrZKZEKJh6GU03zj9wmSndH5cmjSb
         oitH/TwR0bfLyAQDc2uxGaNQFrgLEfj82/SPDl9iNqMSNegCA/VM/CsUjRX4Af6wSUgy
         RwrZL8HFkK0xkT0CpyEr8FqJS9jzn3qoiByjI2ifzgxGXZjao3WPGDhQI5TQoSrsD6L7
         izug==
X-Gm-Message-State: AJIora9gfaFMm8M2UqyGCXbnEo422Z3Yn8ESCkDP1zjqlugazbGCQQ4V
        M3FsWjTvGDtS/QO8sBnZTq0=
X-Google-Smtp-Source: AGRyM1t6OTENGF8VEGj4SqChaU0kKe9c6/kGtQezdZ3s9bvEHMYyLuXXLZwg0g2joIkWg0dsNMNGLQ==
X-Received: by 2002:a17:902:f142:b0:167:c58:2d45 with SMTP id d2-20020a170902f14200b001670c582d45mr4955027plb.109.1655388930893;
        Thu, 16 Jun 2022 07:15:30 -0700 (PDT)
Received: from VM-155-146-centos.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id c2-20020a639602000000b003fb098151c9sm1828974pge.64.2022.06.16.07.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 07:15:30 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     dave.hansen@intel.com
Cc:     bhe@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
        luto@kernel.org, mingo@redhat.com, peterz@infradead.org,
        stable@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        ytcoode@gmail.com
Subject: Re: [PATCH] x86/mm: Fix possible index overflow when creating page table mapping
Date:   Thu, 16 Jun 2022 22:15:25 +0800
Message-Id: <20220616141525.1790083-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <3e754cf7-35f8-0163-a24a-063fa3d96718@intel.com>
References: <3e754cf7-35f8-0163-a24a-063fa3d96718@intel.com>
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

On Thu, 16 Jun 2022 07:02:56 -0700, Dave Hansen wrote:
> On 6/16/22 06:55, Yuntao Wang wrote:
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
>
> Could you explain a bit how you found this?  Was this encountered in
> practice and debugged or was it found by inspection?

I found it by inspection.
