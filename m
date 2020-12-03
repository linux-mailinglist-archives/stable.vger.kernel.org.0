Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B772CE189
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 23:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgLCW0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 17:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCW0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 17:26:19 -0500
Date:   Thu, 3 Dec 2020 14:25:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607034338;
        bh=Ax4Wt0Tiiw6ty+hKE7knRXHEyQvkXrcQRlGxKC1Qgcg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=D1CFoYa3jVoUV2wqynG9Wn22SwA3cexgqwgVEfG016b9SE6Cpn5CDLMnYY4ScDekn
         YXKEtJZDxRIsoWYcqwxZ/ZnTG346Z+4NyC+yGP/RuRrXfuL9Q/xZ6tfCP+8anpg7og
         g/JiV16Y6ZHp37SppqN9NfFWNi081bTOQ73e3B1s=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Liu Zixian <liuzixian4@huawei.com>
Cc:     <linmiaohe@huawei.com>, <louhongxiang@huawei.com>,
        <linux-mm@kvack.org>, <hushiyuan@huawei.com>,
        <stable@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] fix mmap return value when vma is merged after
 call_mmap()
Message-Id: <20201203142537.c69ab696573e63d54becff07@linux-foundation.org>
In-Reply-To: <20201203085350.22624-1-liuzixian4@huawei.com>
References: <20201203085350.22624-1-liuzixian4@huawei.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 3 Dec 2020 16:53:50 +0800 Liu Zixian <liuzixian4@huawei.com> wrote:

> On success, mmap should return the begin address of newly mapped area,
> but patch "mm: mmap: merge vma after call_mmap() if possible"
> set vm_start of newly merged vma to return value addr.
> Users of mmap will get wrong address if vma is merged after call_mmap().
> We fix this by moving the assignment to addr before merging vma.

Let's cc David and Jason, as they commented on v1.

You cc'ed stable@vger.kernel.org on the email, but there's no
cc:stable@vger.kernel.org in the changelog tags.  There should be.

Has this bug actually been observed at runtime, or is it a theoretical
from-code-inspection thing?


