Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE70D657A5F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiL1PLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiL1PKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:10:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1454213E03
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A80BCB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FD4C433EF;
        Wed, 28 Dec 2022 15:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240213;
        bh=c4hsV7i8ymG8pi0rs0ItIYG7BfhreTpAMJMVsu1akkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUxl1ZqjYdTkRx6VdbNqVlQNRYxaeHayjqWUqBJkqvnO9jK6luSlV3vz6l2/rn1hD
         sLrseiozxraFH4YY9LYjUeFZz57nW7f4aZbdZZNYKA43mu9+ex5lhsKt04OGY4QDfO
         zU3usKTOR86BnEPkN0OoT4vE3v7QskhGyUuWAOss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0096/1146] pstore/ram: Fix error return code in ramoops_probe()
Date:   Wed, 28 Dec 2022 15:27:15 +0100
Message-Id: <20221228144332.749662451@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit e1fce564900f8734edf15b87f028c57e14f6e28d ]

In the if (dev_of_node(dev) && !pdata) path, the "err" may be assigned a
value of 0, so the error return code -EINVAL may be incorrectly set
to 0. To fix set valid return code before calling to goto.

Fixes: 35da60941e44 ("pstore/ram: add Device Tree bindings")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/1669969374-46582-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index fefe3d391d3a..74e4d93f3e08 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -735,6 +735,7 @@ static int ramoops_probe(struct platform_device *pdev)
 	/* Make sure we didn't get bogus platform data pointer. */
 	if (!pdata) {
 		pr_err("NULL platform data\n");
+		err = -EINVAL;
 		goto fail_out;
 	}
 
@@ -742,6 +743,7 @@ static int ramoops_probe(struct platform_device *pdev)
 			!pdata->ftrace_size && !pdata->pmsg_size)) {
 		pr_err("The memory size and the record/console size must be "
 			"non-zero\n");
+		err = -EINVAL;
 		goto fail_out;
 	}
 
-- 
2.35.1



