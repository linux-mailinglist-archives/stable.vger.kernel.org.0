Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6437615BE5
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfEGF62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728262AbfEGFhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 962A52087F;
        Tue,  7 May 2019 05:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207427;
        bh=wbY17iC+YFYv7hcWzcyg95eJdFrNRIjFZv1JtEP1hZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PM0raNILrCXWIPqhaRNXYi23oi8UoE5DAjCZ6BSBtItNIt2PvuYK/3vYeiknRzgO+
         7pDYEVHBxaWRWGd6b5gbq2y5HJl856vnW7zUuAh/0Fk90gT8N4wokiPCgGy3Q/XpE4
         cHHqL7o2fD+QiK0D9so4y0L2AhWcX/lGH179TrG0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Camuso <tcamuso@redhat.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 37/81] ipmi: ipmi_si_hardcode.c: init si_type array to fix a crash
Date:   Tue,  7 May 2019 01:35:08 -0400
Message-Id: <20190507053554.30848-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Camuso <tcamuso@redhat.com>

[ Upstream commit a885bcfd152f97b25005298ab2d6b741aed9b49c ]

The intended behavior of function ipmi_hardcode_init_one() is to default
to kcs interface when no type argument is presented when initializing
ipmi with hard coded addresses.

However, the array of char pointers allocated on the stack by function
ipmi_hardcode_init() was not inited to zeroes, so it contained stack
debris.

Consequently, passing the cruft stored in this array to function
ipmi_hardcode_init_one() caused a crash when it was unable to detect
that the char * being passed was nonsense and tried to access the
address specified by the bogus pointer.

The fix is simply to initialize the si_type array to zeroes, so if
there were no type argument given to at the command line, function
ipmi_hardcode_init_one() could properly default to the kcs interface.

Signed-off-by: Tony Camuso <tcamuso@redhat.com>
Message-Id: <1554837603-40299-1-git-send-email-tcamuso@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_si_hardcode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_si_hardcode.c b/drivers/char/ipmi/ipmi_si_hardcode.c
index 9ae2405c28bb..0c28e872ad3a 100644
--- a/drivers/char/ipmi/ipmi_si_hardcode.c
+++ b/drivers/char/ipmi/ipmi_si_hardcode.c
@@ -200,6 +200,8 @@ void __init ipmi_hardcode_init(void)
 	char *str;
 	char *si_type[SI_MAX_PARMS];
 
+	memset(si_type, 0, sizeof(si_type));
+
 	/* Parse out the si_type string into its components. */
 	str = si_type_str;
 	if (*str != '\0') {
-- 
2.20.1

