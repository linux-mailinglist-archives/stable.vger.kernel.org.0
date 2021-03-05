Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2529B32E8C9
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhCEM26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:28:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230143AbhCEM20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D227065029;
        Fri,  5 Mar 2021 12:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947306;
        bh=PyZUVxdJ9OYmIeHDw0sW9AkAYTeYyK7o3KG7+6dJtsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwKvqdy2qcrLwteMmRBEE7PjvHZP3GL865SJKUm8TN+aOVl+B1M8xQXMVg29K+hQV
         BJpb6XKY7JeizMWy9ogiVO0WQG7Xdhoex7KzTqX21G4Zj1v5Q2T2Aqy4ZjGRo+VCNF
         1kY9Ofp1++8UMRW5jwvJ33RQqnVxuxPhttx4rD9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+42d8c7c3d3e594b34346@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 011/102] media: v4l2-ctrls.c: fix shift-out-of-bounds in std_validate
Date:   Fri,  5 Mar 2021 13:20:30 +0100
Message-Id: <20210305120903.825852251@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
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
@@ -1987,7 +1987,8 @@ static int std_validate(const struct v4l
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 		if (ptr.p_s32[idx] < ctrl->minimum || ptr.p_s32[idx] > ctrl->maximum)
 			return -ERANGE;
-		if (ctrl->menu_skip_mask & (1ULL << ptr.p_s32[idx]))
+		if (ptr.p_s32[idx] < BITS_PER_LONG_LONG &&
+		    (ctrl->menu_skip_mask & BIT_ULL(ptr.p_s32[idx])))
 			return -EINVAL;
 		if (ctrl->type == V4L2_CTRL_TYPE_MENU &&
 		    ctrl->qmenu[ptr.p_s32[idx]][0] == '\0')


