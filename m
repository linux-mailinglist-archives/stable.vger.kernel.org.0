Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B2439A18
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 04:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbfFHCOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 22:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728860AbfFHCOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 22:14:08 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5D9730842A8;
        Sat,  8 Jun 2019 02:14:07 +0000 (UTC)
Received: from localhost (ovpn-12-31.pek2.redhat.com [10.72.12.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F9236085B;
        Sat,  8 Jun 2019 02:14:06 +0000 (UTC)
Date:   Sat, 8 Jun 2019 10:14:04 +0800
From:   Baoquan He <bhe@redhat.com>
To:     tglx@linutronix.de, stable@vger.kernel.org, mingo@kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        keescook@chromium.org, bp@suse.de, luto@kernel.org, hpa@zytor.com,
        kirill@linux.intel.com, dave.hansen@linux.intel.com
Cc:     linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/mm/KASLR: Compute the size of the vmemmap
 section properly
Message-ID: <20190608021404.GA26148@MiWiFi-R3L-srv>
References: <20190523025744.3756-1-bhe@redhat.com>
 <tip-00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff@git.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Sat, 08 Jun 2019 02:14:08 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/07/19 at 02:16pm, tip-bot for Baoquan He wrote:
> Commit-ID:  00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff
> Gitweb:     https://git.kernel.org/tip/00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff
> Author:     Baoquan He <bhe@redhat.com>
> AuthorDate: Thu, 23 May 2019 10:57:44 +0800
> Committer:  Borislav Petkov <bp@suse.de>
> CommitDate: Fri, 7 Jun 2019 23:12:13 +0200
> 
> x86/mm/KASLR: Compute the size of the vmemmap section properly
> 
> The size of the vmemmap section is hardcoded to 1 TB to support the
> maximum amount of system RAM in 4-level paging mode - 64 TB.
> 
> However, 1 TB is not enough for vmemmap in 5-level paging mode. Assuming
> the size of struct page is 64 Bytes, to support 4 PB system RAM in 5-level,
> 64 TB of vmemmap area is needed:
> 
>   4 * 1000^5 PB / 4096 bytes page size * 64 bytes per page struct / 1000^4 TB = 62.5 TB.

Thanks for picking this, Boris.

Here, 4PB = 4*2^50 = 4*1024^5, the vmemmap should be 64 TB, am I right?

> 
> This hardcoding may cause vmemmap to corrupt the following
> cpu_entry_area section, if KASLR puts vmemmap very close to it and the
> actual vmemmap size is bigger than 1 TB.
