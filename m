Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7BF3E8089
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhHJRut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhHJRs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:48:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB215610FD;
        Tue, 10 Aug 2021 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617279;
        bh=52wx1QAENu1RFKw2KKVSA/Q5oPays035lX5xH5MXumM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5vytcLKYzm5HE8RmQu40eJEwNzIiOtUc5Ag5Jw6XOJNisIwWAmvc+796wDhaCYLz
         XxIK3N/XH5Lfo/WGjWR97oraUC66zHHSvW14Dcj+N2p8L+/Rwju0cIEuwBqUDxEiwd
         SGmfvzF3Jltyl6/uRcoP9Lbg1grYHUFbUAHmAyFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jason@jlekstrand.net, Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Date:   Tue, 10 Aug 2021 19:30:59 +0200
Message-Id: <20210810173000.050147269@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Gray <jsg@jsg.id.au>

The backport of c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 to 5.10 in
6976f3cf34a1a8b791c048bbaa411ebfe48666b1 removed more than it should
have leading to 'batch' being used uninitialised.  The 5.13 backport and
the mainline commit did not remove the portion this patch adds back.

Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Fixes: 6976f3cf34a1 ("drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"")
Cc: <stable@vger.kernel.org> # 5.10
Cc: Jason Ekstrand <jason@jlekstrand.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2351,6 +2351,12 @@ static int eb_parse(struct i915_execbuff
 		eb->batch_flags |= I915_DISPATCH_SECURE;
 	}
 
+	batch = eb_dispatch_secure(eb, shadow);
+	if (IS_ERR(batch)) {
+		err = PTR_ERR(batch);
+		goto err_trampoline;
+	}
+
 	err = intel_engine_cmd_parser(eb->engine,
 				      eb->batch->vma,
 				      eb->batch_start_offset,
@@ -2377,6 +2383,7 @@ secure_batch:
 err_unpin_batch:
 	if (batch)
 		i915_vma_unpin(batch);
+err_trampoline:
 	if (trampoline)
 		i915_vma_unpin(trampoline);
 err_shadow:


