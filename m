Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7230215F4B8
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgBNPtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbgBNPtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E45824650;
        Fri, 14 Feb 2020 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695358;
        bh=SQblWGVK85RDtDCmFxEN7dIQuhlIWlI9a6GM+Gje28U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOI/+e1OyOa6tD/1Yk5ZAhmAgKcdpGF0zDc9jf/bIH+QkxhKbvoQuM7ruhd4Dy93H
         kFMNhQtExBf0JdSn7CoXN8PA+CebiEDNXgWMEBPDlWJKVxxenvu/CIqV5WdY8J0TRh
         H7HohKbEwv4NWgHvO0S5LMS6DIck+uaRkKE2E3YE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.5 018/542] media: i2c: adv748x: Fix unsafe macros
Date:   Fri, 14 Feb 2020 10:40:10 -0500
Message-Id: <20200214154854.6746-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit 0d962e061abcf1b9105f88fb850158b5887fbca3 ]

Enclose multiple macro parameters in parentheses in order to
make such macros safer and fix the Clang warning below:

drivers/media/i2c/adv748x/adv748x-afe.c:452:12: warning: operator '?:'
has lower precedence than '|'; '|' will be evaluated first
[-Wbitwise-conditional-parentheses]

ret = sdp_clrset(state, ADV748X_SDP_FRP, ADV748X_SDP_FRP_MASK, enable
? ctrl->val - 1 : 0);

Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv748x/adv748x.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 5042f9e94aee2..fccb388ce179f 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -394,10 +394,10 @@ int adv748x_write_block(struct adv748x_state *state, int client_page,
 
 #define io_read(s, r) adv748x_read(s, ADV748X_PAGE_IO, r)
 #define io_write(s, r, v) adv748x_write(s, ADV748X_PAGE_IO, r, v)
-#define io_clrset(s, r, m, v) io_write(s, r, (io_read(s, r) & ~m) | v)
+#define io_clrset(s, r, m, v) io_write(s, r, (io_read(s, r) & ~(m)) | (v))
 
 #define hdmi_read(s, r) adv748x_read(s, ADV748X_PAGE_HDMI, r)
-#define hdmi_read16(s, r, m) (((hdmi_read(s, r) << 8) | hdmi_read(s, r+1)) & m)
+#define hdmi_read16(s, r, m) (((hdmi_read(s, r) << 8) | hdmi_read(s, (r)+1)) & (m))
 #define hdmi_write(s, r, v) adv748x_write(s, ADV748X_PAGE_HDMI, r, v)
 
 #define repeater_read(s, r) adv748x_read(s, ADV748X_PAGE_REPEATER, r)
@@ -405,11 +405,11 @@ int adv748x_write_block(struct adv748x_state *state, int client_page,
 
 #define sdp_read(s, r) adv748x_read(s, ADV748X_PAGE_SDP, r)
 #define sdp_write(s, r, v) adv748x_write(s, ADV748X_PAGE_SDP, r, v)
-#define sdp_clrset(s, r, m, v) sdp_write(s, r, (sdp_read(s, r) & ~m) | v)
+#define sdp_clrset(s, r, m, v) sdp_write(s, r, (sdp_read(s, r) & ~(m)) | (v))
 
 #define cp_read(s, r) adv748x_read(s, ADV748X_PAGE_CP, r)
 #define cp_write(s, r, v) adv748x_write(s, ADV748X_PAGE_CP, r, v)
-#define cp_clrset(s, r, m, v) cp_write(s, r, (cp_read(s, r) & ~m) | v)
+#define cp_clrset(s, r, m, v) cp_write(s, r, (cp_read(s, r) & ~(m)) | (v))
 
 #define tx_read(t, r) adv748x_read(t->state, t->page, r)
 #define tx_write(t, r, v) adv748x_write(t->state, t->page, r, v)
-- 
2.20.1

