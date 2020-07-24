Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDD822C531
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 14:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgGXMbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 08:31:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:20959 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbgGXMbc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 08:31:32 -0400
IronPort-SDR: 8Gb8/J5gYuift077MFsNxO9evZ/tzMRUNjXx72hFXXIqC1lGQ5W7+82YmOCLuRqFkrh0qx3P86
 8YaRdUUGpGJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="148192025"
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="148192025"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 05:31:30 -0700
IronPort-SDR: 1P6yIqwiRD55Uy/uBxM5RF2Ykrdr2xxLQum0uxGcomHV1iB8j7r2R+akIk8tJ/IkkcnMVNoIR8
 3RNCiioDeFWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="311388655"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jul 2020 05:31:29 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 9112A5C0D00; Fri, 24 Jul 2020 15:31:00 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gem: Delay tracking the GEM context until it is registered
In-Reply-To: <159559237550.21069.11909922893997723896@build.alporthouse.com>
References: <20200723183348.4037-1-chris@chris-wilson.co.uk> <159552931718.21069.13813749151778428706@build.alporthouse.com> <87tuxx1610.fsf@gaia.fi.intel.com> <159559237550.21069.11909922893997723896@build.alporthouse.com>
Date:   Fri, 24 Jul 2020 15:31:00 +0300
Message-ID: <87lfj914e3.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> Quoting Mika Kuoppala (2020-07-24 12:55:39)
>> Chris Wilson <chris@chris-wilson.co.uk> writes:
>> 
>> > Quoting Chris Wilson (2020-07-23 19:33:48)
>> >> Avoid exposing a partially constructed context by deferring the
>> >> list_add() from the initial construction to the end of registration.
>> >> Otherwise, if we peek into the list of contexts from inside debugfs, we
>> >> may see the partially constructed context and change down some dangling
>> >
>> > s/change/chase/
>> 
>> that.
>> 
>> Are you sure about the fixes as it is not the commit that
>> actually introduces the registration into context.list?
>> 
>> For me it looks like it is a4e7ccdac38e.
>
> The one I picked was where we started adding more context setup after
> the final step of list_add in __create_context(). More apropos would be
> 3aa9945a528e ("drm/i915: Separate GEM context construction and registration to userspace")
> in the same kernel.

Ok, thanks for clearing that out.

The i915_perf iteration seems to not get hurt either so,

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

>
> In the other direction, we have
> f6e8aa387171 ("drm/i915: Report the number of closed vma held by each context in debugfs")
> where we start using the contexts.list in debugfs.
>
> In a4e7ccdac38e we are only moving the list_add(&ctx->link) around in
> __create_context().
> -Chris
