Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD8347AF47
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbhLTPKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239773AbhLTPJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7D5C08E84E;
        Mon, 20 Dec 2021 06:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6490BB80EA3;
        Mon, 20 Dec 2021 14:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9762EC36AE8;
        Mon, 20 Dec 2021 14:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012137;
        bh=R3XPoJv+S88z7BjtencXIUbZtQ0grCq4FQAvEiNl5jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpR9/lJk4RHZqCrx5wzLhkkHwhgUQ6IHVuOH3PCwjsE8xErY+bFoVN0mgM4uznCTu
         YnWWsy2mFtgfNXnXrqtEiwQqsC5rJmrvqjum4CtPmNDaH+FUicDDvGaCQIB/TMPeDL
         49j+gWFxWz9tBBLl7OXx9eMBFPjg3C7/ewdMg3TE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/177] soc/tegra: fuse: Fix bitwise vs. logical OR warning
Date:   Mon, 20 Dec 2021 15:34:03 +0100
Message-Id: <20211220143043.237692176@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit a7083763619f7485ccdade160deb81737cf2732f ]

A new warning in clang points out two instances where boolean
expressions are being used with a bitwise OR instead of logical OR:

drivers/soc/tegra/fuse/speedo-tegra20.c:72:9: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
                reg = tegra_fuse_read_spare(i) |
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
                                               ||
drivers/soc/tegra/fuse/speedo-tegra20.c:72:9: note: cast one or both operands to int to silence this warning
drivers/soc/tegra/fuse/speedo-tegra20.c:87:9: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
                reg = tegra_fuse_read_spare(i) |
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
                                               ||
drivers/soc/tegra/fuse/speedo-tegra20.c:87:9: note: cast one or both operands to int to silence this warning
2 warnings generated.

The motivation for the warning is that logical operations short circuit
while bitwise operations do not.

In this instance, tegra_fuse_read_spare() is not semantically returning
a boolean, it is returning a bit value. Use u32 for its return type so
that it can be used with either bitwise or boolean operators without any
warnings.

Fixes: 25cd5a391478 ("ARM: tegra: Add speedo-based process identification")
Link: https://github.com/ClangBuiltLinux/linux/issues/1488
Suggested-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/fuse-tegra.c | 2 +-
 drivers/soc/tegra/fuse/fuse.h       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra.c b/drivers/soc/tegra/fuse/fuse-tegra.c
index f2151815db585..e714ed3b61bc3 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra.c
@@ -320,7 +320,7 @@ static struct platform_driver tegra_fuse_driver = {
 };
 builtin_platform_driver(tegra_fuse_driver);
 
-bool __init tegra_fuse_read_spare(unsigned int spare)
+u32 __init tegra_fuse_read_spare(unsigned int spare)
 {
 	unsigned int offset = fuse->soc->info->spare + spare * 4;
 
diff --git a/drivers/soc/tegra/fuse/fuse.h b/drivers/soc/tegra/fuse/fuse.h
index de58feba04350..ecff0c08e9595 100644
--- a/drivers/soc/tegra/fuse/fuse.h
+++ b/drivers/soc/tegra/fuse/fuse.h
@@ -65,7 +65,7 @@ struct tegra_fuse {
 void tegra_init_revision(void);
 void tegra_init_apbmisc(void);
 
-bool __init tegra_fuse_read_spare(unsigned int spare);
+u32 __init tegra_fuse_read_spare(unsigned int spare);
 u32 __init tegra_fuse_read_early(unsigned int offset);
 
 u8 tegra_get_major_rev(void);
-- 
2.33.0



