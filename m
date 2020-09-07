Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D5826019D
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgIGRJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729826AbgIGRJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 13:09:13 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD98206B8;
        Mon,  7 Sep 2020 17:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599498552;
        bh=c+LatMKoM5/1BtRYscz0019UW7w/K1nTQivhKbKM+5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yZUdJ2q+CoFJrKpQif7Uu7/CVm3k0fTvJEpPo2b076qALItHtgWLU8Vlioo9h2dCm
         n7jtruYdt9WQgX6MMRzzhTaGZMCfSpIxra9rrOY37S+ebdGDJ4PTJCjltfLVt4iruz
         K5o/ZS2od70QbhK4hxG6TRP5XQsNOyQLo6JUhBew=
Date:   Mon, 7 Sep 2020 13:09:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     gregkh@linuxfoundation.org, alex.williamson@redhat.com,
        cohuck@redhat.com, peterx@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu,
        vsirnapalli@vmware.com
Subject: Re: [PATCH v5.4.y 0/3] vfio: Fix for CVE-2020-12888
Message-ID: <20200907170911.GM8670@sasha-vm>
References: <1599401277-32172-1-git-send-email-akaher@vmware.com>
 <1599401277-32172-4-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1599401277-32172-4-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 06, 2020 at 07:37:57PM +0530, Ajay Kaher wrote:
>CVE-2020-12888 Kernel: vfio: access to disabled MMIO space of some
>devices may lead to DoS scenario
>
>The VFIO modules allow users (guest VMs) to enable or disable access to the
>devices' MMIO memory address spaces. If a user attempts to access (read/write)
>the devices' MMIO address space when it is disabled, some h/w devices issue an
>interrupt to the CPU to indicate a fatal error condition, crashing the system.
>This flaw allows a guest user or process to crash the host system resulting in
>a denial of service.
>
>Patch 1/ is to force the user fault if PFNMAP vma might be DMA mapped
>before user access.
>
>Patch 2/ setup a vm_ops handler to support dynamic faulting instead of calling
>remap_pfn_range(). Also provides a list of vmas actively mapping the area which
>can later use to invalidate those mappings.
>
>Patch 3/ block the user from accessing memory spaces which is disabled by using
>new vma list support to zap, or invalidate, those memory mappings in order to
>force them to be faulted back in on access.

I've queued this and the 4.19 backports, thanks!

-- 
Thanks,
Sasha
