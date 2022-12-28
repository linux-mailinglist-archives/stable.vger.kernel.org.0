Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B316D6579B8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbiL1PD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbiL1PD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:03:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C662E12097
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65AAF61541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771D8C433EF;
        Wed, 28 Dec 2022 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239835;
        bh=c4hsV7i8ymG8pi0rs0ItIYG7BfhreTpAMJMVsu1akkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKozXE/TSLfx0Rn4dCYJh2qVEsyFd+Cb9Nk2QAp2W9lZnodgXrbP4Te6TrUlmaPqq
         iBJA58vSNu9GI0/8VQs4fMMj5mmXiFPDkOxq3P44xn3k+WFY/VZ8zHAY9boDYmVlM/
         jsSUjZe5dpSVtsk+VJtpFrsPiMU9uwiZORXM8AO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0084/1073] pstore/ram: Fix error return code in ramoops_probe()
Date:   Wed, 28 Dec 2022 15:27:52 +0100
Message-Id: <20221228144330.343853344@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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



