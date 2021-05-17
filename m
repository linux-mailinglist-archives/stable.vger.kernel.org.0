Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECF438350D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242554AbhEQPPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242762AbhEQPMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:12:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A19061C49;
        Mon, 17 May 2021 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261879;
        bh=6Vp80qS7+caMCitputbWgWF2Ko1xwPcVy27HN7NfAAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvB+71F3wQMpFUGIRmmTI56EZMkxcMDW3Tj8AXs5bh01Hj6BEBXk+X/lKd1XUmD7K
         5h5AKHb9jQZtWsWzPis3eaUgEkQ7mPT+e420+ivYI/IutQJo19N7orDDl5P2b8uwWK
         T3oB8AduSn0chCFpAvkdYwxEEeSw7CoFu/dUZ9Nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 104/141] drm/i915: Avoid div-by-zero on gen2
Date:   Mon, 17 May 2021 16:02:36 +0200
Message-Id: <20210517140246.279576967@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 4819d16d91145966ce03818a95169df1fd56b299 upstream.

Gen2 tiles are 2KiB in size so i915_gem_object_get_tile_row_size()
can in fact return <4KiB, which leads to div-by-zero here.
Avoid that.

Not sure i915_gem_object_get_tile_row_size() is entirely
sane anyway since it doesn't account for the different tile
layouts on i8xx/i915...

I'm not able to hit this before commit 6846895fde05 ("drm/i915:
Replace PIN_NONFAULT with calls to PIN_NOEVICT") and it looks
like I also need to run recent version of Mesa. With those in
place xonotic trips on this quite easily on my 85x.

Cc: stable@vger.kernel.org
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210421153401.13847-2-ville.syrjala@linux.intel.com
(cherry picked from commit ed52c62d386f764194e0184fdb905d5f24194cae)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -181,7 +181,7 @@ compute_partial_view(const struct drm_i9
 	struct i915_ggtt_view view;
 
 	if (i915_gem_object_is_tiled(obj))
-		chunk = roundup(chunk, tile_row_pages(obj));
+		chunk = roundup(chunk, tile_row_pages(obj) ?: 1);
 
 	view.type = I915_GGTT_VIEW_PARTIAL;
 	view.partial.offset = rounddown(page_offset, chunk);


