Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200BD621483
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiKHOCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbiKHOB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:01:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B9F682AE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:01:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 853EF61595
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BA9C433C1;
        Tue,  8 Nov 2022 14:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916115;
        bh=bqPkD1QPbT3aDJ0oBiF3trdy5bO/vWDb5s5mUqQjazo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqNF+7kx1/lSTMv1luWBRzb6JeMJ3Z08tngDstug5WlHJQ6oIeciSvvD0hP88oCyr
         p2zJWJOmHeFdf6KxdvdVLp9IVJwSxS3h2pkr4BpsPl3dDxq0T0jbn/wjwfpgQUcZma
         xH37DeMB1SC9HZpVePW55FOgnP+i9lUspEu53JfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/144] s390/cio: derive cdev information only for IO-subchannels
Date:   Tue,  8 Nov 2022 14:39:04 +0100
Message-Id: <20221108133348.123420265@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 0c3812c347bfb0dc213556a195e79850c55702f5 ]

cdev->online for the purge function must not be checked for the
non-IO subchannel type. Make sure that we are deriving the cdev only
from sch-type SUBCHANNEL_TYPE_IO.

Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 1b6074112742 ("s390/cio: fix out-of-bounds access on cio_ignore free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index c27809792609..ce9e7517430f 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -792,10 +792,13 @@ static int __unset_online(struct device *dev, void *data)
 {
 	struct idset *set = data;
 	struct subchannel *sch = to_subchannel(dev);
-	struct ccw_device *cdev = sch_get_cdev(sch);
+	struct ccw_device *cdev;
 
-	if (cdev && cdev->online)
-		idset_sch_del(set, sch->schid);
+	if (sch->st == SUBCHANNEL_TYPE_IO) {
+		cdev = sch_get_cdev(sch);
+		if (cdev && cdev->online)
+			idset_sch_del(set, sch->schid);
+	}
 
 	return 0;
 }
-- 
2.35.1



