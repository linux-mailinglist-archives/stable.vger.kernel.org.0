Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A25F2ABA22
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbgKINQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387420AbgKINQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3DE2208FE;
        Mon,  9 Nov 2020 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927762;
        bh=XvjeH3eqI8qrSv4FQyYupaTcNbZkt1CBRAYb1VDSO6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LURNk0tXnloRlUJ+mVkdTDYm5smYRNs9ylXMiFrwtA9nYtUInFHxzRpiWCf6NSCO5
         edcNb9Qw82kmokrTprYRWWW7dwQjXCXbmB0VjAQaiYOqf6M/jgEZK+3vHWWmSXeaFU
         jduQbRv1fFZwPGOcFTm1ktr+aKBU7HzFoOwMyCxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 013/133] drm/i915/gt: Delay execlist processing for tgl
Date:   Mon,  9 Nov 2020 13:54:35 +0100
Message-Id: <20201109125031.358299349@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 9b99e5ba3e5d68039bd6b657e4bbe520a3521f4c upstream.

When running gem_exec_nop, it floods the system with many requests (with
the goal of userspace submitting faster than the HW can process a single
empty batch). This causes the driver to continually resubmit new
requests onto the end of an active context, a flood of lite-restore
preemptions. If we time this just right, Tigerlake hangs.

Inserting a small delay between the processing of CS events and
submitting the next context, prevents the hang. Naturally it does not
occur with debugging enabled. The suspicion then is that this is related
to the issues with the CS event buffer, and inserting an mmio read of
the CS pointer status appears to be very successful in preventing the
hang. Other registers, or uncached reads, or plain mb, do not prevent
the hang, suggesting that register is key -- but that the hang can be
prevented by a simple udelay, suggests it is just a timing issue like
that encountered by commit 233c1ae3c83f ("drm/i915/gt: Wait for CSB
entries on Tigerlake"). Also note that the hang is not prevented by
applying CTX_DESC_FORCE_RESTORE, or by inserting a delay on the GPU
between requests.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Bruce Chang <yu.bruce.chang@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201015195023.32346-1-chris@chris-wilson.co.uk
(cherry picked from commit 6ca7217dffaf1abba91558e67a2efb655ac91405)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -2661,6 +2661,9 @@ static void process_csb(struct intel_eng
 			smp_wmb(); /* complete the seqlock */
 			WRITE_ONCE(execlists->active, execlists->inflight);
 
+			/* XXX Magic delay for tgl */
+			ENGINE_POSTING_READ(engine, RING_CONTEXT_STATUS_PTR);
+
 			WRITE_ONCE(execlists->pending[0], NULL);
 		} else {
 			if (GEM_WARN_ON(!*execlists->active)) {


