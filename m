Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8282C4F27AE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiDEIIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235564AbiDEH7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A049740A03;
        Tue,  5 Apr 2022 00:55:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E22D615CD;
        Tue,  5 Apr 2022 07:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE98C340EE;
        Tue,  5 Apr 2022 07:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145333;
        bh=ffree4QTNFS/AnCZEfxj8SDurCR5FE0zgUbDPN8iszM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uG2yKJfqX3KtzJReF/SU0PzAO1g3wHoFo18B03LbXl/elEqwaCJQh3IMiE31esZ18
         ysxsgr8YT2iQM2KT2651wHSsylGLgr+9WIipRAuHD0lOZekznzpgOca8ngoqBkYcie
         bf7YAJf9EJvPsw5i0kKV3ZZXUVA8Il+ae4xR83xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mirela Rabulea <mirela.rabulea@nxp.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0367/1126] media: ov5640: Fix set format, v4l2_mbus_pixelcode not updated
Date:   Tue,  5 Apr 2022 09:18:34 +0200
Message-Id: <20220405070418.399598456@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mirela Rabulea <mirela.rabulea@nxp.com>

[ Upstream commit e738f5dd67eb8098d75345908a5e73782d0569a5 ]

In ov5640_set_fmt, pending_fmt_change will always be false, because the
sensor format is saved before comparing it with the previous format:
	fmt = &sensor->fmt;...
	*fmt = *mbus_fmt;...
	if (mbus_fmt->code != sensor->fmt.code)
		sensor->pending_fmt_change = true;
This causes the sensor to capture with the previous pixelcode.

Also, changes might happen even for V4L2_SUBDEV_FORMAT_TRY, so fix that.

Basically, revert back to the state before
commit 071154499193 ("media: ov5640: Fix set format regression")
as it was more clear, and then update format even when pixelcode does
not change, as resolution might change.

Fixes: 071154499193 ("media: ov5640: Fix set format regression")
Fixes: 6949d864776e ("media: ov5640: do not change mode if format or frame interval is unchanged")
Fixes: fb98e29ff1ea5 ("media: ov5640: fix mode change regression")

Signed-off-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Hugues Fruchet <hugues.fruchet@st.com>
Tested-by: Hugues Fruchet <hugues.fruchet@st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index ddbd71394db3..db5a19babe67 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2293,7 +2293,6 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 	struct ov5640_dev *sensor = to_ov5640_dev(sd);
 	const struct ov5640_mode_info *new_mode;
 	struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
-	struct v4l2_mbus_framefmt *fmt;
 	int ret;
 
 	if (format->pad != 0)
@@ -2311,12 +2310,10 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 	if (ret)
 		goto out;
 
-	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
-		fmt = v4l2_subdev_get_try_format(sd, sd_state, 0);
-	else
-		fmt = &sensor->fmt;
-
-	*fmt = *mbus_fmt;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		*v4l2_subdev_get_try_format(sd, sd_state, 0) = *mbus_fmt;
+		goto out;
+	}
 
 	if (new_mode != sensor->current_mode) {
 		sensor->current_mode = new_mode;
@@ -2325,6 +2322,9 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 	if (mbus_fmt->code != sensor->fmt.code)
 		sensor->pending_fmt_change = true;
 
+	/* update format even if code is unchanged, resolution might change */
+	sensor->fmt = *mbus_fmt;
+
 	__v4l2_ctrl_s_ctrl_int64(sensor->ctrls.pixel_rate,
 				 ov5640_calc_pixel_rate(sensor));
 out:
-- 
2.34.1



