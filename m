Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D154360DDD
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhDOPGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234884AbhDOPE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:04:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0693761431;
        Thu, 15 Apr 2021 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498739;
        bh=DoMPtUtQn6Ti78BNZWdPJv7gdrykCJx/19nciIWrer0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgMxXUJfH8HyoyPa0zjrsmXcg6WGTlmPjwoWCSmRlHMHvSPxC8IyWDR43UTeAs3m1
         CoyvWF9qk17EM/udSzew68To6HsE2HNRxCjTHq14q8/ZRVzukgsEBQwLMVBKWEjWoX
         BTA2udRe6LiDH3ePmnDO31C8gP+hqmP+j8TOl1mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 08/23] tools/kvm_stat: Add restart delay
Date:   Thu, 15 Apr 2021 16:48:15 +0200
Message-Id: <20210415144413.415964497@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.146131392@linuxfoundation.org>
References: <20210415144413.146131392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



