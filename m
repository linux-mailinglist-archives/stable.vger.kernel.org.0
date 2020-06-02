Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36051EC5F9
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 01:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgFBX5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 19:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgFBX5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 19:57:46 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EACC08C5C0;
        Tue,  2 Jun 2020 16:57:46 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x207so298448pfc.5;
        Tue, 02 Jun 2020 16:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LhRRdC8w+lAb0OncPPcS/QlJQRfxazO8sGm5lyED8hA=;
        b=OX+NgxMFH6HKye9aRqJ+3IK3xmOQDZuLYWfZ0rlo0pL/zSX9CECd/jP2r1qBGQCL+C
         bX8jR7OP4+F4OutWf/eHB7w3OBIsOmeVcpVkMAUF4xKx0DHDx8jr1xE4yTxJyqs6Sa8e
         ttvKQbzw66Uq1f92vRaymJRtK8Z+trVPiPbRCsvrUyvIgb56bMaIoqVmOE2OBtJb7iqa
         qpzjgBtJ+KFXNaCdQgMoq2292STnrtRbwTqt1kBRx8cq1N8XtACr8t+fbSUJcb0hutKl
         x5YZ47S7HMxhEoJmUiakT4wmHnZUvMuFxqvSGXFNL97Watb/ZvwKAUYHQogj5wf12+yi
         EtBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LhRRdC8w+lAb0OncPPcS/QlJQRfxazO8sGm5lyED8hA=;
        b=cCMgIC7hrW+2eb986gzYfJ4SgTN9lW2At+yzxfdzghaK4UiLi/gJo1iUrt2TdbEL2K
         N0mvt254dcvErARJccLJ2hslxw/cEaJleHs4TTWZozKYDfKrKl+IOoHMDr9T0Y0IezPu
         8BF0wQCjLTwuDkYBUaVM+K4Amf5YnbtcnJU1ODnPfouSJx5+xG+msGr5UGTlrcHMfBH7
         lrdLz6ROWcEJcHO2sOH9IVB63tkGKI5bErE4VToR3ElaG6WQ0+2C7cAqHsMeWHu1/15X
         inFt/Sb736DmSPOddH4TIbhQ9ns1BhNTaAlsF75OKg8HKC8tM1pSFyLXDZg3Cba5WqVA
         xGgw==
X-Gm-Message-State: AOAM5332+vCjxIRM0Kol7YWMpb5pOjLS5vJj0fUhJ3ww1vNCboXLKyCg
        UzCqMP31zD23XYMtmy1z6bvdY3lK
X-Google-Smtp-Source: ABdhPJxqg4L7MZn6XvklSG2hY4H1xfxiw+5gCrmvl4JKcQd8v5YDGrrkWiHabJbEgaOcqtAvMtx0AQ==
X-Received: by 2002:a63:4c0b:: with SMTP id z11mr26828518pga.348.1591142265263;
        Tue, 02 Jun 2020 16:57:45 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q28sm210308pfg.180.2020.06.02.16.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 16:57:44 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, zhuguangqing <zhuguangqing@xiaomi.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org (open list:POWER MANAGEMENT CORE)
Subject: [PATCH stable 5.4] PM: wakeup: Show statistics for deleted wakeup sources again
Date:   Tue,  2 Jun 2020 16:57:39 -0700
Message-Id: <20200602235740.17574-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhuguangqing <zhuguangqing@xiaomi.com>

commit e976eb4b91e906f20ec25b20c152d53c472fc3fd upstream

After commit 00ee22c28915 (PM / wakeup: Use seq_open() to show wakeup
stats), print_wakeup_source_stats(m, &deleted_ws) is not called from
wakeup_sources_stats_seq_show() any more.

Because deleted_ws is one of the wakeup sources, it should be shown
too, so add it to the end of all other wakeup sources.

Signed-off-by: zhuguangqing <zhuguangqing@xiaomi.com>
[ rjw: Subject & changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/base/power/wakeup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 0bd9b291bb29..92f0960e9014 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -1073,6 +1073,9 @@ static void *wakeup_sources_stats_seq_next(struct seq_file *m,
 		break;
 	}
 
+	if (!next_ws)
+		print_wakeup_source_stats(m, &deleted_ws);
+
 	return next_ws;
 }
 
-- 
2.17.1

