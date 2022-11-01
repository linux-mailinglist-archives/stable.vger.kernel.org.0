Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F69A614970
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiKALha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiKALhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97181D0EF;
        Tue,  1 Nov 2022 04:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57281615FB;
        Tue,  1 Nov 2022 11:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC6BC43140;
        Tue,  1 Nov 2022 11:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302268;
        bh=LD0hUez/+4eQ/JcqQmqxn2cEjEtVgr9CXGubJIH/Jtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lc1fFQmtZMJ5icOpHseNSqPWED6HhDZlhjctrN8SIkQKH736XGah+X5m0NGbunqwe
         D2IJ5nAf8pMqyPzpYk/5e7RedhWERwYn8RcIQ2Byzy6aaGerSuauUO3C+da4SJr9VX
         2AN67HJQnePNiRh/FSd7VXHJS997qxKOBCdDNcPQtupcGX57iS6ctr+JF+/YGkrJXu
         1a0vPyeU6AII2giOIJBs3ksFH9CTzCh7PN50S2alp3+biYQYGX9gOCC346BKC3xulU
         thwYzy7n/8Fw1fuNRQC5h4N75OCgQwiMZGBvrCq/G12PGFs7waDqJSWH0SzHk6W8MW
         SHuSh/4RkFwrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, neil.armstrong@linaro.org,
        gregkh@linuxfoundation.org, khilman@baylibre.com,
        linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-staging@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 4/8] media: meson: vdec: fix possible refcount leak in vdec_probe()
Date:   Tue,  1 Nov 2022 07:30:53 -0400
Message-Id: <20221101113059.800777-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113059.800777-1-sashal@kernel.org>
References: <20221101113059.800777-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 7718999356234d9cc6a11b4641bb773928f1390f ]

v4l2_device_unregister need to be called to put the refcount got by
v4l2_device_register when vdec_probe fails or vdec_remove is called.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/meson/vdec/vdec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/meson/vdec/vdec.c b/drivers/staging/media/meson/vdec/vdec.c
index 8dd1396909d7..a242bbe23ba2 100644
--- a/drivers/staging/media/meson/vdec/vdec.c
+++ b/drivers/staging/media/meson/vdec/vdec.c
@@ -1074,6 +1074,7 @@ static int vdec_probe(struct platform_device *pdev)
 
 err_vdev_release:
 	video_device_release(vdev);
+	v4l2_device_unregister(&core->v4l2_dev);
 	return ret;
 }
 
@@ -1082,6 +1083,7 @@ static int vdec_remove(struct platform_device *pdev)
 	struct amvdec_core *core = platform_get_drvdata(pdev);
 
 	video_unregister_device(core->vdev_dec);
+	v4l2_device_unregister(&core->v4l2_dev);
 
 	return 0;
 }
-- 
2.35.1

