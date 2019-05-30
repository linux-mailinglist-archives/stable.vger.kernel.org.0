Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76DF22F1C9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbfE3DPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbfE3DPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B75F724590;
        Thu, 30 May 2019 03:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186152;
        bh=Abh9yq3u4rDNWsfi/7nQqad8KR6xGjgWlEyf7rT3IYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpYYQhKGbGz8LjRzEZGajP+zRpLN+2kl3LPE8VWXPYYrXHmVAHcMLhmGUVO+3AS5F
         spEojtN/WPSkGhN/Fo4soFjrJ/r6JETAE0HdCytyvgs5SL+K56QpD6zcy85mdk325A
         TIp1nVeEbcyzdx9C1Wm9e2Xd1PBpCYTts3FNs7tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 337/346] ASoC: davinci-mcasp: Fix clang warning without CONFIG_PM
Date:   Wed, 29 May 2019 20:06:50 -0700
Message-Id: <20190530030557.809253714@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8ca5104715cfd14254ea5aecc390ae583b707607 ]

Building with clang shows a variable that is only used by the
suspend/resume functions but defined outside of their #ifdef block:

sound/soc/ti/davinci-mcasp.c:48:12: error: variable 'context_regs' is not needed and will not be emitted

We commonly fix these by marking the PM functions as __maybe_unused,
but here that would grow the davinci_mcasp structure, so instead
add another #ifdef here.

Fixes: 1cc0c054f380 ("ASoC: davinci-mcasp: Convert the context save/restore to use array")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index a10fcb5963c67..570d435e3e8be 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -44,6 +44,7 @@
 
 #define MCASP_MAX_AFIFO_DEPTH	64
 
+#ifdef CONFIG_PM
 static u32 context_regs[] = {
 	DAVINCI_MCASP_TXFMCTL_REG,
 	DAVINCI_MCASP_RXFMCTL_REG,
@@ -66,6 +67,7 @@ struct davinci_mcasp_context {
 	u32	*xrsr_regs; /* for serializer configuration */
 	bool	pm_state;
 };
+#endif
 
 struct davinci_mcasp_ruledata {
 	struct davinci_mcasp *mcasp;
-- 
2.20.1



