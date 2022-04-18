Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEDB50533A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240481AbiDRM4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240347AbiDRMzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE4365E5;
        Mon, 18 Apr 2022 05:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FE25B80EDC;
        Mon, 18 Apr 2022 12:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F69C385A7;
        Mon, 18 Apr 2022 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285396;
        bh=2t0eVLRm9IKXPmEFvKqSsifEG0+7YxKLivElACyLft4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xo1COt12Mov7dETjairRfmsEJYzb9cTstyee8K5MPoEEyCIxCJ1V812QB7RVtXSRX
         +g381RRUD8DQtD4C8sS9ndOf0TCEZtvzQ0q3djSbVmNLGmwEo6HGRVpB7WinaBRbp7
         m/GIVNsHg/0qVThxlTcBNuuKP4vlw6OiRz7Q2Sss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.15 177/189] drm/i915: Sunset igpu legacy mmap support based on GRAPHICS_VER_FULL
Date:   Mon, 18 Apr 2022 14:13:17 +0200
Message-Id: <20220418121208.012928714@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit 1acb34e7dd7720a1fff00cbd4d000ec3219dc9d6 upstream.

The intent of the version check in the mmap ioctl was to maintain
support for existing platforms (i.e., ADL/RPL and earlier), but drop
support on all future igpu platforms.  As we've seen on the dgpu side,
the hardware teams are using a more fine-grained numbering system for IP
version numbers these days, so it's possible the version number
associated with our next igpu could be some form of "12.xx" rather than
13 or higher.  Comparing against the full ver.release number will ensure
the intent of the check is maintained no matter what numbering the
hardware teams settle on.

Fixes: d3f3baa3562a ("drm/i915: Reinstate the mmap ioctl for some platforms")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220407161839.1073443-1-matthew.d.roper@intel.com
(cherry picked from commit 8e7e5c077cd57ee9a36d58c65f07257dc49a88d5)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -66,7 +66,7 @@ i915_gem_mmap_ioctl(struct drm_device *d
 	 * mmap ioctl is disallowed for all discrete platforms,
 	 * and for all platforms with GRAPHICS_VER > 12.
 	 */
-	if (IS_DGFX(i915) || GRAPHICS_VER(i915) > 12)
+	if (IS_DGFX(i915) || GRAPHICS_VER_FULL(i915) > IP_VER(12, 0))
 		return -EOPNOTSUPP;
 
 	if (args->flags & ~(I915_MMAP_WC))


