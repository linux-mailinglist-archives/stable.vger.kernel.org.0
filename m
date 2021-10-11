Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCD9428FCA
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbhJKOBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237112AbhJKN7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBA8B6112D;
        Mon, 11 Oct 2021 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960576;
        bh=VxP1/+gjxSxxcdqztD8paRywrJMJk+wkvnIgRA9ejQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdCaQyu+acJ1LccgjWZNEtb1036Z1lMSjceegSNBvDPv2LJbm/mQR10WsThymBXrX
         gj/0JuGS5+cz1iLafwt2PIv/tWsROj3aJ5GwyCWLKy3nb9SvVWu5P1HYfW2dRd/BQB
         XYy4ygdFigwk9tlXFCDhQptHKZuRdWCWYH8Tz9yI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Lyude Paul <lyude@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.14 013/151] drm/nouveau/kms/tu102-: delay enabling cursor until after assign_windows
Date:   Mon, 11 Oct 2021 15:44:45 +0200
Message-Id: <20211011134518.287596839@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

commit f732e2e34aa08493fdd762f3daa4e5f16bbf1e45 upstream.

Prevent NVD core channel error code 67 occuring and hanging display,
managed to reproduce on GA102 while testing suspend/resume scenarios.

Required extension of earlier commit to fix interactions with EFI.

Fixes: e78b1b545c6c ("drm/nouveau/kms/nv50: workaround EFI GOP window channel format differences")
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: <stable@vger.kernel.org> # v5.12+
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210906005628.11499-2-skeggsb@gmail.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/head.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -52,6 +52,7 @@ nv50_head_flush_clr(struct nv50_head *he
 void
 nv50_head_flush_set_wndw(struct nv50_head *head, struct nv50_head_atom *asyh)
 {
+	if (asyh->set.curs   ) head->func->curs_set(head, asyh);
 	if (asyh->set.olut   ) {
 		asyh->olut.offset = nv50_lut_load(&head->olut,
 						  asyh->olut.buffer,
@@ -67,7 +68,6 @@ nv50_head_flush_set(struct nv50_head *he
 	if (asyh->set.view   ) head->func->view    (head, asyh);
 	if (asyh->set.mode   ) head->func->mode    (head, asyh);
 	if (asyh->set.core   ) head->func->core_set(head, asyh);
-	if (asyh->set.curs   ) head->func->curs_set(head, asyh);
 	if (asyh->set.base   ) head->func->base    (head, asyh);
 	if (asyh->set.ovly   ) head->func->ovly    (head, asyh);
 	if (asyh->set.dither ) head->func->dither  (head, asyh);


