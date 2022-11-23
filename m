Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2716355AD
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbiKWJWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbiKWJVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:21:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F708FF8F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E49A7B81EF8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340D6C433C1;
        Wed, 23 Nov 2022 09:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195285;
        bh=xCWnvIs5+FE3WGA+NbQd7/TUPBNTUHLPbYBxghL3W7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVhCNEUsYzd9g/YbyP24WYQJTJUceA7TiAiqqtMKiVyj2x6M/L23kf7Zv3LzU18NE
         aAxagdbLXLqSfl7XjjLJa2yw2vzO9s0TXQBYOinGF7N9vuzqyPexTa+aSIoiBthh2i
         QgH4Y7wOi4S00piJKzpaRAs4RXFQaTTDHePMOn9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/149] tty: n_gsm: fix sleep-in-atomic-context bug in gsm_control_send
Date:   Wed, 23 Nov 2022 09:50:25 +0100
Message-Id: <20221123084559.474575755@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 7b7dfe4833c70a11cdfa51b38705103bd31eddaa ]

The function gsm_dlci_t1() is a timer handler that runs in an
atomic context, but it calls "kzalloc(..., GFP_KERNEL)" that
may sleep. As a result, the sleep-in-atomic-context bug will
happen. The process is shown below:

gsm_dlci_t1()
 gsm_dlci_open()
  gsm_modem_update()
   gsm_modem_upd_via_msc()
    gsm_control_send()
     kzalloc(sizeof(.., GFP_KERNEL) //may sleep

This patch changes the gfp_t parameter of kzalloc() from GFP_KERNEL to
GFP_ATOMIC in order to mitigate the bug.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20221002040709.27849-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c91a3004931f..e85282825973 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1416,7 +1416,7 @@ static struct gsm_control *gsm_control_send(struct gsm_mux *gsm,
 		unsigned int command, u8 *data, int clen)
 {
 	struct gsm_control *ctrl = kzalloc(sizeof(struct gsm_control),
-						GFP_KERNEL);
+						GFP_ATOMIC);
 	unsigned long flags;
 	if (ctrl == NULL)
 		return NULL;
-- 
2.35.1



