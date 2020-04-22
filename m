Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A551B42C1
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgDVLFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgDVLF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 07:05:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD5AB2076E;
        Wed, 22 Apr 2020 11:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587553528;
        bh=4MnyMmkAl/EqqxNgkyGui3OAOBpCB1BjyNAYWxVtRPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A/JTGIrWnpiXib7VYLPnVA8Y0FdMixdMiXBEqxIureN5dh5gi/qIJiBbTinXyXwxa
         5sxDMeeFyYxJxvmhIN82sdppx+JEjwZixbAuV3FNxOL498wCVv6LXplntqy0Bfei56
         sQsz2V3ug7BF5Jylv+qxW5saHwblk1Y1KRBlIR+4=
Date:   Wed, 22 Apr 2020 13:05:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.6 096/166] x86/xen: Make the boot CPU idle task reliable
Message-ID: <20200422110525.GA3128451@kroah.com>
References: <20200422095047.669225321@linuxfoundation.org>
 <20200422095059.319186761@linuxfoundation.org>
 <48afe770-83c3-03c0-c21f-334ab2056ea3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48afe770-83c3-03c0-c21f-334ab2056ea3@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 12:45:32PM +0200, Jürgen Groß wrote:
> On 22.04.20 11:57, Greg Kroah-Hartman wrote:
> > From: Miroslav Benes <mbenes@suse.cz>
> > 
> > [ Upstream commit 2f62f36e62daec43aa7b9633ef7f18e042a80bed ]
> > 
> > The unwinder reports the boot CPU idle task's stack on XEN PV as
> > unreliable, which affects at least live patching. There are two reasons
> > for this. First, the task does not follow the x86 convention that its
> > stack starts at the offset right below saved pt_regs. It allows the
> > unwinder to easily detect the end of the stack and verify it. Second,
> > startup_xen() function does not store the return address before jumping
> > to xen_start_kernel() which confuses the unwinder.
> > 
> > Amend both issues by moving the starting point of initial stack in
> > startup_xen() and storing the return address before the jump, which is
> > exactly what call instruction does.
> > 
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > Reviewed-by: Juergen Gross <jgross@suse.com>
> > Signed-off-by: Juergen Gross <jgross@suse.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> You'll need upstream d6f34f4c6b4a96 ("x86/xen: fix booting 32-bit pv
> guest"), too.

Thanks for that, now queued up.

greg k-h
