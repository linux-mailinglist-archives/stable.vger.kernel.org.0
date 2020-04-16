Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE87F1AD090
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 21:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgDPTqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 15:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729391AbgDPTqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 15:46:17 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B005EC061A0C;
        Thu, 16 Apr 2020 12:46:16 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so30651wmk.5;
        Thu, 16 Apr 2020 12:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hdaOLswCaJX9E3ArN3QYtmnlCCcMvOx+Iq5pWMd6Dso=;
        b=OfBLCxcBOsBHsU/Vn3l5dO2t1moWKU5iCeduO4yh4CeJjnKbMnyG1XJGGL7BiJWUc9
         2BvuHk3F+PUQuNAJY+uawOJYwrmoEy8a1y0MqRy9WlvhEgRsWrSJKuD72uv8xTT5fEIC
         fJ3g8j/lHu6qNxsOG7yG/vQNHzDxUADZOgftsi1b+XRnAVZYXT7ekphW9vCGUkn/d4Su
         mrSRnCiNBDfUmgs+2Fw87kMzsV9FfqLHi582OHZsV2lsQtbw7kWO9moduDsPYEqO5veS
         2Of1ptHaNcYlbulCebjbZyKfhuZTkF5Oagep7ALCCzopn4cbxAfUBydpbzIj4TP5uo5V
         dauQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hdaOLswCaJX9E3ArN3QYtmnlCCcMvOx+Iq5pWMd6Dso=;
        b=FgxAijhpyRJ6ugDudx6Ekiu5p3tHSuji2yFpPr/LqJlZMSgJUUvFSDahDhMO+OZz90
         s9wurmg8ypsIiYqVdGfkfTB/Oh2dsUbhEXxtJ7QKl8ui0dzQq131iYnfFPpl8z0rAXBZ
         9RBVsVCYRTTxZUI94meNUIQwkm+zOX+EVYwC+ZC+9ZS6ahIGBPuQkld1OoAXqPxavsTS
         +8d6gVMabDBZ4xLgmFE5+Zukiku62ldb6/sc/M7NLnnRE38jyLF16He1p2dxosiIJqpj
         S2DmDPr1WEG1Bure/2zoWMZIht9mzFVR6c3iXIDnwQ/x7EGw/v0aVhikAe1akeE7N2M1
         phqQ==
X-Gm-Message-State: AGi0PuZK5JjgKilGbvTXby/9+vCFSzgDKS8N/ETS2pzI06HF0346uzKQ
        q8arvewIHkk0VWrVtv9yqHI=
X-Google-Smtp-Source: APiQypJPaZ8Uc9+o772th9A6hegmk/Smv9MAxV0CHKHhrAHjzHfgpQ7V8t6tbvhG9TFZVWtFunr6Vg==
X-Received: by 2002:a1c:5502:: with SMTP id j2mr6297601wmb.71.1587066375308;
        Thu, 16 Apr 2020 12:46:15 -0700 (PDT)
Received: from debian.lan (host-84-13-17-86.opaltelecom.net. [84.13.17.86])
        by smtp.gmail.com with ESMTPSA id v16sm4756092wml.30.2020.04.16.12.46.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Apr 2020 12:46:14 -0700 (PDT)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Paul Wise <pabs3@bonedaddy.net>, stable@vger.kernel.org
Subject: [PATCH] coredump: fix null pointer dereference on coredump
Date:   Thu, 16 Apr 2020 20:46:12 +0100
Message-Id: <20200416194612.21418-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the core_pattern is set to "|" and any process segfaults then we get
a null pointer derefernce while trying to coredump. The call stack shows:
[  108.212680] RIP: 0010:do_coredump+0x628/0x11c0

When the core_pattern has only "|" there is no use of trying the
coredump and we can check that while formating the corename and exit
with an error.

After this change I get:
[   48.453756] format_corename failed
[   48.453758] Aborting core

Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
Reported-by: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Paul Wise <pabs3@bonedaddy.net>
Cc: stable@vger.kernel.org
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/coredump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index f8296a82d01d..408418e6aa13 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -211,6 +211,8 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm,
 			return -ENOMEM;
 		(*argv)[(*argc)++] = 0;
 		++pat_ptr;
+		if (!(*pat_ptr))
+			return -ENOMEM;
 	}
 
 	/* Repeat as long as we have more pattern to process and more output
-- 
2.11.0

