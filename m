Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBB099DD9
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391679AbfHVRW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390121AbfHVRW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:56 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B18A233FC;
        Thu, 22 Aug 2019 17:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494575;
        bh=LDLY9fVEYlckPoMp5njUIgWaniUMPrNb/kq0sauyZjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDWjcUIcwGcFrJxJMIIdjom+HAeyWPtef2TFB4qf5ce9mMc4QC0FADH9M8VGBjTVi
         9OVCTLk1nYuJ7Sz4BKlUCKxeQ8YGOJtaLC3edqSLcwzdBLhO9vTNfZun94eN7tiGEm
         wsycixNIIc3m1w63A13ENSIMmPCdGV7dSCAQGyR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hui Wang <hui.wang@canonical.com>
Subject: [PATCH 4.4 66/78] Input: psmouse - fix build error of multiple definition
Date:   Thu, 22 Aug 2019 10:19:10 -0700
Message-Id: <20190822171833.942626155@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 49e6979e7e92cf496105b5636f1df0ac17c159c0 upstream.

trackpoint_detect() should be static inline while
CONFIG_MOUSE_PS2_TRACKPOINT is not set, otherwise, we build fails:

drivers/input/mouse/alps.o: In function `trackpoint_detect':
alps.c:(.text+0x8e00): multiple definition of `trackpoint_detect'
drivers/input/mouse/psmouse-base.o:psmouse-base.c:(.text+0x1b50): first defined here

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 55e3d9224b60 ("Input: psmouse - allow disabing certain protocol extensions")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/trackpoint.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/trackpoint.h
+++ b/drivers/input/mouse/trackpoint.h
@@ -153,7 +153,8 @@ struct trackpoint_data
 #ifdef CONFIG_MOUSE_PS2_TRACKPOINT
 int trackpoint_detect(struct psmouse *psmouse, bool set_properties);
 #else
-inline int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
+static inline int trackpoint_detect(struct psmouse *psmouse,
+				    bool set_properties)
 {
 	return -ENOSYS;
 }


