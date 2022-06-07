Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F81540B70
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351319AbiFGS26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiFGSXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:23:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D98C9EC0;
        Tue,  7 Jun 2022 10:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39E3961840;
        Tue,  7 Jun 2022 17:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759CCC36AFE;
        Tue,  7 Jun 2022 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624459;
        bh=b0y7kcZVJHUzbw5GlGaRG2weKRKicsuh66ywd8v6S5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBz0cknnyKL68jO+jmyHwTwSUl+UVUtmjCivpY2zHW4l5wMMj2lZePTFgiS5bb2Ya
         TSwYYqsNs9Wyc45UBs7NiBCTrkQer1C1uM48AsVMwLi+6z3+qPW71pOcD7axIpjmH9
         HDdzgGBNkshWByqQStErHtSpjwS7vc/1BVOIKzinx7fn9McvPfiYJP+wuZ5IQxdY/R
         c4prgWdL6WBP003+stsxrp4GFH6oFhhS5QdoLVxf7+2+l72dfqk2WoojumefvEHQtI
         e1NgT/5ZlPRYknDpBvQz1e/mhjaLZkVZ5u79R/XE3BiHjatYiQQqk22AFERvGLFRjC
         s2gDTLz9A0l7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Bin <zhengbin13@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, w.d.hubbs@gmail.com,
        chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, salah.triki@gmail.com,
        trix@redhat.com, speakup@linux-speakup.org
Subject: [PATCH AUTOSEL 5.17 29/60] accessiblity: speakup: Add missing misc_deregister in softsynth_probe
Date:   Tue,  7 Jun 2022 13:52:26 -0400
Message-Id: <20220607175259.478835-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

[ Upstream commit 106101303eda8f93c65158e5d72b2cc6088ed034 ]

softsynth_probe misses a call misc_deregister() in an error path, this
patch fixes that.

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Link: https://lore.kernel.org/r/20220511032937.2736738-1-zhengbin13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/speakup_soft.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accessibility/speakup/speakup_soft.c b/drivers/accessibility/speakup/speakup_soft.c
index 19824e7006fe..786dc5d080f3 100644
--- a/drivers/accessibility/speakup/speakup_soft.c
+++ b/drivers/accessibility/speakup/speakup_soft.c
@@ -397,6 +397,7 @@ static int softsynth_probe(struct spk_synth *synth)
 	synthu_device.name = "softsynthu";
 	synthu_device.fops = &softsynthu_fops;
 	if (misc_register(&synthu_device)) {
+		misc_deregister(&synth_device);
 		pr_warn("Couldn't initialize miscdevice /dev/softsynthu.\n");
 		return -ENODEV;
 	}
-- 
2.35.1

