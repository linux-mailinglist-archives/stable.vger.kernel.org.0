Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E6010E7D3
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfLBJmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:42:13 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34948 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfLBJmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:42:13 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so11265885wro.2
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SeakG/SO32j9YDGzR0+NdM33HAkLnvIddAgJpsxOi7w=;
        b=RoKAfrIuh0K7w7OXW818j6rYBtHlj/mkHvmg7blTec8lAshWSf4RcThsmtYheDjjhA
         SlaQIyzAxdZoEQVsiPM58iOn3XaIGjg1POxV8FrYfGktTLO+mHcWRFsNvcQ/M0BdUoLM
         MlpYvubFTn2PsOzX7iCUXLXYJY8Db5ATuCi2vP2Ba/5LxspPA/v2gG6AjnZ53uJEfFFu
         shD6vqPe5kgF5IANVI8DUOo7vjncSMsQnp9JT8h8bqgUD2MgLBRHuFDygMD9CtK5Jz7N
         6YGYHML7cKM+kTQ98JPQIJzvhzZkAB0j3ZyVELqhIMnX88jZwPBLDFVUWWRZEMuEhnjG
         xVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeakG/SO32j9YDGzR0+NdM33HAkLnvIddAgJpsxOi7w=;
        b=npnxFa7RvzKFcrXdr3JhHW5iYwhsOJJD3AhESaquqN+f5QyeNZsBwIMLl3tJer2k8a
         z7XvZdt1dJ4uHdwIBJFkhNB24iRnjgrLhJHzx+os3xSy/JdSADQyPZXo6R/b2wUT0hXF
         5RN9WJnCHKenvGssPi0JrjTuHpX8GCU3B46njxxYAvimibFHS201IZvevkWP7j4/JCW5
         8b+6BaBmFSY3AW/3QP0SNJMDOQn4seKswVVPzbeKTVwE8tzrX0Rq8Kx1R7sIVR1deeDM
         msnCDmfsnJdKxE/XVM8cfr/vVf99s/D//j1OpxoUP6qKrH2Cj4NkJj1rQ8YtX5TV2Tvn
         5YVA==
X-Gm-Message-State: APjAAAXJ4N5dYpzjQfS/fjV8n9mWTP2iQkrP+mNVETcmB7TZopzHR22X
        y9wtmY+evXlv25KiKIV7VhgKU1fKHW8=
X-Google-Smtp-Source: APXvYqxjkt97w9AGs4lzgyid3bz3DhwHYaEof2ZVnQoDYo+JG+wxpzbsOfh61zDD8YCXj89PUUOLzg==
X-Received: by 2002:adf:dc86:: with SMTP id r6mr53699895wrj.68.1575279731076;
        Mon, 02 Dec 2019 01:42:11 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id w8sm990381wmm.0.2019.12.02.01.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:42:10 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 2/4] media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE
Date:   Mon,  2 Dec 2019 09:41:48 +0000
Message-Id: <20191202094150.32485-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202094150.32485-1-lee.jones@linaro.org>
References: <20191202094150.32485-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit a0816e5088baab82aa738d61a55513114a673c8e ]

Control DO_WHITE_BALANCE is a button, with read only and execute-on-write flags.
Adding this control in the proper list in the fill function.

After adding it here, we can see output of v4l2-ctl -L
do_white_balance 0x0098090d (button) : flags=write-only, execute-on-write

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 3140ffbb1e67..9932b276f11a 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -991,6 +991,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FLASH_STROBE_STOP:
 	case V4L2_CID_AUTO_FOCUS_START:
 	case V4L2_CID_AUTO_FOCUS_STOP:
+	case V4L2_CID_DO_WHITE_BALANCE:
 		*type = V4L2_CTRL_TYPE_BUTTON;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY |
 			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
-- 
2.24.0

