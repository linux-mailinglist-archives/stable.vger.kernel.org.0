Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A20137C98F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbhELQT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239648AbhELQKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:10:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2233D61D3A;
        Wed, 12 May 2021 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834023;
        bh=DrqMZi4nokZn0/DxIwSbci06QRoDDiDNmpuUd/ZCHrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNtbBB5P/xfI1jLQ6LSv8NVK2RACa8YgC5N19R6zqkLy6e6nxYPr1YaQ3PanqGAK4
         gWuIlwxoLRAGOe0OTw1VN4+lG7jfo4RLuJypT739uG8N3DkrOQum0v40X87TC0+RO0
         ut/PsiGVgfr5m7de91jy8LK+a+rDYXpJQweon3Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 380/601] x86/events/amd/iommu: Fix sysfs type mismatch
Date:   Wed, 12 May 2021 16:47:37 +0200
Message-Id: <20210512144840.306811429@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit de5bc7b425d4c27ae5faa00ea7eb6b9780b9a355 ]

dev_attr_show() calls _iommu_event_show() via an indirect call but
_iommu_event_show()'s type does not currently match the type of the
show() member in 'struct device_attribute', resulting in a Control Flow
Integrity violation.

$ cat /sys/devices/amd_iommu_1/events/mem_dte_hit
csource=0x0a

$ dmesg | grep "CFI failure"
[ 3526.735140] CFI failure (target: _iommu_event_show...):

Change _iommu_event_show() and 'struct amd_iommu_event_desc' to
'struct device_attribute' so that there is no more CFI violation.

Fixes: 7be6296fdd75 ("perf/x86/amd: AMD IOMMU Performance Counter PERF uncore PMU implementation")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210415001112.3024673-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/amd/iommu.c b/arch/x86/events/amd/iommu.c
index be50ef8572cc..6a98a7651621 100644
--- a/arch/x86/events/amd/iommu.c
+++ b/arch/x86/events/amd/iommu.c
@@ -81,12 +81,12 @@ static struct attribute_group amd_iommu_events_group = {
 };
 
 struct amd_iommu_event_desc {
-	struct kobj_attribute attr;
+	struct device_attribute attr;
 	const char *event;
 };
 
-static ssize_t _iommu_event_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf)
+static ssize_t _iommu_event_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct amd_iommu_event_desc *event =
 		container_of(attr, struct amd_iommu_event_desc, attr);
-- 
2.30.2



