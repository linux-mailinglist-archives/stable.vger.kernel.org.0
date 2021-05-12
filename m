Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C191437C8E8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhELQNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239301AbhELQHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56F4A61492;
        Wed, 12 May 2021 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833837;
        bh=BVMU3AVTnR7eWjaKGZrx4Nx13u8lYUd4M6mEbXxRxTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yceErwNInJ8j5lz28oxuZJAZurSKKhKIVBGNfrvts/VzS5RDjFSZvPoMpMmK0wCdg
         0qQwizGdmG4f4zi2ABSW22vG7RwY04FH872KSQcnBzcpkT2vpYDEDm1Gbjn4ViTOAo
         OxbMrQfCRV3/79rRf6omuABOLYq13ABGWe4puc1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 309/601] drm/amd/display: Fix off by one in hdmi_14_process_transaction()
Date:   Wed, 12 May 2021 16:46:26 +0200
Message-Id: <20210512144838.001168962@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8e6fafd5a22e7a2eb216f5510db7aab54cc545c1 ]

The hdcp_i2c_offsets[] array did not have an entry for
HDCP_MESSAGE_ID_WRITE_CONTENT_STREAM_TYPE so it led to an off by one
read overflow.  I added an entry and copied the 0x0 value for the offset
from similar code in drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c.

I also declared several of these arrays as having HDCP_MESSAGE_ID_MAX
entries.  This doesn't change the code, but it's just a belt and
suspenders approach to try future proof the code.

Fixes: 4c283fdac08a ("drm/amd/display: Add HDCP module")
Reviewed-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c b/drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c
index 5e384a8a83dc..51855a2624cf 100644
--- a/drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c
+++ b/drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c
@@ -39,7 +39,7 @@
 #define HDCP14_KSV_SIZE 5
 #define HDCP14_MAX_KSV_FIFO_SIZE 127*HDCP14_KSV_SIZE
 
-static const bool hdcp_cmd_is_read[] = {
+static const bool hdcp_cmd_is_read[HDCP_MESSAGE_ID_MAX] = {
 	[HDCP_MESSAGE_ID_READ_BKSV] = true,
 	[HDCP_MESSAGE_ID_READ_RI_R0] = true,
 	[HDCP_MESSAGE_ID_READ_PJ] = true,
@@ -75,7 +75,7 @@ static const bool hdcp_cmd_is_read[] = {
 	[HDCP_MESSAGE_ID_WRITE_CONTENT_STREAM_TYPE] = false
 };
 
-static const uint8_t hdcp_i2c_offsets[] = {
+static const uint8_t hdcp_i2c_offsets[HDCP_MESSAGE_ID_MAX] = {
 	[HDCP_MESSAGE_ID_READ_BKSV] = 0x0,
 	[HDCP_MESSAGE_ID_READ_RI_R0] = 0x8,
 	[HDCP_MESSAGE_ID_READ_PJ] = 0xA,
@@ -106,7 +106,8 @@ static const uint8_t hdcp_i2c_offsets[] = {
 	[HDCP_MESSAGE_ID_WRITE_REPEATER_AUTH_SEND_ACK] = 0x60,
 	[HDCP_MESSAGE_ID_WRITE_REPEATER_AUTH_STREAM_MANAGE] = 0x60,
 	[HDCP_MESSAGE_ID_READ_REPEATER_AUTH_STREAM_READY] = 0x80,
-	[HDCP_MESSAGE_ID_READ_RXSTATUS] = 0x70
+	[HDCP_MESSAGE_ID_READ_RXSTATUS] = 0x70,
+	[HDCP_MESSAGE_ID_WRITE_CONTENT_STREAM_TYPE] = 0x0,
 };
 
 struct protection_properties {
@@ -184,7 +185,7 @@ static const struct protection_properties hdmi_14_protection = {
 	.process_transaction = hdmi_14_process_transaction
 };
 
-static const uint32_t hdcp_dpcd_addrs[] = {
+static const uint32_t hdcp_dpcd_addrs[HDCP_MESSAGE_ID_MAX] = {
 	[HDCP_MESSAGE_ID_READ_BKSV] = 0x68000,
 	[HDCP_MESSAGE_ID_READ_RI_R0] = 0x68005,
 	[HDCP_MESSAGE_ID_READ_PJ] = 0xFFFFFFFF,
-- 
2.30.2



