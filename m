Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F6B60A647
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbiJXMd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbiJXMbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:31:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE22B1EC5C;
        Mon, 24 Oct 2022 05:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FB66B811C4;
        Mon, 24 Oct 2022 12:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0016AC433C1;
        Mon, 24 Oct 2022 12:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612917;
        bh=7Mf8pAymLKtC4kysmJdpY7SrgzbFoAL52CT2NFcnYPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WH8d2+TDwLJ5/N564TTn04sLP256U5QxUJCNysYeKiNwFO4VEGLOV7pm5POXvMN6T
         xcmBgnsS79hij97pem0Xh+J6pJj9liBWWLKOkoNCcYwihaxgP8sph2WqckVAE+RhxB
         ojeBgEnPl2WXP+VSOGHmLSvsNHXgWo9QUebPwIEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/229] mfd: lp8788: Fix an error handling path in lp8788_probe()
Date:   Mon, 24 Oct 2022 13:31:10 +0200
Message-Id: <20221024113003.892784504@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit becfdcd75126b20b8ec10066c5e85b34f8994ad5 ]

Should an error occurs in mfd_add_devices(), some resources need to be
released, as already done in the .remove() function.

Add an error handling path and a lp8788_irq_exit() call to undo a previous
lp8788_irq_init().

Fixes: eea6b7cc53aa ("mfd: Add lp8788 mfd driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/18398722da9df9490722d853e4797350189ae79b.1659261275.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/lp8788.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/lp8788.c b/drivers/mfd/lp8788.c
index acf616559512..e47150cdf747 100644
--- a/drivers/mfd/lp8788.c
+++ b/drivers/mfd/lp8788.c
@@ -199,8 +199,16 @@ static int lp8788_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	if (ret)
 		return ret;
 
-	return mfd_add_devices(lp->dev, -1, lp8788_devs,
-			       ARRAY_SIZE(lp8788_devs), NULL, 0, NULL);
+	ret = mfd_add_devices(lp->dev, -1, lp8788_devs,
+			      ARRAY_SIZE(lp8788_devs), NULL, 0, NULL);
+	if (ret)
+		goto err_exit_irq;
+
+	return 0;
+
+err_exit_irq:
+	lp8788_irq_exit(lp);
+	return ret;
 }
 
 static int lp8788_remove(struct i2c_client *cl)
-- 
2.35.1



