Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 015904E749
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 13:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfFULoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 07:44:09 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36345 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfFULoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 07:44:09 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so6276475wmm.1;
        Fri, 21 Jun 2019 04:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=671B8ITw4iRBQJ3GVRyh3fkF3c8OsHI/COzEcd1834M=;
        b=eNtMHae59YB07kaBK2IyGYRtNhXpOIn76XcLvsWX8VXoI+RbfGrhSY+RWVkZkPHSSM
         Eu1AiEN2RJGwgDZ4nSocPVdPN1JVYHhwL1Tisste7lSrGNbk1cOinEo3W9C/HidX9eoz
         Nus+QLFisaKhv86/QJ9U8DxYJ5fFa3sMRYZZTMf/jJPMe1pYkcDhGCSLt7MMFuv0T//u
         Ku4hG5r4nLoPEWdvddObDmdgahkN2hrb8wL/5mXyn7jQLoQUZJYmvxr3GQX07+wR0UF9
         y0UiOIesN6VH/z4/nBy7aOHbLH5RrVyqgNu1+nnz/XRuEDRAmz1wPlC76SUbevC5ggCk
         PDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=671B8ITw4iRBQJ3GVRyh3fkF3c8OsHI/COzEcd1834M=;
        b=BoH4l9490oZYVWE+iA54R++WDlPVOGHNaTX3L+F5CA6ibUIRJ2aonAgu+86SO7G9qJ
         3KNpGC98Fi35MYdioyfwQOVmIq1OLPv/l4ODeRRA3TRWwIwe2szOkfeFWbLFBVGNdGyf
         UEEXPR2t6CBnZcAJmx+vjBJly+pXc+5ae4/AkaAbw2Nt/a/gzA3DwRj8Bo4cexJ3ujmW
         2REltMw5P5bNRDvUOsJvifY0FMxDQdOndgKhRmY8YcMNBVS/l2SKe0QOw1fMfjMl3Jm9
         DB2ch9y/Q5vflofVI0FJ9BYdcAg1E31XmVuMT/g13en6zYDdljFgnZ5XzBSK9APxQj0W
         tCfA==
X-Gm-Message-State: APjAAAWO6Ww5g5erxjpnA1Ogtfq2OPT26Pu0bCXm0xL2k7aWlXHm1EfR
        H2VzetWd65QdJqYHcS8R5to=
X-Google-Smtp-Source: APXvYqwMO1kthRI1MdROhaylSw1sgGK/5sYomAtT784ZV+TKYvX7heUFUkZWJRfM37dLdrva1oW1eA==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr4147489wmj.64.1561117446857;
        Fri, 21 Jun 2019 04:44:06 -0700 (PDT)
Received: from alan-laptop.carrier.duckdns.org (host-89-243-246-11.as13285.net. [89.243.246.11])
        by smtp.gmail.com with ESMTPSA id o2sm1698861wrq.56.2019.06.21.04.44.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 04:44:06 -0700 (PDT)
From:   Alan Jenkins <alan.christopher.jenkins@gmail.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alan Jenkins <alan.christopher.jenkins@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] mm: fix setting the high and low watermarks
Date:   Fri, 21 Jun 2019 12:43:25 +0100
Message-Id: <20190621114325.711-1-alan.christopher.jenkins@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When setting the low and high watermarks we use min_wmark_pages(zone).
I guess this is to reduce the line length.  But we forgot that this macro
includes zone->watermark_boost.  We need to reset zone->watermark_boost
first.  Otherwise the watermarks will be set inconsistently.

E.g. this could cause inconsistent values if the watermarks have been
boosted, and then you change a sysctl which triggers
__setup_per_zone_wmarks().

I strongly suspect this explains why I have seen slightly high watermarks.
Suspicious-looking zoneinfo below - notice high-low != low-min.

Node 0, zone   Normal
  pages free     74597
        min      9582
        low      34505
        high     36900

https://unix.stackexchange.com/questions/525674/my-low-and-high-watermarks-seem-higher-than-predicted-by-documentation-sysctl-vm/525687

Signed-off-by: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external
                      fragmentation event occurs")
Cc: stable@vger.kernel.org
---

Tested by compiler :-).

Ideally the commit message would be clear about what happens the
*first* time __setup_per_zone_watermarks() is called.  I guess that
zone->watermark_boost is *usually* zero, or we would have noticed
some wild problems :-).  However I am not familiar with how the zone
structures are allocated & initialized.  Maybe there is a case where
zone->watermark_boost could contain an arbitrary unitialized value
at this point.  Can we rule that out?

 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c02cff1ed56e..db9758cda6f8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7606,9 +7606,9 @@ static void __setup_per_zone_wmarks(void)
 			    mult_frac(zone_managed_pages(zone),
 				      watermark_scale_factor, 10000));
 
+		zone->watermark_boost = 0;
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_HIGH] = min_wmark_pages(zone) + tmp * 2;
-		zone->watermark_boost = 0;
 
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
-- 
2.20.1

