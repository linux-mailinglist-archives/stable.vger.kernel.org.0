Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB9A498EE5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357149AbiAXTt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41648 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiAXToK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:44:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A13F1612E9;
        Mon, 24 Jan 2022 19:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBE4C340E5;
        Mon, 24 Jan 2022 19:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053449;
        bh=M0w/j3fopbUJv1GW0IRWTpurdgBProxxkpcgN9gt3wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAuGK29lqpbxv+5TyZE5aeUnMFZaQf4KYCa7gH7EH7b0D/U2quGTIv6kQ+/sjN8w4
         g0QkOOcUDq93Q/KxAR2sYe/361j6TcATIRMpChkHyWfwHJW90UYPS27jlS3aMXQSVe
         hXtn8jAKSGnH2ytX+mbZxsIWSCLpyyYtDKE9nWos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/563] media: atomisp: fix inverted logic in buffers_needed()
Date:   Mon, 24 Jan 2022 19:37:12 +0100
Message-Id: <20220124184026.731329166@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit e1921cd14640f0f4d1fad5eb8e448c58a536415d ]

When config.mode is IA_CSS_INPUT_MODE_BUFFERED_SENSOR, it rather needs
buffers. Fix it by inverting the return value.

Fixes: 3c0538fbad9f ("media: atomisp: get rid of most checks for ISP2401 version")
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css_mipi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css_mipi.c b/drivers/staging/media/atomisp/pci/sh_css_mipi.c
index d5ae7f0b5864b..e18c0cfb4ce3a 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_mipi.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_mipi.c
@@ -389,17 +389,17 @@ static bool buffers_needed(struct ia_css_pipe *pipe)
 {
 	if (!IS_ISP2401) {
 		if (pipe->stream->config.mode == IA_CSS_INPUT_MODE_BUFFERED_SENSOR)
-			return false;
-		else
 			return true;
+		else
+			return false;
 	}
 
 	if (pipe->stream->config.mode == IA_CSS_INPUT_MODE_BUFFERED_SENSOR ||
 	    pipe->stream->config.mode == IA_CSS_INPUT_MODE_TPG ||
 	    pipe->stream->config.mode == IA_CSS_INPUT_MODE_PRBS)
-		return false;
+		return true;
 
-	return true;
+	return false;
 }
 
 int
-- 
2.34.1



