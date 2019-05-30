Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC632EF5F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfE3DzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731841AbfE3DTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:14 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C485724833;
        Thu, 30 May 2019 03:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186353;
        bh=sevjn0uJTkyUM8L3gYJ3qfobXRLbjawz5SjfuXaYRhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A07QAtIOVgqqfupOh/82FuTWdU2rLI9zOjhL12U/+21ZpHwXQmOUehsVFh23wj+Ux
         EsQaadCBmdhGkdB2NQrzFXrV/SnY0xeDTz9yUt5SvwP8uLWUGUl+VmJrNtn1GWWYmk
         quBvtPvQAVWiVdyFWlH6u6IznMR99jTE0Bvxe6q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 095/193] media: pvrusb2: Prevent a buffer overflow
Date:   Wed, 29 May 2019 20:05:49 -0700
Message-Id: <20190530030502.245045781@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c1ced46c7b49ad7bc064e68d966e0ad303f917fb ]

The ctrl_check_input() function is called from pvr2_ctrl_range_check().
It's supposed to validate user supplied input and return true or false
depending on whether the input is valid or not.  The problem is that
negative shifts or shifts greater than 31 are undefined in C.  In
practice with GCC they result in shift wrapping so this function returns
true for some inputs which are not valid and this could result in a
buffer overflow:

    drivers/media/usb/pvrusb2/pvrusb2-ctrl.c:205 pvr2_ctrl_get_valname()
    warn: uncapped user index 'names[val]'

The cptr->hdw->input_allowed_mask mask is configured in pvr2_hdw_create()
and the highest valid bit is BIT(4).

Fixes: 7fb20fa38caa ("V4L/DVB (7299): pvrusb2: Improve logic which handles input choice availability")

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 2 ++
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 44975061b9536..ddededc4ced45 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -666,6 +666,8 @@ static int ctrl_get_input(struct pvr2_ctrl *cptr,int *vp)
 
 static int ctrl_check_input(struct pvr2_ctrl *cptr,int v)
 {
+	if (v < 0 || v > PVR2_CVAL_INPUT_MAX)
+		return 0;
 	return ((1 << v) & cptr->hdw->input_allowed_mask) != 0;
 }
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
index 25648add77e58..bd2b7a67b7322 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
@@ -50,6 +50,7 @@
 #define PVR2_CVAL_INPUT_COMPOSITE 2
 #define PVR2_CVAL_INPUT_SVIDEO 3
 #define PVR2_CVAL_INPUT_RADIO 4
+#define PVR2_CVAL_INPUT_MAX PVR2_CVAL_INPUT_RADIO
 
 enum pvr2_config {
 	pvr2_config_empty,    /* No configuration */
-- 
2.20.1



