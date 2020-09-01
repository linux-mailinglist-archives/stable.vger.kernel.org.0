Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAE32595D7
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgIAP41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731619AbgIAPpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:45:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C29072078B;
        Tue,  1 Sep 2020 15:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975110;
        bh=VkK32spEftFakciF2wjRC4/wdBx3aETtnf9kbrda1DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IG74q5laFZOcLdvFwUg/hisxnoky/WBuQ4vTOKDjGUYDRCrfqla8cBkdFFOy79fsF
         BIeCDFtU7jdTMm0+WGhm7CpBd2FTffRyJM0tkKhY70RFB5DhG44yPnh/2nRCAAHwY6
         iIQpxssbz5+/I+u6F3dQJ2lKjtZ5R/5daet7HiPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.8 212/255] drm/dp_mst: Dont return error code when crtc is null
Date:   Tue,  1 Sep 2020 17:11:08 +0200
Message-Id: <20200901151010.859326789@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>

commit 88fee1c9007a38c19f2c558dc0ab1ddb4c323dc5 upstream.

[Why]
In certain cases the crtc can be NULL and returning -EINVAL causes
atomic check to fail when it shouln't. This leads to valid
configurations failing because atomic check fails.

[How]
Don't early return if crtc is null

Signed-off-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
[added stable cc]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 8ec046716ca8 ("drm/dp_mst: Add helper to trigger modeset on affected DSC MST CRTCs")
Cc: <stable@vger.kernel.org> # v5.6+
Link: https://patchwork.freedesktop.org/patch/msgid/20200814170140.24917-1-Bhawanpreet.Lakha@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_mst_topology.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4993,8 +4993,8 @@ int drm_dp_mst_add_affected_dsc_crtcs(st
 
 		crtc = conn_state->crtc;
 
-		if (WARN_ON(!crtc))
-			return -EINVAL;
+		if (!crtc)
+			continue;
 
 		if (!drm_dp_mst_dsc_aux_for_port(pos->port))
 			continue;


