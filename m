Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E5C48BEAD
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 07:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351050AbiALGqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 01:46:13 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60690 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351044AbiALGqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 01:46:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60BECCE1BCF;
        Wed, 12 Jan 2022 06:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B469C36AE9;
        Wed, 12 Jan 2022 06:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641969968;
        bh=4Tn/USo8KXboTynK6KqLOmV0gnZLDsBgsgeyLJRL42U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KPBg50AG2faZ8N/dkKJzcmsW0yf4+tZqhCuQn+FFCR6kc2LkIgOS6StWmkVzv0WOT
         xBb+gILh/BDRFnnrCnrG/CF9hRYe/34tqdNvlFZU3P0bKcCIdBtaF0Ekhip3FZOHnU
         4ax4ZDl2jRoPJwOQj1iZWfUaFrDbOJYSdFps7gUK/HcmyKUFRRZT4f7K1qcJ972sxI
         15MLR5c/BlgsMvRDUIaIAV5KAg8KdDk3AhV0oOxKh2c9EcN0K7cTgCEkwKog49VHPh
         +R6aYIPs+srU9pWbkDcZK3xM5tibGLjp9mkmdZm5/dMBbfOSjEhf1e48Yvr3Berhn6
         JJJh+q5HmRWVA==
Date:   Tue, 11 Jan 2022 22:46:06 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     hannes@cmpxchg.org, torvalds@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, bristot@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@android.com,
        syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Message-ID: <Yd55LpWuuKHm26L2@sol.localdomain>
References: <20220111232309.1786347-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111232309.1786347-1-surenb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 03:23:09PM -0800, Suren Baghdasaryan wrote:
> With write operation on psi files replacing old trigger with a new one,
> the lifetime of its waitqueue is totally arbitrary. Overwriting an
> existing trigger causes its waitqueue to be freed and pending poll()
> will stumble on trigger->event_wait which was destroyed.
> Fix this by disallowing to redefine an existing psi trigger. If a write
> operation is used on a file descriptor with an already existing psi
> trigger, the operation will fail with EBUSY error.
> Also bypass a check for psi_disabled in the psi_trigger_destroy as the
> flag can be flipped after the trigger is created, leading to a memory
> leak.
> 
> Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
> Analyzed-by: Eric Biggers <ebiggers@kernel.org>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
