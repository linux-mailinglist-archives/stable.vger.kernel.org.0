Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652412E6424
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404342AbgL1Nm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391739AbgL1NlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:41:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A2D02063A;
        Mon, 28 Dec 2020 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162838;
        bh=4WkGcy/+keBscqkemL2ALHP+oJLlWlSiD0U4fUeB4C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbhCa3UnltCuIvYFuMQVe4DKAYNCtUQzrgnXP7uFzM06EHMv4a7/hCXgWpTkyUSKW
         6apbQu4018JrcB8zN5om6SQwqPkaRQVqTHnVIyXUtkSqWXgHVOoVghUqvesajwiz3j
         fq50EoCWfkUcyIS14clWN72SvsDQUDEulMmGMbxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/453] soc: renesas: rmobile-sysc: Fix some leaks in rmobile_init_pm_domains()
Date:   Mon, 28 Dec 2020 13:45:15 +0100
Message-Id: <20201228124941.040127794@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit cf25d802e029c31efac8bdc979236927f37183bd ]

This code needs to call iounmap() on one error path.

Fixes: 2173fc7cb681 ("ARM: shmobile: R-Mobile: Add DT support for PM domains")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200923113142.GC1473821@mwanda
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/rmobile-sysc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/renesas/rmobile-sysc.c b/drivers/soc/renesas/rmobile-sysc.c
index 54b616ad4a62a..beb1c7211c3d6 100644
--- a/drivers/soc/renesas/rmobile-sysc.c
+++ b/drivers/soc/renesas/rmobile-sysc.c
@@ -327,6 +327,7 @@ static int __init rmobile_init_pm_domains(void)
 
 		pmd = of_get_child_by_name(np, "pm-domains");
 		if (!pmd) {
+			iounmap(base);
 			pr_warn("%pOF lacks pm-domains node\n", np);
 			continue;
 		}
-- 
2.27.0



