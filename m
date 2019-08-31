Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89643A45F4
	for <lists+stable@lfdr.de>; Sat, 31 Aug 2019 21:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfHaTfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Aug 2019 15:35:39 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35004 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbfHaTfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Aug 2019 15:35:38 -0400
Received: by mail-io1-f68.google.com with SMTP id b10so21164205ioj.2;
        Sat, 31 Aug 2019 12:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:reply-to:organization:content-transfer-encoding;
        bh=8Hqd/SPehqjaIk2A5e2YsWPDyi1jXgD+VxsLa5kvdB4=;
        b=npg/ARhUtTzphx6ooZRB0DsV6WgbeUFJAs4mus5tNTyae96RlyBIAEIPV7Z1lGwocJ
         4HKzY240e+G53cicRpohHrdPv0EhCfQKKCpSqP/btau/Ktsc2bzhWlxe3ODAq48FyZf7
         gT1eF5v/G3Na0Bz990oy4roTpgT2cyAUyxlS0yPKomprfvQErdh6PngE62NWBTCI7u/e
         QJErUoxqsL3ZUzBwHOOyBuSIsYvrJEQ5W4pyQObWkX+5hvjZ75xvrUjJxzhZVoD6dPaY
         ibTlz2f2XAUZ1rJx+JfHqD62xg5z26EnVQW+i2Au4Er96Yw9FZdavYxQN0uYQZpc3nkL
         tg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:reply-to:organization
         :content-transfer-encoding;
        bh=8Hqd/SPehqjaIk2A5e2YsWPDyi1jXgD+VxsLa5kvdB4=;
        b=lmTjMwZ/uIJNVO/7oQ0+Mw+RLa3fAz1qiDJq7+dteRxi+tBqmLD1xjq9Gt4viwYuJK
         xIWOB9aZ3up73GqC7O7+ZrCeIXKJnGANSh8OKg1aJofpfTvVnmWOPb6a7qm9mlMc2dSm
         bp1hwaI03jEwyhNdoULtU5jVrF7rN23lZKaS9I1bXnBKNnDLBBDn4RnBv5yFFW66TBIU
         pRF4+w8fWrSTbVnsMjdKKWt3qFB6NtBbNPz3oN0+4PZ1eZ7U9hPA37jWVjZTZ5pinI2k
         5NlVGUlQityK4hK3z1CT9WvzE6esf3hOEnk+L8h34UmJEITqxOdY6kmAOC0WPaVczQ1o
         D3sQ==
X-Gm-Message-State: APjAAAXqKWyJmkXVaU3121M/kM82euPAMBrFMW7s/b0z29PurrDeYVxx
        if7NUrxdghwlrBxudw5mW7TDlom2
X-Google-Smtp-Source: APXvYqxxWj26OxGM7iJ2cUlCjYPdpj3d21c7TTfcX0yvRNl5d+bhobgzfUWfRj7U7nqEbBiC6MLkJw==
X-Received: by 2002:a6b:ba54:: with SMTP id k81mr26316892iof.143.1567280137664;
        Sat, 31 Aug 2019 12:35:37 -0700 (PDT)
Received: from nuc8.tds (h69-131-112-51.cntcnh.dsl.dynamic.tds.net. [69.131.112.51])
        by smtp.gmail.com with ESMTPSA id r2sm6937376ioh.61.2019.08.31.12.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 12:35:37 -0700 (PDT)
From:   Len Brown <lenb@kernel.org>
To:     linux-pm@vger.kernel.org
Cc:     Pu Wen <puwen@hygon.cn>, stable@vger.kernel.org,
        Calvin Walton <calvin.walton@kepstin.ca>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 17/19] tools/power turbostat: Fix caller parameter of get_tdp_amd()
Date:   Sat, 31 Aug 2019 15:34:56 -0400
Message-Id: <9cfa8e042f7cbb1994cc5923e46c78b36f6054f4.1567277326.git.len.brown@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <adb8049097a9ec4acd09fbd3aa8636199a78df8a.1567277326.git.len.brown@intel.com>
References: <adb8049097a9ec4acd09fbd3aa8636199a78df8a.1567277326.git.len.brown@intel.com>
MIME-Version: 1.0
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pu Wen <puwen@hygon.cn>

Commit 9392bd98bba760be96ee ("tools/power turbostat: Add support for AMD
Fam 17h (Zen) RAPL") add a function get_tdp_amd(), the parameter is CPU
family. But the rapl_probe_amd() function use wrong model parameter.
Fix the wrong caller parameter of get_tdp_amd() to use family.

Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Pu Wen <puwen@hygon.cn>
Reviewed-by: Calvin Walton <calvin.walton@kepstin.ca>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index f57c4023231e..6cec6aa01241 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4031,7 +4031,7 @@ void rapl_probe_amd(unsigned int family, unsigned int model)
 	rapl_energy_units = ldexp(1.0, -(msr >> 8 & 0x1f));
 	rapl_power_units = ldexp(1.0, -(msr & 0xf));
 
-	tdp = get_tdp_amd(model);
+	tdp = get_tdp_amd(family);
 
 	rapl_joule_counter_range = 0xFFFFFFFF * rapl_energy_units / tdp;
 	if (!quiet)
-- 
2.20.1

