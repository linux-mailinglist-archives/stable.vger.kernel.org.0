Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C33186CD
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 10:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfEIIbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 04:31:17 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:35474 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfEIIbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 04:31:17 -0400
Received: by mail-wm1-f46.google.com with SMTP id y197so2005379wmd.0;
        Thu, 09 May 2019 01:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FzWOYssN0isWIIe9zGhm6nETA9v2GV7Jir7OO9+o9Vw=;
        b=E2kz1FMl83tN2ABjW1mJurOeaAAcQShe1pSdN0kxvumUhNTI+TqC+JXIZb1PePIKJJ
         ysk3UkyIsJU1IyF0QX1bzY9ls8u7jx8KohqfGd2WpkooA64l95qf7m/i1PXKKqW34KQF
         NNcpCM/IAQlJ5s4gyXGZ9cMqAAd7CUf1vozzxU8QOI5PMk0lgpQQKZzWT1hz9HGssOvu
         uKSWLGBKVYuEifUSTdaTScT7ZUK/rBVNeKSLxaCEgLJEzr+DuN5HYR3Wm+13avez/Z+N
         IK5ls6J3TdDfsYGUe0WoryVlVbiG8KYRYsN6OokIHADtlhOTcp6Zf1M8DSc7jpHqbyfy
         gN6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=FzWOYssN0isWIIe9zGhm6nETA9v2GV7Jir7OO9+o9Vw=;
        b=G+mHqoPaVIkhLpPYUKiUYAKh25vWzs3c/hGMLe/oXBgglU+XeLIymYF7f1KyU/6Woh
         0wEgVrg8w5HHxUPOoa8dlzIh8WYC9zCgei61craZbdyrADQ93RcmcXCBoyNRgHdjc1OI
         xB6vOSPk7s3F1hniqHtVZ8s1IT2T4YoSS86a0VjltW19gaa+rqSUoigYyQCspuZJcbaO
         9385zNfnyGTSxNMmDxzC6oxbB41QxgIn/ajv91+LnqrMBcNT97x4fYM7JkQ4R1mii+f0
         SlJEhEJkeD3v6z94GhRlitl2JHB7iOuid/fIIIrucCNQjtdnVP26BRcZGcWmTsaS1Kdn
         Bm7Q==
X-Gm-Message-State: APjAAAV8yQogelD4Is27GaBtbd2k8jcIsWAguwnsQjOWXK84TxjeXaCP
        EAEWPrW0IqZTVYL3bBePAyUwz7oL
X-Google-Smtp-Source: APXvYqwbP80+SsW7YO75fRTZDEwGG81tyowfGAEzJg/Pgbxk1mNQT7/K4RNdohJEwe6Atj6WEY8WAQ==
X-Received: by 2002:a7b:c309:: with SMTP id k9mr1995617wmj.45.1557390675018;
        Thu, 09 May 2019 01:31:15 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id x17sm1474400wru.27.2019.05.09.01.31.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 May 2019 01:31:14 -0700 (PDT)
Date:   Thu, 9 May 2019 10:31:11 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Dave Hansen <dave.hansen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, rguenther@suse.de,
        hjl.tools@gmail.com, yang.shi@linux.alibaba.com, mhocko@suse.com,
        vbabka@suse.cz, luto@amacapital.net, x86@kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-um@lists.infradead.org, benh@kernel.crashing.org,
        paulus@samba.org, mpe@ellerman.id.au, linux-arch@vger.kernel.org,
        gxt@pku.edu.cn, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com
Subject: Re: [PATCH] [v2] x86/mpx: fix recursive munmap() corruption
Message-ID: <20190509083111.GA75918@gmail.com>
References: <20190419194747.5E1AD6DC@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190419194747.5E1AD6DC@viggo.jf.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Dave Hansen <dave.hansen@linux.intel.com> wrote:

> Reported-by: Richard Biener <rguenther@suse.de>
> Reported-by: H.J. Lu <hjl.tools@gmail.com>
> Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
> Cc: Yang Shi <yang.shi@linux.alibaba.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: x86@kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-um@lists.infradead.org
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linux-arch@vger.kernel.org
> Cc: Guan Xuetao <gxt@pku.edu.cn>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>

I've also added your:

  Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Because I suppose you intended to sign off on it?

Thanks,

	Ingo
