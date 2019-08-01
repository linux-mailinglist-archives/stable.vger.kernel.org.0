Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB8D7D745
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbfHAIUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34942 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfHAIUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so33624259pfn.2
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PM+p9F/paBphnvI0O8YGjV0kMD9bw/jop01RC1tBzqU=;
        b=o0bXhyKqYt8kp2xyqrJN+d5+L6zWOZoysvGTEc4rppHnRpkoPu+T4rnS3m4Jm+aRvI
         sQXJ7oKpn5ETzHEMDgshVmw84/LTRr+AG+d5lPhYx3vl/8kjEcoUyTb+f9Z/tE7ck1xs
         7gTkMJKkIt5Gx64KSQCHK+McwRAZN35KWlv8Vp1mb2L75q5NBI1Dan3JB+63h+6B54iV
         4ZSBYc8+5DRo4yXMnBg4TH9/kpVbi9ZyAJwa3DEeIQ25dhha1DKlODyU2IetZUpvOG+n
         DfzIRtDFj4vaEK47flZLyQXsqnbGm9K47CBqs2fPmZj8wswO1/GL3Dn4eFaSjhCw6PAR
         y49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PM+p9F/paBphnvI0O8YGjV0kMD9bw/jop01RC1tBzqU=;
        b=aUh/yDn7pWEJrVWC1n/2+o1F2wJE6NCbMZJZq0Nbabuqbuq+M9SBoy8O5/vkOorujE
         tOIizxiZ8J3omQ0bswuBPyUrf/DLbBFWwQRebNEZre68mFJUUBmltI1T6qkyLfQwIej8
         fixMf+1GvXKwV50W5OJmb0qgypLEAaTktbPEHKczZMFFEyJDpg83tQsZYvqaMLX5eOZ5
         tdeLgidwnVNfZM3GRUlK+2+pO6O+zCoUM6XuYUUblkk92/t8eQemRABWhW7eSjeCwA9y
         fzTKoei4VCfuGykQ8d6krPMI+ZU5mAc255DJJENfHnICZuXpjsGGjOzW67DgvOqlTZWj
         ZN2Q==
X-Gm-Message-State: APjAAAX/bmHLuA1fHw2NFyzvv9HalRPZn0L3TY6CViibzJTqoh6pQFWy
        G0V2shookxVe4wRwDWC9iTPlIwj2qRI=
X-Google-Smtp-Source: APXvYqz3GWx2N/m/nhcWkCouY4H1qYVElKKIkdNdyN42eDSqTyXd8YO3BZzcYLEcjj5aC3TXCQvy/A==
X-Received: by 2002:a62:7552:: with SMTP id q79mr52190761pfc.71.1564647652996;
        Thu, 01 Aug 2019 01:20:52 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id o14sm4069908pjp.29.2019.08.01.01.20.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:52 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 30/47] ARM: 8792/1: oabi-compat: copy oabi events using __copy_to_user()
Date:   Thu,  1 Aug 2019 13:46:14 +0530
Message-Id: <ea31022b55593a34417b2045fef8bf474fc80e16.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit 319508902600c2688e057750148487996396e9ca upstream.

Copy events to user using __copy_to_user() rather than copy members of
individually with __put_user_error().
This has the benefit of disabling/enabling PAN once per event intead of
once per event member.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kernel/sys_oabi-compat.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 640748e27035..d844c5c9364b 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -276,6 +276,7 @@ asmlinkage long sys_oabi_epoll_wait(int epfd,
 				    int maxevents, int timeout)
 {
 	struct epoll_event *kbuf;
+	struct oabi_epoll_event e;
 	mm_segment_t fs;
 	long ret, err, i;
 
@@ -294,8 +295,11 @@ asmlinkage long sys_oabi_epoll_wait(int epfd,
 	set_fs(fs);
 	err = 0;
 	for (i = 0; i < ret; i++) {
-		__put_user_error(kbuf[i].events, &events->events, err);
-		__put_user_error(kbuf[i].data,   &events->data,   err);
+		e.events = kbuf[i].events;
+		e.data = kbuf[i].data;
+		err = __copy_to_user(events, &e, sizeof(e));
+		if (err)
+			break;
 		events++;
 	}
 	kfree(kbuf);
-- 
2.21.0.rc0.269.g1a574e7a288b

