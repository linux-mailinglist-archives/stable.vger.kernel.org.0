Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76D2328F67
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbhCATvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:51:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240907AbhCATlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:41:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 696E96503C;
        Mon,  1 Mar 2021 17:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618908;
        bh=Uu2eES8d8sqkst1FzlgcpQT9ilhdD7VqlzdY6hDFNCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhsWmB7LoBu/UkoA/imVJiO/XnV1IsDyNzn0x6/kzJ7Gte/J3mlerFHu3pSgM06Pn
         DmDjfED/2XQ+Nh0lKf8pjt4+q308wzZD1USfxchwgZaLDrjFx7OMztByxgV81uzizs
         UYy/25I/YEiUL0Xj1woVW/q1IrRnGoa8Jl9q/YY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/663] drm/vc4: hdmi: Fix up CEC registers
Date:   Mon,  1 Mar 2021 17:07:59 +0100
Message-Id: <20210301161153.239033064@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 5a32bfd563e8b5766e57475c2c81c769e5a13f5d ]

The commit 311e305fdb4e ("drm/vc4: hdmi: Implement a register layout
abstraction") forgot one CEC register, and made a copy and paste mistake
for another one. Fix those mistakes.

Fixes: 311e305fdb4e ("drm/vc4: hdmi: Implement a register layout abstraction")
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111142309.193441-5-maxime@cerno.tech
(cherry picked from commit 303085bc11bb7aebeeaaf09213f99fd7aa539a34)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi_regs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi_regs.h b/drivers/gpu/drm/vc4/vc4_hdmi_regs.h
index 7c6b4818f2455..6c0dfbbe1a7ef 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_hdmi_regs.h
@@ -29,6 +29,7 @@ enum vc4_hdmi_field {
 	HDMI_CEC_CPU_MASK_SET,
 	HDMI_CEC_CPU_MASK_STATUS,
 	HDMI_CEC_CPU_STATUS,
+	HDMI_CEC_CPU_SET,
 
 	/*
 	 * Transmit data, first byte is low byte of the 32-bit reg.
@@ -196,9 +197,10 @@ static const struct vc4_hdmi_register vc4_hdmi_fields[] = {
 	VC4_HDMI_REG(HDMI_TX_PHY_RESET_CTL, 0x02c0),
 	VC4_HDMI_REG(HDMI_TX_PHY_CTL_0, 0x02c4),
 	VC4_HDMI_REG(HDMI_CEC_CPU_STATUS, 0x0340),
+	VC4_HDMI_REG(HDMI_CEC_CPU_SET, 0x0344),
 	VC4_HDMI_REG(HDMI_CEC_CPU_CLEAR, 0x0348),
 	VC4_HDMI_REG(HDMI_CEC_CPU_MASK_STATUS, 0x034c),
-	VC4_HDMI_REG(HDMI_CEC_CPU_MASK_SET, 0x034c),
+	VC4_HDMI_REG(HDMI_CEC_CPU_MASK_SET, 0x0350),
 	VC4_HDMI_REG(HDMI_CEC_CPU_MASK_CLEAR, 0x0354),
 	VC4_HDMI_REG(HDMI_RAM_PACKET_START, 0x0400),
 };
-- 
2.27.0



