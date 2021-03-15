Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669FC33B734
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCON7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhCON6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4831164F07;
        Mon, 15 Mar 2021 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816703;
        bh=crdHReBj3aMqOM/98vwY7tguD+5UrMxdp/QNat72IUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbTItGuUsikGXVOUClOmqql/ck6PQnnnXU4cDePIsRKOPQR+F4do4bd0KSJVJkCoJ
         tPCxjk4KNUs8M1ZEeNnBiF6uMzQUxZqz3vTvA+lrFscRQbxUOpL4hVAEyyfLovE4iI
         Gcvv5TEH3kz397wK+uMTe8AraGRnQQd2nuRRU0f8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 057/168] media: v4l: vsp1: Fix bru null pointer access
Date:   Mon, 15 Mar 2021 14:54:49 +0100
Message-Id: <20210315135552.230540805@linuxfoundation.org>
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

commit ac8d82f586c8692b501cb974604a71ef0e22a04c upstream.

RZ/G2L SoC has only BRS. This patch fixes null pointer access,when only
BRS is enabled.

Fixes: cbb7fa49c7466("media: v4l: vsp1: Rename BRU to BRx")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/vsp1/vsp1_drm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -245,7 +245,7 @@ static int vsp1_du_pipeline_setup_brx(st
 		brx = &vsp1->bru->entity;
 	else if (pipe->brx && !drm_pipe->force_brx_release)
 		brx = pipe->brx;
-	else if (!vsp1->bru->entity.pipe)
+	else if (vsp1_feature(vsp1, VSP1_HAS_BRU) && !vsp1->bru->entity.pipe)
 		brx = &vsp1->bru->entity;
 	else
 		brx = &vsp1->brs->entity;


