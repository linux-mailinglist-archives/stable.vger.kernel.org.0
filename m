Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490916AEABD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjCGRg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjCGRgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:36:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5791FE5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD9E7B819B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260AEC433D2;
        Tue,  7 Mar 2023 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210355;
        bh=Dr4UgnbPZavGc00jvzwSHphBvr4c9pRFkQ2wVVRoK8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=einYnYZUdD+M6teHUfXrnrnN9g/QUJcGiPl/1nXmMkILqdtbT1vRfoqDV2T67wyUK
         VMNN8N2EUw1DC3151aURECnCjGuGSEYgrtJzW97zh3WDTJRdlA8wquZfMjIJn0YqEq
         /sVkVDm4L+oIZxLFXa9NHMmOPz0DtIyinqko4+O4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0514/1001] Revert "char: pcmcia: cm4000_cs: Replace mdelay with usleep_range in set_protocol"
Date:   Tue,  7 Mar 2023 17:54:46 +0100
Message-Id: <20230307170043.739128013@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 70fae37a09268455b8ab4f64647086b61da6f39c ]

This reverts commit be826ada52f1fcabed5b5217c94609ebf5967211.

The function monitor_card() is a timer handler that runs in an
atomic context, but it calls usleep_range() that can sleep.
As a result, the sleep-in-atomic-context bugs will happen.
The process is shown below:

    (atomic context)
monitor_card()
  set_protocol()
    usleep_range() //sleep

The origin commit c1986ee9bea3 ("[PATCH] New Omnikey Cardman
4000 driver") works fine.

Fixes: be826ada52f1 ("char: pcmcia: cm4000_cs: Replace mdelay with usleep_range in set_protocol")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20230118141000.5580-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/pcmcia/cm4000_cs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index adaec8fd4b16c..e656f42a28ac2 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -529,7 +529,8 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 			DEBUGP(5, dev, "NumRecBytes is valid\n");
 			break;
 		}
-		usleep_range(10000, 11000);
+		/* can not sleep as this is in atomic context */
+		mdelay(10);
 	}
 	if (i == 100) {
 		DEBUGP(5, dev, "Timeout waiting for NumRecBytes getting "
@@ -549,7 +550,8 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 			}
 			break;
 		}
-		usleep_range(10000, 11000);
+		/* can not sleep as this is in atomic context */
+		mdelay(10);
 	}
 
 	/* check whether it is a short PTS reply? */
-- 
2.39.2



