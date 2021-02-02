Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E34230CC83
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhBBT60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:58:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhBBNtk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:49:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1079964F51;
        Tue,  2 Feb 2021 13:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273346;
        bh=DNUeVOtvpRXsucio8TNJnv82TuZpb/w8BmTtj8IjETc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nf72jfPosnVGngbruETClWVlfb14QjIEAxGnTG3t19yBMRFGPfmfTsFW2SEbCU32d
         UbJfRjgMZAukWPGrR4ZNmqkuD25XED6HZqEUk+h++Y7J+jgUJ4E61eEaJ0acVfND/b
         1DAR5VLwS3eFbPJWjJgE6Ih4uek9qlavWo2CpHF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 071/142] clk: mmp2: fix build without CONFIG_PM
Date:   Tue,  2 Feb 2021 14:37:14 +0100
Message-Id: <20210202133000.653587661@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit c361c5a6c559d1e0a2717abe9162a71aa602954f upstream.

pm_clk_suspend()/pm_clk_resume() are defined as NULL pointers rather than
empty inline stubs without CONFIG_PM:

drivers/clk/mmp/clk-audio.c:402:16: error: called object type 'void *' is not a function or function pointer
        pm_clk_suspend(dev);
drivers/clk/mmp/clk-audio.c:411:15: error: called object type 'void *' is not a function or function pointer
        pm_clk_resume(dev);

I tried redefining the helper functions, but that caused additional
problems. This is the simple solution of replacing the __maybe_unused
trick with an #ifdef.

Fixes: 725262d29139 ("clk: mmp2: Add audio clock controller driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210103135503.3668784-1-arnd@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/clk/mmp/clk-audio.c b/drivers/clk/mmp/clk-audio.c
index eea69d498bd2..7aa7f4a9564f 100644
--- a/drivers/clk/mmp/clk-audio.c
+++ b/drivers/clk/mmp/clk-audio.c
@@ -392,7 +392,8 @@ static int mmp2_audio_clk_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __maybe_unused mmp2_audio_clk_suspend(struct device *dev)
+#ifdef CONFIG_PM
+static int mmp2_audio_clk_suspend(struct device *dev)
 {
 	struct mmp2_audio_clk *priv = dev_get_drvdata(dev);
 
@@ -404,7 +405,7 @@ static int __maybe_unused mmp2_audio_clk_suspend(struct device *dev)
 	return 0;
 }
 
-static int __maybe_unused mmp2_audio_clk_resume(struct device *dev)
+static int mmp2_audio_clk_resume(struct device *dev)
 {
 	struct mmp2_audio_clk *priv = dev_get_drvdata(dev);
 
@@ -415,6 +416,7 @@ static int __maybe_unused mmp2_audio_clk_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops mmp2_audio_clk_pm_ops = {
 	SET_RUNTIME_PM_OPS(mmp2_audio_clk_suspend, mmp2_audio_clk_resume, NULL)


