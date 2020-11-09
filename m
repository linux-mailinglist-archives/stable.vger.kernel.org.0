Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760682AB9B2
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732424AbgKINLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:11:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732417AbgKINLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:11:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FE2220789;
        Mon,  9 Nov 2020 13:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927498;
        bh=uaMl49KxItVzlBLKA6rem6duJFOk6Uw50orp1/GLPzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPyylqTvKJsvGba0MxFJOnYKvIAvWR9zBPmjSRkWRylu3X5K4vJh0+BrKfoZIy6zN
         kU+wpJCEt3QJdCXV9r7cfwq/XA5Jrqljc6AltBnwSaYleRV4hg70bYJpIXIMXqde03
         iluxhK6i3xp1YQEHSO2E3JbgaHVWTD60RZkfCPEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.4 01/85] drm/i915: Break up error capture compression loops with cond_resched()
Date:   Mon,  9 Nov 2020 13:54:58 +0100
Message-Id: <20201109125022.683904187@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7d5553147613b50149238ac1385c60e5c7cacb34 upstream.

As the error capture will compress user buffers as directed to by the
user, it can take an arbitrary amount of time and space. Break up the
compression loops with a call to cond_resched(), that will allow other
processes to schedule (avoiding the soft lockups) and also serve as a
warning should we try to make this loop atomic in the future.

Testcase: igt/gem_exec_capture/many-*
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200916090059.3189-2-chris@chris-wilson.co.uk
(cherry picked from commit 293f43c80c0027ff9299036c24218ac705ce584e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gpu_error.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -307,6 +307,8 @@ static int compress_page(struct compress
 
 		if (zlib_deflate(zstream, Z_NO_FLUSH) != Z_OK)
 			return -EIO;
+
+		cond_resched();
 	} while (zstream->avail_in);
 
 	/* Fallback to uncompressed if we increase size? */
@@ -392,6 +394,7 @@ static int compress_page(struct compress
 	if (!i915_memcpy_from_wc(ptr, src, PAGE_SIZE))
 		memcpy(ptr, src, PAGE_SIZE);
 	dst->pages[dst->page_count++] = ptr;
+	cond_resched();
 
 	return 0;
 }


