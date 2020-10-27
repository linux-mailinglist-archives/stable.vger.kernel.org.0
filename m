Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9654729ADFD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440529AbgJ0NxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:53:24 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36115 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437930AbgJ0NxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 09:53:24 -0400
Received: by mail-lj1-f194.google.com with SMTP id x6so1866539ljd.3
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 06:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=somia-fi.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bGEXDvKrz7wvx3aURXuB9RIrP+1YMA1eOTNZg0j98jA=;
        b=0vHS6UWVXLNR4yroHiiCE+PapfW/mmxxA6UqEeRfyKO9w6blnoRNrOoIOaMzyixzOg
         oRwgaDnD5rARfehV5bPkWZ8MEQMFAG57EhGt6I7St3EgNgAvVZBJFVM2Nw39fDTK9TIx
         wI+kl3n3MuNape1tTrC0bhaUJ7oo2FSbaMHltMN7QRXgE5JXGYDQjJBkBhGu0BstETez
         7fkil0F5hWy2ruv1l+soGV6mD8DWH+Fb9ac+HlUorUvS3JFXtCjq+ySK4/lXvXlf/oQ8
         XBzb3FATU7+xZom7eHz4kFH9yuBMIHcIQ4Ygmv6pdXAU1+Ae/5SKyJXsgSeYy3lCxURi
         U/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bGEXDvKrz7wvx3aURXuB9RIrP+1YMA1eOTNZg0j98jA=;
        b=GR5H8cBk6Rbx/133LCI39JaL2VPSLabKigWPuN6TPGtA5jx5x5PrhI8NNGFCugm1R4
         0pw/7H6pZShTvIuk8q07AfZozSNARya0HaQ7y0ATS1PAay+6Y2slMxFb/DUomAibJIeW
         FJym6ANJKrofpi3e6sCOhP3rpjhJF65UFuIvOo1YOzgfogSL8N5sn0UX7rO5PhlxhWcN
         1uY58o8pjCeRAvNVkmAWwXXNiStxUA8QI+Qum4Iz9nNU6/He0KQs+aEkmkmvm6CRBArV
         lR7QBJvYLJr2EW7Z54D7KaSymsdp5JA6Dhcx1ITwE3bvbdHgpdayTd1G6v7zLzn8qO1F
         88Sg==
X-Gm-Message-State: AOAM532Pr/sK/R33C8kompP1Cr1Tg6HFLHkYRElPPAFcElpPMIdJyMld
        x5AM07u42g+/icd68fW+dT5k6w==
X-Google-Smtp-Source: ABdhPJwptQlM9ECn8k5PdbN79y6w/b0W0H+VwHmn/0A6bcB5FOwCrxnCQ1+Zdpv+Y+6zTLhxkmTzXA==
X-Received: by 2002:a2e:914d:: with SMTP id q13mr1193411ljg.299.1603806800912;
        Tue, 27 Oct 2020 06:53:20 -0700 (PDT)
Received: from localhost.localdomain (cable-hki-50dc37-152.dhcp.inet.fi. [80.220.55.152])
        by smtp.gmail.com with ESMTPSA id p1sm189835ljn.61.2020.10.27.06.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:53:20 -0700 (PDT)
From:   Hassan Shahbazi <hassan.shahbazi@somia.fi>
X-Google-Original-From: Hassan Shahbazi <hassan@ninchat.com>
To:     h-shahbazi@hotmail.com
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] cachefiles: Handle readpage error correctly
Date:   Tue, 27 Oct 2020 06:53:16 -0700
Message-Id: <20201027135316.56137-1-hassan@ninchat.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

If ->readpage returns an error, it has already unlocked the page.

Fixes: 5e929b33c393 ("CacheFiles: Handle truncate unlocking the page we're reading")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/cachefiles/rdwr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 3080cda9e824..8bda092e60c5 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -121,7 +121,7 @@ static int cachefiles_read_reissue(struct cachefiles_object *object,
 		_debug("reissue read");
 		ret = bmapping->a_ops->readpage(NULL, backpage);
 		if (ret < 0)
-			goto unlock_discard;
+			goto discard;
 	}
 
 	/* but the page may have been read before the monitor was installed, so
@@ -138,6 +138,7 @@ static int cachefiles_read_reissue(struct cachefiles_object *object,
 
 unlock_discard:
 	unlock_page(backpage);
+discard:
 	spin_lock_irq(&object->work_lock);
 	list_del(&monitor->op_link);
 	spin_unlock_irq(&object->work_lock);
-- 
2.25.1

