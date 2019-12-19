Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD8812633E
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 14:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfLSNRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 08:17:02 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:45930 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfLSNRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 08:17:02 -0500
Received: by mail-qv1-f66.google.com with SMTP id l14so2167965qvu.12
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 05:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=Czyg8raj0B+YOEM11FuK7yWFRFG2cJHM8oF7MR8OthI=;
        b=knUifbxm9XpiUMsx5PSkNk7Fh6cV2bDoAwhEMKu5B+L+utmXgMfxVaHdc1Qvn8k0Uh
         gMroxCEny8JfJmRlo1YCaabTSctr5+8LgXbhCLjmBtJ3V8MN8pkhcYh0yoIMOpybqX/i
         w/wlJsi7vTOSPVOoaPtQUUnVbmVS9QH4e5yvtwbMEYerfsoV2umQQqiRc8SJVo0McQY/
         by5yJ09Yci9LaC12m3ztDSlEzbtviMVeo4UVcl+Yzo0BIF76FQ3a86UPILr/fztLg5XX
         d8SUJK+8hIDyrjU5t04X25Auwx7kyx+/2T8HJPJLZuuGV1BwjGp41rn6El+nEjch5NkE
         583g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=Czyg8raj0B+YOEM11FuK7yWFRFG2cJHM8oF7MR8OthI=;
        b=DQanrCmEk38nLqW8Gvs1iAKUhF096hKf57O/rUOMlwYTr8cpVCH++wQQh/5Wcp813N
         mBwqUIYBRfx6m4kxkOI0g/hA8VttkKEGRVQxEc539CxG0m1DZjnMfVhzUPl1k9R1gi9P
         2tymxFbLUrg+MvCXr6yvsWE+NrjRyt7uvpYroBBmZ9t2mGe4lzNigP/qSEupKYqEtypj
         36bWnzfxtJuSxMXIbrVXeGeD8kVg8w4JfVKTKP1k1BS0BHA/7/cjmIX4MxLlZyORDcs3
         LsgycR7P0DvwmmtyI+EzHsheZ4L3zm3Mx9r8PgB+KzMYgL05D2l93cYrjmmAkVRti88B
         NURg==
X-Gm-Message-State: APjAAAW4YO+O/AhIVnE9yZzVPuioRWKpspxP1AI8ijH9FXVlAHWVVDHG
        qPlxA+En01cM4JEuTu4YGKa4ybm53Ss=
X-Google-Smtp-Source: APXvYqwJTdKi20YBRpmYBhkBYp1tZ6kHGBosfFgFkRzdLWFGYQS/CHgxr+iSHDITbWRvRbT6sOavMw==
X-Received: by 2002:ad4:4f84:: with SMTP id em4mr7510252qvb.119.1576761420649;
        Thu, 19 Dec 2019 05:17:00 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id e19sm1892659qtc.75.2019.12.19.05.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 05:17:00 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] mm, debug_pagealloc: don't rely on static keys too early
Date:   Thu, 19 Dec 2019 08:16:59 -0500
Message-Id: <83B24C03-1484-4DD6-9B42-029FF1B27287@lca.pw>
References: <20191219130612.23171-1-vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>
In-Reply-To: <20191219130612.23171-1-vbabka@suse.cz>
To:     Vlastimil Babka <vbabka@suse.cz>
X-Mailer: iPhone Mail (17C54)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 19, 2019, at 8:06 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
>=20
> Commit 96a2b03f281d ("mm, debug_pagelloc: use static keys to enable debugg=
ing")
> has introduced a static key to reduce overhead when debug_pagealloc is com=
piled
> in but not enabled. It relied on the assumption that jump_label_init() is
> called before parse_early_param() as in start_kernel(), so when the
> "debug_pagealloc=3Don" option is parsed, it is safe to enable the static k=
ey.
>=20
> However, it turns out multiple architectures call parse_early_param() earl=
ier
> from their setup_arch(). x86 also calls jump_label_init() even earlier, so=
 no
> issue was found while testing the commit, but same is not true for e.g. pp=
c64
> and s390 where the kernel would not boot with debug_pagealloc=3Don as foun=
d by
> our QA.

This was daily tested on linux-next here for those arches and never saw an i=
ssue. Are you able to reproduce it on mainline or linux-next?=
