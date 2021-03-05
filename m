Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817D832E810
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhCEMYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230488AbhCEMYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1FD165026;
        Fri,  5 Mar 2021 12:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947074;
        bh=pLN04nk1vQjTeNgn4u+poqWwchJtkkjKzP4/dKlYfYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aqIdyA+bA7cBsml4Oqr4TwNWZF5mlEWiS2tw2ILknFZZiOxbG1sQRRSXrI/kUAC4
         5d5A6RXPxvx3+5O5gsQOKFb2tDFnWa1sxqfP10vtXwiIrozJHSrQKSFs9olKAXLZ5w
         +vmuX1GeF7nGrSf8yPz8vGBdP0jxAiPQiEH2rQmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+42d8c7c3d3e594b34346@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 009/104] media: v4l2-ctrls.c: fix shift-out-of-bounds in std_validate
Date:   Fri,  5 Mar 2021 13:20:14 +0100
Message-Id: <20210305120903.649367319@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 048c96e28674f15c0403deba2104ffba64544a06 upstream.

If a menu has more than 64 items, then don't check menu_skip_mask
for items 65 and up.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: syzbot+42d8c7c3d3e594b34346@syzkaller.appspotmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2165,7 +2165,8 @@ static int std_validate(const struct v4l
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 		if (ptr.p_s32[idx] < ctrl->minimum || ptr.p_s32[idx] > ctrl->maximum)
 			return -ERANGE;
-		if (ctrl->menu_skip_mask & (1ULL << ptr.p_s32[idx]))
+		if (ptr.p_s32[idx] < BITS_PER_LONG_LONG &&
+		    (ctrl->menu_skip_mask & BIT_ULL(ptr.p_s32[idx])))
 			return -EINVAL;
 		if (ctrl->type == V4L2_CTRL_TYPE_MENU &&
 		    ctrl->qmenu[ptr.p_s32[idx]][0] == '\0')


