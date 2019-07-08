Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA8262348
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390465AbfGHPd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390460AbfGHPd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:33:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5ECE204EC;
        Mon,  8 Jul 2019 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600036;
        bh=QWEh1KWjRkuEdqk4cC4/ckIcIZMQz4gyuaWKf67BMWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkLuIvsBz28gVY+kq8k4/geuNvGCtJ0/ipPczI5FOdObKYSXiuCqek4HDfbefL2QO
         K7jFth+CGi5TME8Ncn6fTif5ks1LPlSOEvW388MZRwZYPHdYeBHqJ0Z5UwY36gtLLv
         /L1HFjuCKup9lsJaSAM/dgA1mlDB/RE5nJg0+XKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.1 72/96] drm/i915/ringbuffer: EMIT_INVALIDATE *before* switch context
Date:   Mon,  8 Jul 2019 17:13:44 +0200
Message-Id: <20190708150530.343722818@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit c84c9029d782a3a0d2a7f0522ecb907314d43e2c upstream.

Despite what I think the prm recommends, commit f2253bd9859b
("drm/i915/ringbuffer: EMIT_INVALIDATE after switch context") turned out
to be a huge mistake when enabling Ironlake contexts as the GPU would
hang on either a MI_FLUSH or PIPE_CONTROL immediately following the
MI_SET_CONTEXT of an active mesa context (more vanilla contexts, e.g.
simple rendercopies with igt, do not suffer).

Ville found the following clue,

  "[DevCTG+]: For the invalidate operation of the pipe control, the
   following pointers are affected. The
   invalidate operation affects the restore of these packets. If the pipe
   control invalidate operation is completed
   before the context save, the indirect pointers will not be restored from
   memory.
   1. Pipeline State Pointer
   2. Media State Pointer
   3. Constant Buffer Packet"

which suggests by us emitting the INVALIDATE prior to the MI_SET_CONTEXT,
we prevent the context-restore from chasing the dangling pointers within
the image, and explains why this likely prevents the GPU hang.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190419111749.3910-1-chris@chris-wilson.co.uk
(cherry picked from commit 928f8f42310f244501a7c70daac82c196112c190 in drm-intel-next)
Cc: stable@vger.kernel.org
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111014
Fixes: f2253bd9859b ("drm/i915/ringbuffer: EMIT_INVALIDATE after switch context")
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1957,12 +1957,12 @@ static int ring_request_alloc(struct i91
 	 */
 	request->reserved_space += LEGACY_REQUEST_SIZE;
 
-	ret = switch_context(request);
+	/* Unconditionally invalidate GPU caches and TLBs. */
+	ret = request->engine->emit_flush(request, EMIT_INVALIDATE);
 	if (ret)
 		return ret;
 
-	/* Unconditionally invalidate GPU caches and TLBs. */
-	ret = request->engine->emit_flush(request, EMIT_INVALIDATE);
+	ret = switch_context(request);
 	if (ret)
 		return ret;
 


