Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BABF44500E
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 09:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhKDIVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 04:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhKDIVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 04:21:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 361346109F;
        Thu,  4 Nov 2021 08:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636013943;
        bh=39bmnQD+ialegzjYuN+MfJdUlFzG0QI1Y/efWM8IaRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e0xmht4BEtvIt4tkkSM/k07FA+pbFHXjyWh+DR9mhncTebVq6q7poxG7fdQpHPeCa
         ZJCEvFZvGnQtyvhXmSNuB9m+SHToKzWjOpCOqeL6GSj1TD+Ir/VUGmd2RDOfBn9DK1
         cU3/xJIEBpJ82i5HXAcG/3+Sdp986MUJs0sO7+dA=
Date:   Thu, 4 Nov 2021 09:19:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     hughd@google.com, sunhao.th@gmail.com, willy@infradead.org,
        kirill.shutemov@linux.intel.com, songliubraving@fb.com,
        andrea.righi@canonical.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable 5.10 PATCH] mm: khugepaged: skip huge page collapse for
 special files
Message-ID: <YYOXdQbeNGHb0ewM@kroah.com>
References: <20211103202258.3564-1-shy828301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103202258.3564-1-shy828301@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 01:22:58PM -0700, Yang Shi wrote:
> commit a4aeaa06d45e90f9b279f0b09de84bd00006e733 upstream.
> 
> The read-only THP for filesystems will collapse THP for files opened
> readonly and mapped with VM_EXEC.  The intended usecase is to avoid TLB
> misses for large text segments.  But it doesn't restrict the file types
> so a THP could be collapsed for a non-regular file, for example, block
> device, if it is opened readonly and mapped with EXEC permission.  This
> may cause bugs, like [1] and [2].
> 
> This is definitely not the intended usecase, so just collapse THP for
> regular files in order to close the attack surface.
> 
> [shy828301@gmail.com: fix vm_file check [3]]

Now queued up, thanks.

greg k-h
