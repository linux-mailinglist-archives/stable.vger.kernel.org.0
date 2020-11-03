Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ED22A47CE
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgKCOQ5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 3 Nov 2020 09:16:57 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:64681 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729636AbgKCOQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:16:18 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22881066-1500050 
        for multiple; Tue, 03 Nov 2020 14:16:03 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87361qfw3e.fsf@gaia.fi.intel.com>
References: <20201102221057.29626-1-chris@chris-wilson.co.uk> <20201102221057.29626-2-chris@chris-wilson.co.uk> <87361qfw3e.fsf@gaia.fi.intel.com>
Subject: Re: [PATCH 2/2] drm/i915/gt: Flush xcs before tgl breadcrumbs
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Tue, 03 Nov 2020 14:16:00 +0000
Message-ID: <160441296035.21466.9227014206344926879@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Mika Kuoppala (2020-11-03 12:44:53)
> Chris Wilson <chris@chris-wilson.co.uk> writes:
> 
> > In a simple test case that writes to scratch and then busy-waits for the
> > batch to be signaled, we observe that the signal is before the write is
> > posted. That is bad news.
> >
> > Splitting the flush + write_dword into two separate flush_dw prevents
> > the issue from being reproduced, we can presume the post-sync op is not
> > so post-sync.
> >
> 
> Only thing that is mildly surpricing is that first one doesnt
> need postop write.

The MI_FLUSH_DW is stalling, so the second will^W should wait for the
first to complete. (And we don't want to do the write from the first as
we observe that write is too early.)
-Chris
