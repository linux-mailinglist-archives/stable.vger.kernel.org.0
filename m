Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1113F6356F8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237924AbiKWJgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237932AbiKWJf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:35:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0345F72F1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:33:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 538BA61B66
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43221C433B5;
        Wed, 23 Nov 2022 09:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196002;
        bh=Jau3y2sudsN1E+ARMnAzQIS/xvn7ldlaGKdO4aNb2EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qle65CjX1Ao/otjqELSU74aHvxTqSX9pwyxoqe1TVDxIFUeMqHjK2aZCjtvDpa9ZG
         JxCnFId/1+xuPO8piW7qSs6vx03Nb8npEqJ+BVTLR9ht2dEv74XAn1Emn2oWRWR9hS
         7JPVoCW/WWRpi1mqoGofgEqW7MT+wKp3Rn0Uz38Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/181] xen/pcpu: fix possible memory leak in register_pcpu()
Date:   Wed, 23 Nov 2022 09:50:54 +0100
Message-Id: <20221123084606.266644534@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit da36a2a76b01b210ffaa55cdc2c99bc8783697c5 ]

In device_add(), dev_set_name() is called to allocate name, if it returns
error, the name need be freed. As comment of device_register() says, it
should use put_device() to give up the reference in the error path. So fix
this by calling put_device(), then the name can be freed in kobject_cleanup().

Fixes: f65c9bb3fb72 ("xen/pcpu: Xen physical cpus online/offline sys interface")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221110152441.401630-1-yangyingliang@huawei.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pcpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index 47aa3a1ccaf5..fd3a644b0855 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -228,7 +228,7 @@ static int register_pcpu(struct pcpu *pcpu)
 
 	err = device_register(dev);
 	if (err) {
-		pcpu_release(dev);
+		put_device(dev);
 		return err;
 	}
 
-- 
2.35.1



