Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC2326B620
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgIOX5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgIOObY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D085022B30;
        Tue, 15 Sep 2020 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179748;
        bh=QUTNwZGM3FIaA6gdhwUd6R3y0wXqRXzXtwiRmURuO50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oz41EwzwXw1KnF2UlWQtNJ6/c6sYPONOVZJol5PB5bvzjnI/jC8t9XQx9VPM6kOCz
         UD9D033+aLlh1sXKgfigga/1O47YkshFbMPdby/0UdXk+PomDbO2S0IjUs88n9Qbg0
         szbuNZsizTGpp1ooKE2JSs3m3VjXEWhNnAxPVf4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 5.4 103/132] drm/i915/gvt: do not check len & max_len for lri
Date:   Tue, 15 Sep 2020 16:13:25 +0200
Message-Id: <20200915140649.304217142@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

commit dbafc67307ec06036b25b223a251af03fe07969a upstream.

lri ususally of variable len and far exceeding 127 dwords.

Fixes: 00a33be40634 ("drm/i915/gvt: Add valid length check for MI variable commands")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200304095121.21609-1-yan.y.zhao@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/cmd_parser.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -963,18 +963,6 @@ static int cmd_handler_lri(struct parser
 	int i, ret = 0;
 	int cmd_len = cmd_length(s);
 	struct intel_gvt *gvt = s->vgpu->gvt;
-	u32 valid_len = CMD_LEN(1);
-
-	/*
-	 * Official intel docs are somewhat sloppy , check the definition of
-	 * MI_LOAD_REGISTER_IMM.
-	 */
-	#define MAX_VALID_LEN 127
-	if ((cmd_len < valid_len) || (cmd_len > MAX_VALID_LEN)) {
-		gvt_err("len is not valid:  len=%u  valid_len=%u\n",
-			cmd_len, valid_len);
-		return -EFAULT;
-	}
 
 	for (i = 1; i < cmd_len; i += 2) {
 		if (IS_BROADWELL(gvt->dev_priv) && s->ring_id != RCS0) {


