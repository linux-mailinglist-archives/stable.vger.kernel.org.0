Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B66612C57
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 19:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJ3Sw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 14:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJ3Sw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 14:52:57 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4B595B3;
        Sun, 30 Oct 2022 11:52:56 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b29so8914411pfp.13;
        Sun, 30 Oct 2022 11:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8elokwRQaKyAP0dM+0zhrI4gx5N3/CeBtqzPukuUnAw=;
        b=YUcGwd0QsHpWm5d+rOP1CAI28Pyn+kV7aCrc0+3OM+5XkOTwufAR2n42u8HF7hnyaI
         jC5RpPKjR51SkhWwgPkoC0dYeQLZo00ObVmsNzX4s74Fp6DkVJnJq85PUD9JnLaLJRVS
         0weUrPp9RGHpSE7bb/3XvL+E0xyv+I95LDYSh9HIi2+NbubdlEdoiAvFCsDdSeBWhTe8
         mfPWHjC8Fga8Rl3vtLtWOtwRgFSa973dzYcqET8G0cwQqloY9mqTULWcX2EwylEHWbXd
         JG50hMNU3R6bZ6fEV0fvkKxsBHTxYrFBo55ANUbWTj2MDirSLDcvd/SB5oAV8i6M5BDK
         tqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8elokwRQaKyAP0dM+0zhrI4gx5N3/CeBtqzPukuUnAw=;
        b=GLiMC6IYFV+BJfh+53N3X35JOkJjEGvMo2RiWLCCkKKSjFWl50mbTuU5dSCfwAgEAZ
         kIC7goXvixb2CldpJCiIv/0rXuTKzSarYZdxZlVODHFddP0XVq4ZDf6NVJ6+ok/GQYc6
         AIRvVTt0MCd7JfXJCa+0kh0CpkDk1EEHmo120DhT3sbKy4+/IOeTT8rZ3z4yG3h8zLys
         hchNnzyV3d2mPAbiFUjmfFsXavmje3AINncbzMZ5PvoyQ5JNhZHfxBgat2QQzIZD56Zs
         w0z79+UWjhd3GgmieW3gY1+xHb1iPjkZA5FIKatmjIOAth86KtG0UHfPN0RZzTCt6cDo
         G17Q==
X-Gm-Message-State: ACrzQf0Y0dMiez3FKJb3stDoH4AQvmL4NZFB6XmZNywxZjFie5RitoFi
        J+DdLN0HyqohFFlQNboB7yo=
X-Google-Smtp-Source: AMsMyM6jIFTKWkHx2DeQKawqkSo5aIPaMrRPSIaPPkTGyp+gAAy5hs16vCm9pFqP9WPtnZCljLFS4w==
X-Received: by 2002:a63:d90c:0:b0:462:cfa2:285b with SMTP id r12-20020a63d90c000000b00462cfa2285bmr9215780pgg.202.1667155975363;
        Sun, 30 Oct 2022 11:52:55 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id k3-20020a170902ce0300b00176b63535adsm2953022plg.260.2022.10.30.11.52.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Oct 2022 11:52:54 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <Y17F50ktT9fZw4do@x1n>
Date:   Sun, 30 Oct 2022 11:52:52 -0700
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>,
        "# 5 . 10+" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
Message-Id: <3232338E-77BB-42A8-9A25-5A4AD61FD4B2@gmail.com>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1mpwKpwsiN6u6r7@x1n> <Y1nImUVseAOpXwPv@monkey> <Y1nbErXmHkyrzt8F@x1n>
 <Y1vz7VvQ5zg5KTxk@monkey> <Y1v/x5RRpRjU4b/W@x1n> <Y1xGzR/nHQTJxTCj@monkey>
 <Y1xjyLWNCK7p0XSv@x1n> <Y13CO8iIGfDnV24u@monkey>
 <7048D2B5-5FA5-4F72-8FDC-A02411CFD71D@gmail.com> <Y17F50ktT9fZw4do@x1n>
To:     Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Oct 30, 2022, at 11:43 AM, Peter Xu <peterx@redhat.com> wrote:

> The loop comes from 7e027b14d53e ("vm: simplify unmap_vmas() calling
> convention", 2012-05-06), where zap_page_range() was used to replace a call
> to unmap_vmas() because the patch wanted to eliminate the zap details
> pointer for unmap_vmas(), which makes sense.
> 
> I didn't check the old code, but from what I can tell (and also as Mike
> pointed out) I don't think zap_page_range() in the lastest code base is
> ever used on multi-vma at all.  Otherwise the mmu notifier is already
> broken - see mmu_notifier_range_init() where the vma pointer is also part
> of the notification.
> 
> Perhaps we should just remove the loop?

There is already zap_page_range_single() that does exactly that. Just need
to export it.

