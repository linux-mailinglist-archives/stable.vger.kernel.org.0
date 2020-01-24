Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D051147A67
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgAXJdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:33:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgAXJdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:33:21 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 878D32070A;
        Fri, 24 Jan 2020 09:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858400;
        bh=0UfI9b962cnRCfSw5F5UHZmv4pcUiuBfAMKCbmnbSI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNsotn+CTa7DWvTomCRNE7JcMw0MHtmfnU3ti6Y6gFYNfTsAEnsu7+bMtcYNWeltZ
         wBlCtVsUnBXwQ4CUQTPq+Ymo9bQFrFMELnuZk/6kuZMwJCq02JtI4dVI40GUHVbYXD
         JJ4bvTteYDeNHh6nnASQqR4ttV5Z9aW8oQtabia0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.4 001/102] drm/i915: Fix pid leak with banned clients
Date:   Fri, 24 Jan 2020 10:30:02 +0100
Message-Id: <20200124092806.288933727@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit f0f3a6cecf3b98990985cd42f7bf5a0313894822 upstream.

Get_pid_task() needs to be paired with a put_pid or we leak a pid
reference every time a banned client tries to create a context.

v2:
 * task_pid_nr helper exists! (Chris)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: b083a0870c79 ("drm/i915: Add per client max context ban limit")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20191217170933.8108-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit ba16a48af797db124ac100417f9229b1650ce1fb)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_context.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -2094,8 +2094,7 @@ int i915_gem_context_create_ioctl(struct
 	ext_data.fpriv = file->driver_priv;
 	if (client_is_banned(ext_data.fpriv)) {
 		DRM_DEBUG("client %s[%d] banned from creating ctx\n",
-			  current->comm,
-			  pid_nr(get_task_pid(current, PIDTYPE_PID)));
+			  current->comm, task_pid_nr(current));
 		return -EIO;
 	}
 


