Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5862217AA85
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 17:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgCEQaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 11:30:13 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44179 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgCEQaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 11:30:13 -0500
Received: by mail-ed1-f66.google.com with SMTP id g19so7498770eds.11;
        Thu, 05 Mar 2020 08:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BRXSE0XBzxMDHWIls4cOTPVu0pFheFOHSZA4RJTN0vU=;
        b=MlE6sAB/kJpOoC/kjwwQg5tHpmLrO1QqAsarb+FmuiLnyoWB33YLjPUmg5nexdgFD0
         zuErVK5KVhTE9hafjAGZ/7m8LEdyC8yvGv/F8hUmNwx/rMlI76NSvwhKQcVBZ3S5JeCL
         pJrhBGFqftYh7meBALrixWPBoq48732IWy+lDoplQ9tfYaZJQdqku2TxhZvGNayZgBEe
         +zIGM2JpLVG1Hz0BHHSA9FyqVA6CPapSN6eGUYCwv4DZ5T9FJUi0nzDntEZWlj2Wimsg
         I/kcSy2JkHbevZSyYgBOdCxi+fSUTCw69LcgG8hmubKlUxJes9fr0fcl52H7W2B1Q9FI
         DqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BRXSE0XBzxMDHWIls4cOTPVu0pFheFOHSZA4RJTN0vU=;
        b=U3MtrWpKRI9BCc5JuB+wGO//jhy4hTKY3BLElKXRruS7Q1bS6y+xZaamHY2INEJg/7
         WUuH5qCGayHH2RzMiY9HtF1ofUYcpv507172jh33ETmEsPH9A/xE8LdPTqSXsGx/n+px
         /Vx6geY3cUmNPeGEuimuXrnfA8/oEsrhe0yewV/EWi/QXodYOFgJyfhvtCrTt/o6ES4S
         YQw8VJoz7Wf27i1Jsa4puj2d/PpqT+wHzrzZA11qQ2fjhsoeYmY+crXdSy1adA2lzWJc
         INIZbhVY1tQLsRXrTB2yP6TkHH0ZUhyWggCOgJnUUNO/EqrVdbUiul29PKlNtvQ8G8Gg
         7QKg==
X-Gm-Message-State: ANhLgQ14LEctfMX5T6ecuODNwnElSGQNzxvrRGi1QoUBQkhn0pIGDdA0
        oi5jui4H24AyFLZUnnuu8UQ=
X-Google-Smtp-Source: ADFU+vu3MUA1zppO0rZTreIKd+2o3NPVXyX5uXy3kdFGrQ34BG8nHWYEzaenpXvKwqWAjsk78BrW/Q==
X-Received: by 2002:a05:6402:1b09:: with SMTP id by9mr9499859edb.23.1583425811053;
        Thu, 05 Mar 2020 08:30:11 -0800 (PST)
Received: from jwang-Latitude-5491.pb.local ([2001:1438:4010:2558:d8ec:cf8e:d7de:fb22])
        by smtp.gmail.com with ESMTPSA id h22sm293651edq.28.2020.03.05.08.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 08:30:10 -0800 (PST)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robert Richter <rrichter@marvell.com>,
        Tony Luck <tony.luck@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable-4.14 3/3] EDAC/amd64: Set grain per DIMM
Date:   Thu,  5 Mar 2020 17:30:07 +0100
Message-Id: <20200305163007.25659-4-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305163007.25659-1-jinpuwang@gmail.com>
References: <20200305163007.25659-1-jinpuwang@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 466503d6b1b33be46ab87c6090f0ade6c6011cbc ]

The following commit introduced a warning on error reports without a
non-zero grain value.

  3724ace582d9 ("EDAC/mc: Fix grain_bits calculation")

The amd64_edac_mod module does not provide a value, so the warning will
be given on the first reported memory error.

Set the grain per DIMM to cacheline size (64 bytes). This is the current
recommendation.

Fixes: 3724ace582d9 ("EDAC/mc: Fix grain_bits calculation")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Robert Richter <rrichter@marvell.com>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20191022203448.13962-7-Yazen.Ghannam@amd.com
[jwang: backport to 4.14 for fix warning during memory error. ]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/edac/amd64_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 40fb0e7ff8fd..b36abd253786 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2863,6 +2863,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 			dimm = csrow->channels[j]->dimm;
 			dimm->mtype = pvt->dram_type;
 			dimm->edac_mode = edac_mode;
+			dimm->grain = 64;
 		}
 	}
 
-- 
2.17.1

