Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5508354445
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbhDEQEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242121AbhDEQEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77BB5613D4;
        Mon,  5 Apr 2021 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638683;
        bh=DoMPtUtQn6Ti78BNZWdPJv7gdrykCJx/19nciIWrer0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzeCSMjMY0f62WnbOtTQtvAZAif1R0E8OQviaSy3heiCHwmqmI919OdPtz6xZ/EMj
         /XS8m/lKsDvYgCsUlazpm+rZSLmKrKeGspJa1At3Kqu4OrcZduoT+25icHFNYCJZ7E
         dXhzgs/JqtheHZ0GiOozcs2kkpQF+thlCDH8FadMivyJ0FUw6nxHJX8zPkxGGiQhSv
         877uSlUez/jHPsfAEvAb6Ju7ykj3scU8hhfAe4SXXKvewSy9qqjjEsOpyyrtD4ROYE
         hfuOrPB57vQWwLIp59DrFtNB1mja2q7CMKvlXp+gWBpC2W6t7TRt9qkf+2prPpB4ke
         yQ/Lc/raI1l+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Raspl <raspl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/22] tools/kvm_stat: Add restart delay
Date:   Mon,  5 Apr 2021 12:04:18 -0400
Message-Id: <20210405160432.268374-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160432.268374-1-sashal@kernel.org>
References: <20210405160432.268374-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

[ Upstream commit 75f94ecbd0dfd2ac4e671f165f5ae864b7301422 ]

If this service is enabled and the system rebooted, Systemd's initial
attempt to start this unit file may fail in case the kvm module is not
loaded. Since we did not specify a delay for the retries, Systemd
restarts with a minimum delay a number of times before giving up and
disabling the service. Which means a subsequent kvm module load will
have kvm running without monitoring.
Adding a delay to fix this.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Message-Id: <20210325122949.1433271-1-raspl@linux.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/kvm/kvm_stat/kvm_stat.service | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/kvm/kvm_stat/kvm_stat.service b/tools/kvm/kvm_stat/kvm_stat.service
index 71aabaffe779..8f13b843d5b4 100644
--- a/tools/kvm/kvm_stat/kvm_stat.service
+++ b/tools/kvm/kvm_stat/kvm_stat.service
@@ -9,6 +9,7 @@ Type=simple
 ExecStart=/usr/bin/kvm_stat -dtcz -s 10 -L /var/log/kvm_stat.csv
 ExecReload=/bin/kill -HUP $MAINPID
 Restart=always
+RestartSec=60s
 SyslogIdentifier=kvm_stat
 SyslogLevel=debug
 
-- 
2.30.2

