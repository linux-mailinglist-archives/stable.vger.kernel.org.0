Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F65635527
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbiKWJQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237344AbiKWJPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:15:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69F1108918
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:15:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 820DFB81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF898C433C1;
        Wed, 23 Nov 2022 09:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194943;
        bh=3ck9Xe5tg1QfdZeBDOx83UjQJzLEsPFRPeEwmuhrhc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OisEft1MH1NU6M4k4nHtYeLxej/xnI6hfiUelYI6/VnYR5yjZmyAVbIe8Ryy8YhS
         zxEfnHi5MnIsT4qSvdJ3YvoKkcVvY7eyu6X2fe70PvDBPg/CFWpmP0KsLyt+mplENj
         O8aERGN+/sZYud265DsxUgtBQg8svvIci6U5ncZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/156] xen/pcpu: fix possible memory leak in register_pcpu()
Date:   Wed, 23 Nov 2022 09:51:01 +0100
Message-Id: <20221123084601.731003121@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
index cdc6daa7a9f6..9cf7085a260b 100644
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



