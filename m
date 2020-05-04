Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDF01C4475
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbgEDSHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731176AbgEDSHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73665206B8;
        Mon,  4 May 2020 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615651;
        bh=CKAyMzgdGXCoYpRCj3cr2sVbSPR+LqD5jd9a361D360=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2hAvP5B3zm7KtDW0hEMayfCmHahpQGHU5NhXvWbkN9sutsJDvbc1jvJOQpoqxuGL
         +9rWJygzQCNERe4FUnWpR7GASwhYVX5h8WFebzsBFT7N3Lsn8wQ2jOs59HdWLfQ3fo
         IFFF0ac7/QqIDi8OcEBx73NL/jR/87jxtpX5n1pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.6 67/73] drm/i915/selftests: Fix i915_address_space refcnt leak
Date:   Mon,  4 May 2020 19:58:10 +0200
Message-Id: <20200504165510.250076900@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 5d5e100a20348c336e56df604b353b978f8adbb9 upstream.

igt_ppgtt_pin_update() invokes i915_gem_context_get_vm_rcu(), which
returns a reference of the i915_address_space object to "vm" with
increased refcount.

When igt_ppgtt_pin_update() returns, "vm" becomes invalid, so the
refcount should be decreased to keep refcount balanced.

The reference counting issue happens in two exception handling paths of
igt_ppgtt_pin_update(). When i915_gem_object_create_internal() returns
IS_ERR, the refcnt increased by i915_gem_context_get_vm_rcu() is not
decreased, causing a refcnt leak.

Fix this issue by jumping to "out_vm" label when
i915_gem_object_create_internal() returns IS_ERR.

Fixes: a4e7ccdac38e ("drm/i915: Move context management under GEM")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/1587361342-83494-1-git-send-email-xiyuyang19@fudan.edu.cn
(cherry picked from commit e07c7606a00c4361bad72ff4e72ed0dfbefa23b0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1578,8 +1578,10 @@ static int igt_ppgtt_pin_update(void *ar
 		unsigned int page_size = BIT(first);
 
 		obj = i915_gem_object_create_internal(dev_priv, page_size);
-		if (IS_ERR(obj))
-			return PTR_ERR(obj);
+		if (IS_ERR(obj)) {
+			err = PTR_ERR(obj);
+			goto out_vm;
+		}
 
 		vma = i915_vma_instance(obj, vm, NULL);
 		if (IS_ERR(vma)) {
@@ -1632,8 +1634,10 @@ static int igt_ppgtt_pin_update(void *ar
 	}
 
 	obj = i915_gem_object_create_internal(dev_priv, PAGE_SIZE);
-	if (IS_ERR(obj))
-		return PTR_ERR(obj);
+	if (IS_ERR(obj)) {
+		err = PTR_ERR(obj);
+		goto out_vm;
+	}
 
 	vma = i915_vma_instance(obj, vm, NULL);
 	if (IS_ERR(vma)) {


