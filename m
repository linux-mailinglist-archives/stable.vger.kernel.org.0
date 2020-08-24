Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0400624F4B4
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgHXIjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgHXIjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:39:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41BFE2177B;
        Mon, 24 Aug 2020 08:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258375;
        bh=H66+2aVcp3+femgRf01XpTSicKaJdqIajFZSS8hXtEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTjUFXAABOckao34G4paTid0d4Fso+9cu7MbD8jg43qLt4uEwR3J+rvgriOYCK3vp
         2i6fwj1xHa2B3g8eAXNoGB8QC+8ptmSqPubspvZ65kc4ccajxBCE3h5EQ58mjpghtb
         ay7gRBlmpO36bhTU1XXrVcmZTHAkEvsCUmkPi9xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehyun Chung <jaehyun.chung@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 025/124] drm/amd/display: Blank stream before destroying HDCP session
Date:   Mon, 24 Aug 2020 10:29:19 +0200
Message-Id: <20200824082410.658901013@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaehyun Chung <jaehyun.chung@amd.com>

commit 79940e4d10df9c737a394630968471c632246ee0 upstream.

[Why]
Stream disable sequence incorretly destroys HDCP session while stream is
not blanked and while audio is not muted. This sequence causes a flash
of corruption during mode change and an audio click.

[How]
Change sequence to blank stream before destroying HDCP session. Audio will
also be muted by blanking the stream.

Cc: stable@vger.kernel.org
Signed-off-by: Jaehyun Chung <jaehyun.chung@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3113,12 +3113,11 @@ void core_link_disable_stream(struct pip
 			dc_is_virtual_signal(pipe_ctx->stream->signal))
 		return;
 
+	dc->hwss.blank_stream(pipe_ctx);
 #if defined(CONFIG_DRM_AMD_DC_HDCP)
 	update_psp_stream_config(pipe_ctx, true);
 #endif
 
-	dc->hwss.blank_stream(pipe_ctx);
-
 	if (pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
 		deallocate_mst_payload(pipe_ctx);
 


