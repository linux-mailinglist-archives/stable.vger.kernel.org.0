Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414B38AA24
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 00:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfHLWJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 18:09:17 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44655 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHLWJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 18:09:17 -0400
Received: by mail-lj1-f195.google.com with SMTP id e24so3011574ljg.11
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 15:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jv4vjvon820rdz2/ZYNeWVdf9J0eLgu+Z1XIwQm8nz0=;
        b=FEtwW4Hpn9BaQfo1umVm9B1zGDFm7rTZiEdF8GZ1V60fH/qFKT8c7kJd5QZQ80uBCE
         kGKLu7KU3gZZgKx63Yy4xmb7sLjCJ77QpWA30bYbYI93Y4Sfif+BMncW494531ptSrPM
         F1mqBFxc3N/CT7VQO5pqE2H2wy2/s99zAewZuJNmzabck7O4Oi0Rftcr2+EyUB7OWJTk
         NWNoTWq8y3lXDRMokm1pyquc0G88QW6xQt3dYEv3NqDn5gwOZh/TzWHi2UU0eNLiu9aq
         XX6q5RrnxGwrn7qMZ7DaalXXYpvfRuHLjyBVOTySSo4B7m7uGgR7fezp/YFRi8Q35OOK
         ZliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jv4vjvon820rdz2/ZYNeWVdf9J0eLgu+Z1XIwQm8nz0=;
        b=Zrhr6uMP8h/HcaJ+dzXla1rdEcI/ECZMiJz2SH8QD2VzSi4c7+x647RNNo4Mj7rTr9
         m84spanlwKCfGn8dsr1W+/FHkQZtsQAHYJRGRlF8XepY5htjy1P90xYqfmwr0OtsAGe2
         NSOXbS7Pe4Aytq1BXcpfZIO3PnjI1LdvqKzbmGEA7qLWjnbLyk0Us4XE+7/k0yIxGaSx
         4cKaq9kKMdAdRl1rFzBo/5v8z8/YzYojzsz8tdjRsUH60b1rOEnUpZ0L9DWla3SpXYZe
         G7XNdbp1XoRrwnihHSJv8TxbwORlCD6kCPSdUlxkGd0v+tdV6CAepwQ6/qYN8c/ZxTyK
         SkDg==
X-Gm-Message-State: APjAAAUB+ePlLYdlJ0FQhdE/FY5lMxCMn9zZI2bwlkbhiT2k9mhVrTx0
        NaKRLD77H9lpASukvkUwXeA=
X-Google-Smtp-Source: APXvYqxYVcpJ35sgtJAE0YpfqL1T+98suH53WOw2dlocdGYxbAWmBtorbCl6O8OuWxnboMZVKCfuLw==
X-Received: by 2002:a2e:29cb:: with SMTP id p72mr5959711ljp.31.1565647755438;
        Mon, 12 Aug 2019 15:09:15 -0700 (PDT)
Received: from octofox.cadence.com (jcmvbkbc-1-pt.tunnel.tserv24.sto1.ipv6.he.net. [2001:470:27:1fa::2])
        by smtp.gmail.com with ESMTPSA id a13sm19452468lfi.57.2019.08.12.15.09.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 15:09:13 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] xtensa: add missing isync to the cpu_reset TLB code
Date:   Mon, 12 Aug 2019 15:08:47 -0700
Message-Id: <20190812220847.14624-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ITLB entry modifications must be followed by the isync instruction
before the new entries are possibly used. cpu_reset lacks one isync
between ITLB way 6 initialization and jump to the identity mapping.
Add missing isync to xtensa cpu_reset.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 5cb8a62e091c..7c3106093c75 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -511,6 +511,7 @@ void cpu_reset(void)
 				      "add	%2, %2, %7\n\t"
 				      "addi	%0, %0, -1\n\t"
 				      "bnez	%0, 1b\n\t"
+				      "isync\n\t"
 				      /* Jump to identity mapping */
 				      "jx	%3\n"
 				      "2:\n\t"
-- 
2.11.0

