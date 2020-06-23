Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD07206313
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387765AbgFWUQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389108AbgFWUQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C2B20EDD;
        Tue, 23 Jun 2020 20:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943372;
        bh=hBnhPaUOIXD6v875OOpOmRPlaTzi8Xe4/zZSGViND5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0k5WOgRaeufzRqn/LhCLBhuaKwWsldBF6m3LK5dZCNQl7M8OMC+QDxuv5uLOIZOj2
         SOUr3Nwj5p9t9R6xnqOh5gp3K9KAeBjFzHbFyb0iqf2kmBuZs2Qh8nMzKZP5E6743E
         /Iek57GA2yQ1MpN4U2PptpzaKZ0bN42p53POfBUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 365/477] drm/ast: fix missing break in switch statement for format->cpp[0] case 4
Date:   Tue, 23 Jun 2020 21:56:02 +0200
Message-Id: <20200623195424.785533273@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 291ddeb621e4a9f1ced8302a777fbd7fbda058c6 ]

Currently the switch statement for format->cpp[0] value 4 assigns
color_index which is never read again and then falls through to the
default case and returns. This looks like a missing break statement
bug. Fix this by adding a break statement.

Addresses-Coverity: ("Unused value")
Fixes: 259d14a76a27 ("drm/ast: Split ast_set_vbios_mode_info()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200610115804.1132338-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_mode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 7a9f20a2fd303..fbf0ef58385db 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -226,6 +226,7 @@ static void ast_set_vbios_color_reg(struct ast_private *ast,
 	case 3:
 	case 4:
 		color_index = TrueCModeIndex;
+		break;
 	default:
 		return;
 	}
-- 
2.25.1



