Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41C26356B1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbiKWJcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237763AbiKWJb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:31:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D81397A93
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:30:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E01D161B66
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F9AC433D6;
        Wed, 23 Nov 2022 09:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195853;
        bh=I0tG2LI/feY8iVTml1aIpolkt/8PLqIhy+IbVZribcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdtuwbxgoL7QckRaxrh+4rL0WS2vTKt1fhcSvgOu9HvT+wYnEzIGozAmi5paN67ed
         W6puZg44Ta1lnExGCMd+7bNROWB18fRTXbmu1jgMKnvcsWvws5PL3JoiaYsxTo8+S1
         Ifb7S5drA07APFcr7WnhPVxnidmmMDdAxvaFFPEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/181] serial: 8250: omap: Fix unpaired pm_runtime_put_sync() in omap8250_remove()
Date:   Wed, 23 Nov 2022 09:50:13 +0100
Message-Id: <20221123084604.527633420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e3f0c638f428fd66b5871154b62706772045f91a ]

On remove, we get an error for "Runtime PM usage count underflow!". I guess
this driver is mostly built-in, and this issue has gone unnoticed for a
while. Somehow I did not catch this issue with my earlier fix done with
commit 4e0f5cc65098 ("serial: 8250_omap: Fix probe and remove for PM
runtime").

Fixes: 4e0f5cc65098 ("serial: 8250_omap: Fix probe and remove for PM runtime")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Depends-on: dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
Link: https://lore.kernel.org/r/20221028105813.54290-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 5707d86cac76..f3f54cb0cfca 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1475,6 +1475,11 @@ static int omap8250_probe(struct platform_device *pdev)
 static int omap8250_remove(struct platform_device *pdev)
 {
 	struct omap8250_priv *priv = platform_get_drvdata(pdev);
+	int err;
+
+	err = pm_runtime_resume_and_get(&pdev->dev);
+	if (err)
+		return err;
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
-- 
2.35.1



