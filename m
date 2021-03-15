Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B9833B713
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhCON7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232311AbhCON6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9784764F33;
        Mon, 15 Mar 2021 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816701;
        bh=22Sy2O0/sNhIpTplUZi3RFzECWze9MCTHRDGpGRufjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBC1KxeLhLBPGiGXQEtl8KlJEUE1bqA+MvfmzxlZZAQLmGgXLO7l3v/qybf5eWDuj
         udjY53sZjX1y3BHKnMbvjeRGg1HXGvSZwA7x/3xXVO9poHNiFmY8dKcjQ/OWt5JxBQ
         e2M1ZnXy1zspWBk8z1fJPpXJrAngFPF+7a4HP1eg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 056/168] media: v4l: vsp1: Fix uif null pointer access
Date:   Mon, 15 Mar 2021 14:54:48 +0100
Message-Id: <20210315135552.200217160@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 6732f313938027a910e1f7351951ff52c0329e70 upstream.

RZ/G2L SoC has no UIF. This patch fixes null pointer access, when UIF
module is not used.

Fixes: 5e824f989e6e8("media: v4l: vsp1: Integrate DISCOM in display pipeline")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/vsp1/vsp1_drm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -462,9 +462,9 @@ static int vsp1_du_pipeline_setup_inputs
 	 * make sure it is present in the pipeline's list of entities if it
 	 * wasn't already.
 	 */
-	if (!use_uif) {
+	if (drm_pipe->uif && !use_uif) {
 		drm_pipe->uif->pipe = NULL;
-	} else if (!drm_pipe->uif->pipe) {
+	} else if (drm_pipe->uif && !drm_pipe->uif->pipe) {
 		drm_pipe->uif->pipe = pipe;
 		list_add_tail(&drm_pipe->uif->list_pipe, &pipe->entities);
 	}


