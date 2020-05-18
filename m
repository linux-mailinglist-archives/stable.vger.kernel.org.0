Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C2F1D82A9
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbgERR6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730713AbgERR6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:58:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFF3220715;
        Mon, 18 May 2020 17:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824697;
        bh=Fq473D+whRVjLlot7rBxZ1jmAR8eyjkU37pEWOtJWyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGfv5Li8dA/mmBIfQkoAL3BX09ZqNV2HED6eSYxrOOMeFVgfOZfmhWtH49vHY9XIj
         1j2LHjfuLKnfHaGDNAIaM9LUO8udlv7cioPgf2q097pMxG8epxR04OSnvA2TB4TCvq
         hIwYqluGqUzZZzq1Iduaj6eZJuwwKPqnzeGUd+Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Jones <pjones@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 5.4 114/147] Make the "Reducing compressed framebufer size" message be DRM_INFO_ONCE()
Date:   Mon, 18 May 2020 19:37:17 +0200
Message-Id: <20200518173527.265985773@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Jones <pjones@redhat.com>

commit 82152d424b6cb6fc1ede7d03d69c04e786688740 upstream.

This was sort of annoying me:

random:~$ dmesg | tail -1
[523884.039227] [drm] Reducing the compressed framebuffer size. This may lead to less power savings than a non-reduced-size. Try to increase stolen memory size if available in BIOS.
random:~$ dmesg | grep -c "Reducing the compressed"
47

This patch makes it DRM_INFO_ONCE() just like the similar message
farther down in that function is pr_info_once().

Cc: stable@vger.kernel.org
Signed-off-by: Peter Jones <pjones@redhat.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1745
Link: https://patchwork.freedesktop.org/patch/msgid/20180706190424.29194-1-pjones@redhat.com
[vsyrjala: Rebase due to per-device logging]
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
(cherry picked from commit 6b7fc6a3e6af4ff5773949d0fed70d8e7f68d5ce)
[Rodrigo: port back to DRM_INFO_ONCE]
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_fbc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -504,8 +504,7 @@ static int intel_fbc_alloc_cfb(struct in
 	if (!ret)
 		goto err_llb;
 	else if (ret > 1) {
-		DRM_INFO("Reducing the compressed framebuffer size. This may lead to less power savings than a non-reduced-size. Try to increase stolen memory size if available in BIOS.\n");
-
+		DRM_INFO_ONCE("Reducing the compressed framebuffer size. This may lead to less power savings than a non-reduced-size. Try to increase stolen memory size if available in BIOS.\n");
 	}
 
 	fbc->threshold = ret;


