Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521B720F943
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 18:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbgF3QQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 12:16:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:38320 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbgF3QQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 12:16:56 -0400
IronPort-SDR: qFRaaRxvHvTcTrOy8P3aeYu0DN/pKXF71otIgS3wsi6g8uiloahPd3QvssrprgW0s+ValEUxke
 hnDWnjyfK4sw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="143780342"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="143780342"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 09:16:55 -0700
IronPort-SDR: Lv9bCeY/7NQ13ysxDbSsLb+b6p9L10BwalE1ZbOrEJtEEaCFB7JlzGcTGfu5HHLXXzy44tg9nZ
 /P07SgikZenA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="312411802"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga008.jf.intel.com with ESMTP; 30 Jun 2020 09:16:54 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id D09C55C0D17; Tue, 30 Jun 2020 19:16:43 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Skip stale object handle for debugfs per-file-stats
In-Reply-To: <20200630152724.3734-1-chris@chris-wilson.co.uk>
References: <20200630152724.3734-1-chris@chris-wilson.co.uk>
Date:   Tue, 30 Jun 2020 19:16:43 +0300
Message-ID: <87imf84jh0.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> As we close a handle GEM object, we update the drm_file's idr with an
> error pointer to indicate the in-progress closure, and finally set it to

The error pointer part stage seems to be missing.
But the finding is valid.

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> NULL. If we read the idr directly, we may then see an invalid object
> pointer, and in our debugfs per_file_stats() we therefore need to
> protect against the entry being invalid.
>
> [ 1016.651637] RIP: 0010:per_file_stats+0xe/0x16e
> [ 1016.651646] Code: d2 41 0f b6 8e 69 8c 00 00 48 89 df 48 c7 c6 7b 74 8c be 31 c0 e8 0c 89 cf ff eb d2 0f 1f 44 00 00 55 48 89 e5 41
> 57 41 56 53 <8b> 06 85 c0 0f 84 4d 01 00 00 49 89 d6 48 89 f3 3d ff ff ff 7f 73
> [ 1016.651651] RSP: 0018:ffffad3a01337ba0 EFLAGS: 00010293
> [ 1016.651656] RAX: 0000000000000018 RBX: ffff96fe040d65e0 RCX: 0000000000000002
> [ 1016.651660] RDX: ffffad3a01337c50 RSI: 0000000000000000 RDI: 00000000000001e8
> [ 1016.651663] RBP: ffffad3a01337bb8 R08: 0000000000000000 R09: 00000000000001c0
> [ 1016.651667] R10: 0000000000000000 R11: ffffffffbdbe5fce R12: 0000000000000000
> [ 1016.651671] R13: ffffffffbdbe5fce R14: ffffad3a01337c50 R15: 0000000000000001
> [ 1016.651676] FS:  00007a597e2d7480(0000) GS:ffff96ff3bb00000(0000) knlGS:0000000000000000
> [ 1016.651680] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1016.651683] CR2: 0000000000000000 CR3: 0000000171fc2001 CR4: 00000000003606e0
> [ 1016.651687] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1016.651690] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1016.651693] Call Trace:
> [ 1016.651693] Call Trace:
> [ 1016.651703]  idr_for_each+0x8a/0xe8
> [ 1016.651711]  i915_gem_object_info+0x2a3/0x3eb
> [ 1016.651720]  seq_read+0x162/0x3ca
> [ 1016.651727]  full_proxy_read+0x5b/0x8d
> [ 1016.651733]  __vfs_read+0x45/0x1bb
> [ 1016.651741]  vfs_read+0xc9/0x15e
> [ 1016.651746]  ksys_read+0x7e/0xde
> [ 1016.651752]  do_syscall_64+0x54/0x68
> [ 1016.651758]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: a8c15954d64a ("drm/i915: Protect debugfs per_file_stats with RCU lock")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/i915_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> index 8594a8ef08ce..9ca94a435b75 100644
> --- a/drivers/gpu/drm/i915/i915_debugfs.c
> +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> @@ -230,7 +230,7 @@ static int per_file_stats(int id, void *ptr, void *data)
>  	struct file_stats *stats = data;
>  	struct i915_vma *vma;
>  
> -	if (!kref_get_unless_zero(&obj->base.refcount))
> +	if (IS_ERR_OR_NULL(obj) || !kref_get_unless_zero(&obj->base.refcount))
>  		return 0;
>  
>  	stats->count++;
> -- 
> 2.20.1
