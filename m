Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54CD378875
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhEJLV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237120AbhEJLLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F2861613;
        Mon, 10 May 2021 11:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644835;
        bh=21EE0cb9pB9/6PtkDpY/rr4MkSUpCOirx/S1SQZFV/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mUpLodqrxwqO5PNUu117Olut1cDVZuT9mnhmEnViXGZM0dnK7bsvuz/LNEpp3prn
         iry0bQ9pPJxG9GnQNjpmhIn3NXuHf1YA26nNt5MX97IydVZahHscJI+iLkvCsyBV0K
         fRFclw1R1USuoFq2JW8Vzdi3zQMPJqG6tKCfmbmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 244/384] drm/amd/display: Fix debugfs link_settings entry
Date:   Mon, 10 May 2021 12:20:33 +0200
Message-Id: <20210510102022.932076287@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit c006a1c00de29e8cdcde1d0254ac23433ed3fee9 ]

1. Catch invalid link_rate and link_count settings
2. Call dc interface to overwrite preferred link settings, and wait
until next stream update to apply the new settings.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 360952129b6d..29139b34dbe2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -150,7 +150,7 @@ static int parse_write_buffer_into_params(char *wr_buf, uint32_t wr_buf_size,
  *
  * --- to get dp configuration
  *
- * cat link_settings
+ * cat /sys/kernel/debug/dri/0/DP-x/link_settings
  *
  * It will list current, verified, reported, preferred dp configuration.
  * current -- for current video mode
@@ -163,7 +163,7 @@ static int parse_write_buffer_into_params(char *wr_buf, uint32_t wr_buf_size,
  * echo <lane_count>  <link_rate> > link_settings
  *
  * for example, to force to  2 lane, 2.7GHz,
- * echo 4 0xa > link_settings
+ * echo 4 0xa > /sys/kernel/debug/dri/0/DP-x/link_settings
  *
  * spread_spectrum could not be changed dynamically.
  *
@@ -171,7 +171,7 @@ static int parse_write_buffer_into_params(char *wr_buf, uint32_t wr_buf_size,
  * done. please check link settings after force operation to see if HW get
  * programming.
  *
- * cat link_settings
+ * cat /sys/kernel/debug/dri/0/DP-x/link_settings
  *
  * check current and preferred settings.
  *
@@ -255,7 +255,7 @@ static ssize_t dp_link_settings_write(struct file *f, const char __user *buf,
 	int max_param_num = 2;
 	uint8_t param_nums = 0;
 	long param[2];
-	bool valid_input = false;
+	bool valid_input = true;
 
 	if (size == 0)
 		return -EINVAL;
@@ -282,9 +282,9 @@ static ssize_t dp_link_settings_write(struct file *f, const char __user *buf,
 	case LANE_COUNT_ONE:
 	case LANE_COUNT_TWO:
 	case LANE_COUNT_FOUR:
-		valid_input = true;
 		break;
 	default:
+		valid_input = false;
 		break;
 	}
 
@@ -294,9 +294,9 @@ static ssize_t dp_link_settings_write(struct file *f, const char __user *buf,
 	case LINK_RATE_RBR2:
 	case LINK_RATE_HIGH2:
 	case LINK_RATE_HIGH3:
-		valid_input = true;
 		break;
 	default:
+		valid_input = false;
 		break;
 	}
 
@@ -310,10 +310,11 @@ static ssize_t dp_link_settings_write(struct file *f, const char __user *buf,
 	 * spread spectrum will not be changed
 	 */
 	prefer_link_settings.link_spread = link->cur_link_settings.link_spread;
+	prefer_link_settings.use_link_rate_set = false;
 	prefer_link_settings.lane_count = param[0];
 	prefer_link_settings.link_rate = param[1];
 
-	dc_link_set_preferred_link_settings(dc, &prefer_link_settings, link);
+	dc_link_set_preferred_training_settings(dc, &prefer_link_settings, NULL, link, true);
 
 	kfree(wr_buf);
 	return size;
-- 
2.30.2



