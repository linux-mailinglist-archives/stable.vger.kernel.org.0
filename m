Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1FE2267F0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388095AbgGTQP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388474AbgGTQPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D00CA2064B;
        Mon, 20 Jul 2020 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261755;
        bh=G870sS68UfVhqjNODXsCGY+SVaWAFDuVgba/lZ2s7YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSThBwTnYJOPiwlmU7aQeyiblJlXKRTCZUAjx7Qez1hdfSVg8eMABn7wKGbVzLUaJ
         WjVjvNpBDmQ3E3uBSSWAhBPS4SJUfHRx20pf+jb4CpxQwbh07/fNqaVuwxS6vG/QBC
         0udAI6u5GDly7/PEGk3en7tH0xrBZb/+84gw2WMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.7 230/244] drm/i915/gt: Ignore irq enabling on the virtual engines
Date:   Mon, 20 Jul 2020 17:38:21 +0200
Message-Id: <20200720152836.783815437@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 858f1299fd6f7518ddef19ddd304c8398ac79fa5 upstream.

We do not use the virtual engines for interrupts (they have physical
components), but we do use them to decouple the fence signaling during
submission. Currently, when we submit a completed request, we try to
enable the interrupt handler for the virtual engine, but we never disarm
it. A quick fix is then to mark the irq as enabled, and it will then
remain enabled -- and this prevents us from waking the device and never
letting it sleep again.

Fixes: f8db4d051b5e ("drm/i915: Initialise breadcrumb lists on the virtual engine")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200711203236.12330-1-chris@chris-wilson.co.uk
(cherry picked from commit 4fe6abb8f51355224808ab02a9febf65d184c40b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -5188,6 +5188,7 @@ intel_execlists_create_virtual(struct in
 	intel_engine_init_active(&ve->base, ENGINE_VIRTUAL);
 	intel_engine_init_breadcrumbs(&ve->base);
 	intel_engine_init_execlists(&ve->base);
+	ve->base.breadcrumbs.irq_armed = true; /* fake HW, used for irq_work */
 
 	ve->base.cops = &virtual_context_ops;
 	ve->base.request_alloc = execlists_request_alloc;


