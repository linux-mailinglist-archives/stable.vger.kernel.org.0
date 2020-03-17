Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214C4188180
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgCQLDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgCQLDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:03:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B252071C;
        Tue, 17 Mar 2020 11:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443029;
        bh=ybqz6l9Pn0+Ca0VsicFx4luxj8cHQTqRwj67ijp3NkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnyW16ZS/c8IqWrN6hnO1DbeVtMxGBpEVxGfMFStROYUMNu0qME/F1LU35KmTbdkT
         cs57TjgpfMGNnXoKwjP5QPBKayDH/UHKbPpagR1tb9RiFG1FKwOGOINN9iCAOimMkH
         h5qiTDkhWMJOaV4KtfGeJ8TOYZwAdaNfjD3E1xZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 070/123] drm/i915: be more solid in checking the alignment
Date:   Tue, 17 Mar 2020 11:54:57 +0100
Message-Id: <20200317103314.666440211@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Auld <matthew.auld@intel.com>

commit 1d61c5d711a2dc0b978ae905535edee9601f9449 upstream.

The alignment is u64, and yet is_power_of_2() assumes unsigned long,
which might give different results between 32b and 64b kernel.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200305203534.210466-1-matthew.auld@intel.com
Cc: stable@vger.kernel.org
(cherry picked from commit 2920516b2f719546f55079bc39a7fe409d9e80ab)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    3 ++-
 drivers/gpu/drm/i915/i915_utils.h              |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -439,7 +439,8 @@ eb_validate_vma(struct i915_execbuffer *
 	if (unlikely(entry->flags & eb->invalid_flags))
 		return -EINVAL;
 
-	if (unlikely(entry->alignment && !is_power_of_2(entry->alignment)))
+	if (unlikely(entry->alignment &&
+		     !is_power_of_2_u64(entry->alignment)))
 		return -EINVAL;
 
 	/*
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -233,6 +233,11 @@ static inline u64 ptr_to_u64(const void
 	__idx;								\
 })
 
+static inline bool is_power_of_2_u64(u64 n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
 static inline void __list_del_many(struct list_head *head,
 				   struct list_head *first)
 {


