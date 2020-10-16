Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6994F290B1B
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 20:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390785AbgJPSJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 14:09:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39397 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390770AbgJPSJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 14:09:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id d3so3879030wma.4;
        Fri, 16 Oct 2020 11:09:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pO0jw4bUW44xwUriD8J9vbmSKEotBZ3xMEfz+Pxr2R0=;
        b=QXdv2MFSgVAIZ77Ex7CEywu65M+M7zFncF9WPZ98ea/M0LyrQcJBYAL9yPKeoyI7Tn
         +yMOjOjMh++SAatEBJReO6k2NV2hhBOyte8S9+Sx/OxV9wXiAB9ws6quUPlnSo7mafJI
         FUJ8xY3kzCYkM322C+XRjus+Rkk3v/fGyqIm224BEQ4ijmBLsrwDl0ZMSlC/Bq4Xyizb
         +REK7pqNShxdANV505JQPteO0R/niZovCi8AD5GFE4d0kk1ZEPKa0VIdaIc+AYlkmC4+
         RTSIDpPZl7TC5lIX7dRplKDdVlDx5HKYFumB5YDkQOGhkbZMvzbbOshZYOC9DrY0CMd4
         6+qw==
X-Gm-Message-State: AOAM533cudKq8dVDmZXY8iZZIFlbfZYwnmUcIuOM+bMZsK/nyt6cvalh
        AbWlnrmZY5vg8XVomNb/GiCFAgjimyi7YbBx
X-Google-Smtp-Source: ABdhPJx29M2wTIJKBHQqVqWl4YJ2nL9Q5MT8VjwCzweTlH/m2dpg2YKFNDYb3pAU/2yTt0NcOw720w==
X-Received: by 2002:a7b:c92c:: with SMTP id h12mr5284146wml.134.1602871750470;
        Fri, 16 Oct 2020 11:09:10 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-36-134-112.cust.vodafonedsl.it. [2.36.134.112])
        by smtp.gmail.com with ESMTPSA id x1sm4369260wrl.41.2020.10.16.11.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 11:09:09 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: [PATCH 0/2] fix parsing of reboot= cmdline
Date:   Fri, 16 Oct 2020 20:09:05 +0200
Message-Id: <20201016180907.171957-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

The parsing of the reboot= cmdline has two major errors:
- a missing bound check can crash the system on reboot
- parsing of the cpu number only works if specified last

Fix both, along with a small code refactor.

Matteo Croce (2):
  reboot: fix overflow parsing reboot cpu number
  reboot: fix parsing of reboot cpu number

 kernel/reboot.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

-- 
2.26.2

