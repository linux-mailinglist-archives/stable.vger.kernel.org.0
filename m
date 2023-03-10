Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982A76B4192
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjCJNyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjCJNyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:54:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C87734035
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:54:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8B1FB822B5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FB0C433D2;
        Fri, 10 Mar 2023 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456458;
        bh=s8HttMRlfxiQVjgYNpcGtmLGKklX1y1jNFUtoylxP2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQNj79g/Cs0TBUpknDRjJgFKaOw72bZgFLFmkveia57EUIyF4H3Pa4DoWT9H1n8w2
         Fa0Tb07A+hjjeqz5tHNTvXgmB3LMfzIej3xpPxSZsNCrAfxejo5yT8z6xOC8TlVvkw
         ollHHjaxs+A9/vXEI+D88DUYrr6Hp9Ej4N8v6DX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kernel test robot <lkp@intel.com>,
        Jianglei Nie <niejianglei2021@163.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 002/211] auxdisplay: hd44780: Fix potential memory leak in hd44780_remove()
Date:   Fri, 10 Mar 2023 14:36:22 +0100
Message-Id: <20230310133718.767222555@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit ddf75a86aba2cfb7ec4497e8692b60c8c8fe0ee7 ]

hd44780_probe() allocates a memory chunk for hd with kzalloc() and
makes "lcd->drvdata->hd44780" point to it. When we call hd44780_remove(),
we should release all relevant memory and resource. But "lcd->drvdata
->hd44780" is not released, which will lead to a memory leak.

We should release the "lcd->drvdata->hd44780" in hd44780_remove() to fix
the memory leak bug.

Fixes: 718e05ed92ec ("auxdisplay: Introduce hd44780_common.[ch]")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/hd44780.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/auxdisplay/hd44780.c b/drivers/auxdisplay/hd44780.c
index 8b2a0eb3f32a4..d56a5d508ccd7 100644
--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -322,8 +322,10 @@ static int hd44780_probe(struct platform_device *pdev)
 static int hd44780_remove(struct platform_device *pdev)
 {
 	struct charlcd *lcd = platform_get_drvdata(pdev);
+	struct hd44780_common *hdc = lcd->drvdata;
 
 	charlcd_unregister(lcd);
+	kfree(hdc->hd44780);
 	kfree(lcd->drvdata);
 
 	kfree(lcd);
-- 
2.39.2



