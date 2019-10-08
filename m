Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFA4D0303
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 23:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfJHVpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 17:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfJHVpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 17:45:52 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E38F20679;
        Tue,  8 Oct 2019 21:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570571151;
        bh=2v0LiAqGVD9v2rJuzyPSO0S39KLfeE68Grp9frtvnIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GkE3klYYnpawJFQHnjbBqNe+RpZcy+ucu0q5MYz4GQ75UUDTTHgVV3aIG0tGTUFIE
         IPQ35//l5k4V+CVaMH78ed/xmXEUyoTjtuDQyyQaoQR9ddm/aghdEN53nrVdZlc/IO
         8ATKHRDZ+KxxVRQofmSTF2JL7Po5OdXqnp/Gcx/U=
Date:   Tue, 8 Oct 2019 17:45:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     clg@kaod.org, mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: XIVE: Free
 escalation interrupts before" failed to apply to 4.19-stable tree
Message-ID: <20191008214550.GE1396@sasha-vm>
References: <1570519208179101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1570519208179101@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 09:20:08AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 237aed48c642328ff0ab19b63423634340224a06 Mon Sep 17 00:00:00 2001
>From: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
>Date: Tue, 6 Aug 2019 19:25:38 +0200
>Subject: [PATCH] KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before
> disabling the VP
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>When a vCPU is brought done, the XIVE VP (Virtual Processor) is first
>disabled and then the event notification queues are freed. When freeing
>the queues, we check for possible escalation interrupts and free them
>also.
>
>But when a XIVE VP is disabled, the underlying XIVE ENDs also are
>disabled in OPAL. When an END (Event Notification Descriptor) is
>disabled, its ESB pages (ESn and ESe) are disabled and loads return all
>1s. Which means that any access on the ESB page of the escalation
>interrupt will return invalid values.
>
>When an interrupt is freed, the shutdown handler computes a 'saved_p'
>field from the value returned by a load in xive_do_source_set_mask().
>This value is incorrect for escalation interrupts for the reason
>described above.
>
>This has no impact on Linux/KVM today because we don't make use of it
>but we will introduce in future changes a xive_get_irqchip_state()
>handler. This handler will use the 'saved_p' field to return the state
>of an interrupt and 'saved_p' being incorrect, softlockup will occur.
>
>Fix the vCPU cleanup sequence by first freeing the escalation interrupts
>if any, then disable the XIVE VP and last free the queues.
>
>Fixes: 90c73795afa2 ("KVM: PPC: Book3S HV: Add a new KVM device for the XIVE native exploitation mode")
>Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
>Cc: stable@vger.kernel.org # v4.12+
>Signed-off-by: Cédric Le Goater <clg@kaod.org>
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/20190806172538.5087-1-clg@kaod.org

I've dropped the xive native part on 4.19 and 4.14 because 90c73795afa24
("KVM: PPC: Book3S HV: Add a new KVM device for the XIVE native
exploitation mode") isn't there.

-- 
Thanks,
Sasha
