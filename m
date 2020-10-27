Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFAC29AD71
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752297AbgJ0Nf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:35:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39052 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbgJ0Nf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 09:35:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id y12so1937141wrp.6;
        Tue, 27 Oct 2020 06:35:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g6+0uI07gwej8vOY9AHu1gUHHmahsVxYAJt5Q+A7Des=;
        b=ZZ3GMgxRwAqYpJfyTKg0M/AL6RIKV+uZH8sZpB3VFZXzQbKaDsh6lbPWEm9H0qXgYP
         99V+0Uqx3P+S+U2zgNzHnC3BR1T6Uw12dUmtHked+gbv9TuBgwqHVUDRrkzkuDOE7EbI
         iOKNpYM1YXPi7I7iC3XGtFFnQxCtxdJo3MqY0f6V9nh4nOiMfoPtUZi16i3RuncGoG6W
         oOZeTSKRWitWdhn3mYcuwwP5rD83Pq9ov9vBDQkQZDce1zxWowrSa/yBh503d2U9W+EI
         JypS3UW6l5EQB4tHYrkVbb8krbsOPPBY9uI3/3UFbSuFn3I4W69OL5ipaGSetRGt95lA
         gGYg==
X-Gm-Message-State: AOAM531CvD54o0vlc1F4PiAsZAK4rtUBefvK6bZ5TVU4k6GUFRE7CkoT
        IsHfVe6kIBJnVPu+kHCmP0J6Lru47g4=
X-Google-Smtp-Source: ABdhPJz/LlrWPEcwYlzMUVrMCj4Wvg+V3Nbj8qBfkW3mSTfRY9vUmxd86f0gtb1MKixU/pzkz+Ybiw==
X-Received: by 2002:adf:a354:: with SMTP id d20mr3140972wrb.29.1603805754703;
        Tue, 27 Oct 2020 06:35:54 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-36-134-112.cust.vodafonedsl.it. [2.36.134.112])
        by smtp.gmail.com with ESMTPSA id x15sm2218175wrr.36.2020.10.27.06.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:35:54 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: [PATCH v2 0/2] fix parsing of reboot= cmdline
Date:   Tue, 27 Oct 2020 14:35:43 +0100
Message-Id: <20201027133545.58625-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.28.0
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

v1->v2:
As Petr suggested, don't force base 10 in simple_strtoul(),
so hex values are accepted as well.

Matteo Croce (2):
  reboot: fix overflow parsing reboot cpu number
  reboot: fix parsing of reboot cpu number

 kernel/reboot.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

-- 
2.28.0

