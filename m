Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2633DD0AE
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 08:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhHBGiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 02:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbhHBGiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 02:38:05 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E369C0613D5
        for <stable@vger.kernel.org>; Sun,  1 Aug 2021 23:37:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GdSxG32lFz9sT6;
        Mon,  2 Aug 2021 16:37:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1627886274;
        bh=0uXfwbhBCmX/Vg3rWzcrO7cxScT07wbJRsldPrQjcJg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=UlyAEEuqpUr7HyNxGmr/t+o9RMm53ShS+XC28yL19BQiVGDFZzrBOz4fJJQseGlzi
         4Kq6ZJ+SfaTnw7QipHwL+/CR/4x2CN819spyjvnNXy325llTLEu4EKc4dgXy1XYjnO
         UByIo8RBqrAiGjfX+JwnmxFKvkwleB17R+3av8LMjSxEDhtmremWL1NEbQ18IYzaYM
         C3LqTv7dzTJoomE+6DR+qBHIunwvb2hy7knTYawsTa5WAP7fBQTxekQSn9uqw69R8V
         0AFgwH4pvkuoPv2+6/s9wz19J+Rx7EUwtxDRC76NIrCHqETnh1sFb4hrVrQZAREihy
         Fuw/vbYGtly9g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        stable@vger.kernel.org,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc/xive: Do not skip CPU-less nodes when creating
 the IPIs
In-Reply-To: <20210629131542.743888-1-clg@kaod.org>
References: <20210629131542.743888-1-clg@kaod.org>
Date:   Mon, 02 Aug 2021 16:37:53 +1000
Message-ID: <87a6m0l5by.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

C=C3=A9dric Le Goater <clg@kaod.org> writes:
> On PowerVM, CPU-less nodes can be populated with hot-plugged CPUs at
> runtime. Today, the IPI is not created for such nodes, and hot-plugged
> CPUs use a bogus IPI, which leads to soft lockups.
>
> We could create the node IPI on demand but it is a bit complex because
> this code would be called under bringup_up() and some IRQ locking is
> being done. The simplest solution is to create the IPIs for all nodes
> at startup.
>
> Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
> Cc: stable@vger.kernel.org # v5.13
> Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: C=C3=A9dric Le Goater <clg@kaod.org>
> ---
>
> This patch breaks old versions of irqbalance (<=3D v1.4). Possible nodes
> are collected from /sys/devices/system/node/ but CPU-less nodes are
> not listed there. When interrupts are scanned, the link representing
> the node structure is NULL and segfault occurs.

Breaking userspace is usually frowned upon, even if it is irqbalance.

If CPU-less nodes appeared in /sys/devices/system/node would that fix
it? Could we do that or is that not possible for other reasons?

> Version 1.7 seems immune.=20

Which was released in August 2020.

Looks like some distros still ship 1.6, I take it you're not sure if
that is broken or not.

cheers
