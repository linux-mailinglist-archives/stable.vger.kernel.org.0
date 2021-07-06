Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE59A3BDBA4
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 18:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhGFQrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 12:47:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:52110 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230048AbhGFQrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 12:47:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10037"; a="230883143"
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="230883143"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 09:44:53 -0700
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="457133171"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 09:44:52 -0700
Date:   Tue, 6 Jul 2021 09:44:51 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Ding Hui <dinghui@sangfor.com.cn>
Cc:     bp@alien8.de, bp@suse.de, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterz@infradead.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, youquan.song@intel.com, huangcun@sangfor.com.cn,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/mce: Fix endless loop when run task works after
 #MC
Message-ID: <20210706164451.GA1289248@agluck-desk2.amr.corp.intel.com>
References: <20210706121606.15864-1-dinghui@sangfor.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706121606.15864-1-dinghui@sangfor.com.cn>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 06, 2021 at 08:16:06PM +0800, Ding Hui wrote:
> Recently we encounter multi #MC on the same task when it's
> task_work_run() has not been called, current->mce_kill_me was
> added to task_works list more than once, that make a circular
> linked task_works, so task_work_run() will do a endless loop.

I saw the same and posted a similar fix a while back:

https://www.spinics.net/lists/linux-mm/msg251006.html

It didn't get merged because some validation tests began failing
around the same time.  I'm now pretty sure I understand what happened
with those other tests.

I'll post my updated version (second patch in a three part series)
later today.

> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c

> +	if (!cmpxchg(&current->mce_kill_me.func, NULL, ch.func)) {
> +		current->mce_addr = m->addr;
> +		current->mce_kflags = m->kflags;
> +		current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
> +		current->mce_whole_page = whole_page(m);

You don't need an atomic cmpxchg here (nor the WRITE_ONCE() to clear it).
The task is operating on its own task_struct. Nobody else should touch
the mce_kill_me field.

-Tony
