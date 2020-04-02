Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA9819C2CB
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 15:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387752AbgDBNiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 09:38:52 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37823 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388520AbgDBNiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 09:38:52 -0400
Received: by mail-lj1-f194.google.com with SMTP id r24so3273720ljd.4
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 06:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Exs+wcW8pqgTK370fZw+VgeJY6A05eU9Q6JVvMKSZ5A=;
        b=ZtUyWy0R2Z5oSIViPZp5LZkLeggJSxUyZnS7rn5QBfuXfMm36UY64CFejQ6rDLK27M
         ck8f+uK76r+ypnQb1eJ+r2wYJfzjan9U6qOtBrsZMq3xFfGa9VZBO2JSPc9uY//+e8x/
         JKda+C2ufhRLa2BYr2vvq3BbYpG/BLEKZoUnabqg/dzTitex1dkSJK4M9AGMjwBXU3vq
         U8vW18JxWxqvX3y1ts5f2RGJYrp0xV6XHvrN7jh9XmkobXSel3F2PKWjzqIfRz6iIvLZ
         nDa6+bCrIWFQHWmdv8ICJSpVgdj64W2zx7uDldTa26YxVxR00sH9NOK4VISRbR8+ATsN
         EqoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Exs+wcW8pqgTK370fZw+VgeJY6A05eU9Q6JVvMKSZ5A=;
        b=h+sdBExsol55tvO8rXO95AKGxOfP0t6ifWe3DtGtesvOeBF3F6g8UZhsb8gHhymzuc
         GDdxwFugI8+bAKLUKHG5kuIFGvkvkWpNHiQ5drTXRjVZrZ4zlzRJewWXVWGHTTDR0MrH
         7+CWjdQzLkoDTXWHAf4EC4+0LJD699jIhXMLwUloLVFqr7YDp3c7wpMjNjt+iO9e4jAa
         xngfwT81yMrGiou0XEaZUMTqZjvuo1tM9RfCDN9liH50c2S7catG7eoXiCW+Dd1D6dbS
         Z+WFNojvNtgC81r7w0SNEjkWcCNZfnAYqTkz2kVkSik0s00Hg8Ri6qbLN7Oibl2kTmaX
         MBuA==
X-Gm-Message-State: AGi0PubWLhFxC8jksSkB1/IeVOBOGRLfvqDKuQbTV6L6rr1Qr6BYo1nE
        UOPCkkxBC4IGLIXTjMHMd3T7Jw==
X-Google-Smtp-Source: APiQypJKLmrPDaM+SDnr4wmawnXsXtnQLFd7hmufLkhv5z3INZXRH64Iqc60CAZAwjstSbK8pKN4qQ==
X-Received: by 2002:a2e:884d:: with SMTP id z13mr2088608ljj.158.1585834731008;
        Thu, 02 Apr 2020 06:38:51 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id m193sm1960052lfa.39.2020.04.02.06.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 06:38:49 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 204491020A6; Thu,  2 Apr 2020 16:38:49 +0300 (+03)
Date:   Thu, 2 Apr 2020 16:38:49 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Michal Hocko <mhocko@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkft-triage@lists.linaro.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        LTP List <ltp@lists.linux.it>
Subject: Re: mm/mremap.c : WARNING: at mm/mremap.c:211
 move_page_tables+0x5b0/0x5d0
Message-ID: <20200402133849.mmkvekzx37kw4nsj@box>
References: <CA+G9fYs1xStrrsvGbW7bc4h1a0Kjfz0_zn4c7LL7-bGZb0GH6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs1xStrrsvGbW7bc4h1a0Kjfz0_zn4c7LL7-bGZb0GH6g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 04:49:02PM +0530, Naresh Kamboju wrote:
> While running LTP mm thp01 test case on i386 kernel running on x86_64 device
> the following kernel warning was noticed multiple times.
> 
> This issue is not new,
> we have noticed on stable-rc 5.4, stable-rc 5.5 and stable-rc 5.6 branches.
> FYI, CONFIG_HAVE_MOVE_PMD=y is set on
> and total memory 2.2G as per free output.
> 
> steps to reproduce:
> --------------------
> boot i386 kernel on x86_64 device,
> cd /opt/ltp
> ./runltp -f mm
> thp01.c:98: PASS: system didn't crash.
> thp01.c:98: PASS: system didn't crash.
> thp01.c:98: PASS: system didn't crash.
> 
> [  207.317499] ------------[ cut here ]------------
> [  207.322153] WARNING: CPU: 0 PID: 18963 at mm/mremap.c:211
> move_page_tables+0x5b0/0x5d0


> Kernel config:
> https://builds.tuxbuild.com/RJ9BGpsgfPfj3Sfje8oLSw/kernel.config

Interesting. I suspect it's related to 2-level page tables in this
configuration. But I cannot immediately see how.

Could you test if enabling HIGHMEM64 fixes the issue?

Below is patch that prints some additional info:

diff --git a/mm/mremap.c b/mm/mremap.c
index d28f08a36b96..065d5ec3614a 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -208,8 +208,14 @@ static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have release it.
 	 */
-	if (WARN_ON(!pmd_none(*new_pmd)))
+	if (WARN_ON(!pmd_none(*new_pmd))) {
+		dump_vma(vma);
+		printk("old_addr: %#lx, new_addr: %#lx, old_end: %#lx\n",
+				old_addr, new_addr, old_end);
+		printk("old_pmd: %#lx", pmd_val(*old_pmd));
+		printk("new_pmd: %#lx", pmd_val(*new_pmd));
 		return false;
+	}
 
 	/*
 	 * We don't have to worry about the ordering of src and dst
-- 
 Kirill A. Shutemov
