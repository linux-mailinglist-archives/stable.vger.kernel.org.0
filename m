Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3593D3918F7
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 15:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhEZNhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 09:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhEZNhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 09:37:54 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E8EC061574;
        Wed, 26 May 2021 06:36:21 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z38so2059587ybh.5;
        Wed, 26 May 2021 06:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iFL5PNWXPS1rh53vwqSPIbk+0/gTsiYmqV4fuzzxBUA=;
        b=FzT4OTBFNeRbMEDIl1/gOpXnFSWr1fmLO0y3S3SAfelHXi3E4MTdptws8/tgrn3BcD
         Yz4UBZYic7J2ocmgSKoCYVIqTtd6DO3Xg7Uzek4YPa+5kbE7Lu0XgSe3uOy+lkYwoFM6
         riinqBB1RW+Hr3bNvH0DKE7OK8a7zbSZdtlqomoZBHPKJIxzxpA5yTzh4ObW2gosjHp7
         NtCJtKpz+i2FFcldBI21KRXHmU65Go2VnbPjqDBtqEaDdB/iAD1fnEpAh7fnzIAorL5G
         fzpwtLGlYaJ7PuMrwZ0RVArfW/788ctt4L/mNnwfr6SWG5eNyalX4/Kq7XiOPx0NWH3k
         +2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iFL5PNWXPS1rh53vwqSPIbk+0/gTsiYmqV4fuzzxBUA=;
        b=OdZO2Zbt0aSgtZrDH2MX0YBbc37kjDiC3lAn60C4oFrbwA7C7th2Oa+03/1OEP0icC
         jzFUCUijoBLMP86XO3asExqIEb2LjafCAIT6EQ+NrOCBgdQjCh1alw8uhEUm3JIraNN5
         hrDIDtRAzEk1rPQY3QQ4Suvnnfw7l3MvZmJEV1U1bwtu2R530/38zk9g1u2oZnC99fNz
         xmCfqOBNr3fXxs3FKaaE7ArUvBxzizu5zD6BqZCa6glLtAG8RmQvIuEDdrhVL5XI0wS0
         CIDt66V8MuNA514ccUs7KJgkiF7B+eCpLXFyurz1F0WlpEDEdEgNtfKoWE/bjlMCUP+x
         FIZQ==
X-Gm-Message-State: AOAM532q0CpGpgdYE80EC5hhd3LN5NuXxBqyducOLvlSyhU4RfHhIEZH
        PWHURpM7Tbxg2GNUbI/rW6b++u0Z9BucgmeOr7c=
X-Google-Smtp-Source: ABdhPJxDriuXtomCkO+vTu34Wdq2ggIF2h//mY2b7hbw86SINmkcT/Xha8Q9csfHatY/78s4PuJ6++W1rIW+pW6iefo=
X-Received: by 2002:a25:3a41:: with SMTP id h62mr47838671yba.500.1622036180722;
 Wed, 26 May 2021 06:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210525130043.186290-1-gerald.schaefer@linux.ibm.com>
 <20210525130043.186290-2-gerald.schaefer@linux.ibm.com> <CADxRZqxdPodO8y+u=R4HB_727pjmXZFt8M5PPhg_qSsT1S-saQ@mail.gmail.com>
 <3aadc76c-3a8c-d5d6-5ad2-e83c09f08213@arm.com>
In-Reply-To: <3aadc76c-3a8c-d5d6-5ad2-e83c09f08213@arm.com>
From:   Anatoly Pugachev <matorola@gmail.com>
Date:   Wed, 26 May 2021 16:36:09 +0300
Message-ID: <CADxRZqxWkUdSJJ61WbFCjBFTq1h7nkS3O932St8nMcMpzZy=jA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()
To:     Anshuman Khandual <anshuman.khandual@arm.com>
Cc:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-sparc <sparclinux@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 26, 2021 at 3:35 PM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
> spac64 does not enable ARCH_HAS_DEBUG_VM_PGTABLE, did you enable it
> before running the test ? Did the entire test debug_vm_pgtable() run
> successfully on sparc64 ?

Ahh.. Sorry for the noise then... Thought that
CONFIG_TRANSPARENT_HUGEPAGE would be enough...
