Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1992E28B6
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 20:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgLXTR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Dec 2020 14:17:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728816AbgLXTR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Dec 2020 14:17:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608837390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PasbZTjuQhYnZNax5DZipjOOp29fDts/YAjesb40hbc=;
        b=ExEAI920rKwWovJH2w9XvZg+1ncAQQIF6SANQCn+XJSdESHjnQof25NEMKCJaWwlgnDYj+
        HEhZkzKfKIolYfpiqbFqWBOMXw7PAfDTKCecx7WyVRfoaf7H766iw96I47C8HJhdgQQX88
        hnPa4Cld9QYTx69suN0V3WrvDMyqco4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-ZGdFvvwtOxywAdkNvbWt5A-1; Thu, 24 Dec 2020 14:16:22 -0500
X-MC-Unique: ZGdFvvwtOxywAdkNvbWt5A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 741F459;
        Thu, 24 Dec 2020 19:16:20 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1990E189CE;
        Thu, 24 Dec 2020 19:16:17 +0000 (UTC)
Date:   Thu, 24 Dec 2020 14:16:16 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Yu Zhao <yuzhao@google.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+TpAAuGm7KSLr8G@redhat.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
 <X+P2OnR+ipY8d2qL@redhat.com>
 <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
 <X+QMKC7jPEeThjB1@google.com>
 <X+QShVIUbYKAsc35@redhat.com>
 <06DF7858-1447-4531-9B5C-E20C44F0AF54@gmail.com>
 <X+TiyehLLKEUO7Bs@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+TiyehLLKEUO7Bs@redhat.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 24, 2020 at 01:49:45PM -0500, Andrea Arcangeli wrote:
> Without the above, can't the CPU decrement the tlb_flush_pending while
> the IPI to ack didn't arrive yet in csd_lock_wait?

Ehm: csd_lock_wait has smp_acquire__after_ctrl_dep() so the write side
looks ok after all sorry.

