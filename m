Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390173F63C2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhHXQ6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234249AbhHXQ5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A24A61374;
        Tue, 24 Aug 2021 16:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824208;
        bh=WV6j3ItJK6lKMbui71mYR3fC1rSLHge8B9tDITunFbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZimwG/kKZYA2R+QELudv+5JLt8+mxHRNHdsuwvO0yeT0zUu5ZvfIOareF6GEoaFu7
         VxxCGkLj6R7czcy5W3jf1NjeAJ/Zbc4HSJ7jrWnCob0UDXGIBNKHBOaCKt17SvYnv1
         0IQeIqkN81jL0lLB6YBjWGKJTKAMyj4kY1FcawGfyZiN/hPGqC/0iMQ1wqL1kwNPda
         3x5zAabI23vvuGLAnaFUUHTclM+rDeSHyQIhMPpYgn0a6DiHNv09VxyKa7RoYLeOuT
         XP1gLFIx5HHkkoRsbYM7WfYAJEe+WnjItVI4dd5a++FObg6V+bQF1xcy2yKppT5n2o
         FbZm/QjMXwadw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Pavel Machek <pavel@denx.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 041/127] bus: ti-sysc: Fix error handling for sysc_check_active_timer()
Date:   Tue, 24 Aug 2021 12:54:41 -0400
Message-Id: <20210824165607.709387-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 06a089ef644934372a3062528244fca3417d3430 ]

We have changed the return type for sysc_check_active_timer() from -EBUSY
to -ENXIO, but the gpt12 system timer fix still checks for -EBUSY. We are
also not returning on other errors like we did earlier as noted by
Pavel Machek <pavel@denx.de>.

Commit 3ff340e24c9d ("bus: ti-sysc: Fix gpt12 system timer issue with
reserved status") should have been updated for commit 65fb73676112
("bus: ti-sysc: suppress err msg for timers used as clockevent/source").

Let's fix the issue by checking for -ENXIO and returning on any other
errors as suggested by Pavel Machek <pavel@denx.de>.

Fixes: 3ff340e24c9d ("bus: ti-sysc: Fix gpt12 system timer issue with reserved status")
Depends-on: 65fb73676112 ("bus: ti-sysc: suppress err msg for timers used as clockevent/source")
Reported-by: Pavel Machek <pavel@denx.de>
Reviewed-by: Pavel Machek (CIP) <pavel@denx.de>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 0ef98e3ba341..148a4dd8cb9a 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3097,8 +3097,10 @@ static int sysc_probe(struct platform_device *pdev)
 		return error;
 
 	error = sysc_check_active_timer(ddata);
-	if (error == -EBUSY)
+	if (error == -ENXIO)
 		ddata->reserved = true;
+	else if (error)
+		return error;
 
 	error = sysc_get_clocks(ddata);
 	if (error)
-- 
2.30.2

