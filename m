Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D070660B282
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiJXQrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbiJXQqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:46:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68D88C02F;
        Mon, 24 Oct 2022 08:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08D12B811F9;
        Mon, 24 Oct 2022 12:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6416BC433D6;
        Mon, 24 Oct 2022 12:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615148;
        bh=+uBp4s5k9w8OaQPz9fOORY0Wxie4lKxtfkqZIUFQYQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6bn6K7jM87nYIReu5Qlg6TSPQh01eL7y22mMvqtupqPbSBU0mLstKEZV393jFvxN
         xqd9+oNbB4UAv58wOb296k6LdOunDtvG0I5bExC33TEx04R2UZXono4AbKKH9ug76h
         YZ2gYQtF8rp956mJGuJj2JQgnAQXQ1QcuijZvFrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/530] MIPS: SGI-IP27: Free some unused memory
Date:   Mon, 24 Oct 2022 13:28:05 +0200
Message-Id: <20221024113051.452439983@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

[ Upstream commit 33d7085682b4aa212ebfadbc21da81dfefaaac16 ]

platform_device_add_data() duplicates the memory it is passed. So we can
free some memory to save a few bytes that would remain unused otherwise.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 11bec9cba4de ("MIPS: SGI-IP27: Fix platform-device leak in bridge_platform_create()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sgi-ip27/ip27-xtalk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/sgi-ip27/ip27-xtalk.c b/arch/mips/sgi-ip27/ip27-xtalk.c
index 000ede156bdc..e762886d1dda 100644
--- a/arch/mips/sgi-ip27/ip27-xtalk.c
+++ b/arch/mips/sgi-ip27/ip27-xtalk.c
@@ -53,6 +53,8 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 	}
 	platform_device_add_resources(pdev, &w1_res, 1);
 	platform_device_add_data(pdev, wd, sizeof(*wd));
+	/* platform_device_add_data() duplicates the data */
+	kfree(wd);
 	platform_device_add(pdev);
 
 	bd = kzalloc(sizeof(*bd), GFP_KERNEL);
@@ -83,6 +85,8 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 	bd->io_offset	= offset;
 
 	platform_device_add_data(pdev, bd, sizeof(*bd));
+	/* platform_device_add_data() duplicates the data */
+	kfree(bd);
 	platform_device_add(pdev);
 	pr_info("xtalk:n%d/%x bridge widget\n", nasid, widget);
 	return;
-- 
2.35.1



