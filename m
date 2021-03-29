Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6161234C9FA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhC2Ief (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234705AbhC2Id3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6E3F619D3;
        Mon, 29 Mar 2021 08:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006783;
        bh=jaObR1/HBjGzBGeaeR6jD15n/1J7qNL3EcTToXAExcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/LU9uoY2s22EDBWDTqJoP5wqBJDCScacZfo4lip7bOZiDccW8gEDxzve8mfhlxAO
         s+z+Y9A6mkovrm7hfbYIdQcX/5eAQkrfwydWmRx7R0AEd+sZkMRjpEuviHlcEpB4kv
         0xm1JU4EkbqoAMzIy/+J5gC6x/UWsjixTR+7LChg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.11 095/254] drm/nouveau/kms/nve4-nv108: Limit cursors to 128x128
Date:   Mon, 29 Mar 2021 09:56:51 +0200
Message-Id: <20210329075636.315462853@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit d3999c1f7bbbc100c167d7ad3cd79c1d10446ba2 upstream.

While Kepler does technically support 256x256 cursors, it turns out that
Kepler actually has some additional requirements for scanout surfaces that
we're not enforcing correctly, which aren't present on Maxwell and later.
Cursor surfaces must always use small pages (4K), and overlay surfaces must
always use large pages (128K).

Fixing this correctly though will take a bit more work: as we'll need to
add some code in prepare_fb() to move cursor FBs in large pages to small
pages, and vice-versa for overlay FBs. So until we have the time to do
that, just limit cursor surfaces to 128x128 - a size small enough to always
default to small pages.

This means small ovlys are still broken on Kepler, but it is extremely
unlikely anyone cares about those anyway :).

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: d3b2f0f7921c ("drm/nouveau/kms/nv50-: Report max cursor size to userspace")
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2663,9 +2663,20 @@ nv50_display_create(struct drm_device *d
 	else
 		nouveau_display(dev)->format_modifiers = disp50xx_modifiers;
 
-	if (disp->disp->object.oclass >= GK104_DISP) {
+	/* FIXME: 256x256 cursors are supported on Kepler, however unlike Maxwell and later
+	 * generations Kepler requires that we use small pages (4K) for cursor scanout surfaces. The
+	 * proper fix for this is to teach nouveau to migrate fbs being used for the cursor plane to
+	 * small page allocations in prepare_fb(). When this is implemented, we should also force
+	 * large pages (128K) for ovly fbs in order to fix Kepler ovlys.
+	 * But until then, just limit cursors to 128x128 - which is small enough to avoid ever using
+	 * large pages.
+	 */
+	if (disp->disp->object.oclass >= GM107_DISP) {
 		dev->mode_config.cursor_width = 256;
 		dev->mode_config.cursor_height = 256;
+	} else if (disp->disp->object.oclass >= GK104_DISP) {
+		dev->mode_config.cursor_width = 128;
+		dev->mode_config.cursor_height = 128;
 	} else {
 		dev->mode_config.cursor_width = 64;
 		dev->mode_config.cursor_height = 64;


