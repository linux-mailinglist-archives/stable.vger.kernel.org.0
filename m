Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4C437CDE7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343713AbhELQ7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243822AbhELQmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF20061993;
        Wed, 12 May 2021 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835647;
        bh=8jYJUo+MJWKNPzGWeVdRxkFpv2loBomQp5NniyhTeX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKOot2IegiuyE1g6FjtJjJSXM1a+QTkBvBc4xXmpzQA/H/Kt7oi/Nm2pvdruuAzqf
         H2QO0IYfbASZxzOMAN7vL5QbuLmBo535zTVzS9unv44mlMhJ7tEAVQOImd4bwVPssj
         cJFR4wlkqaFtdFJPt7YVuxR0AdH3eeRxxty3kQZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 429/677] perf/amd/uncore: Fix sysfs type mismatch
Date:   Wed, 12 May 2021 16:47:55 +0200
Message-Id: <20210512144851.594871983@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 5deac80d4571dffb51f452f0027979d72259a1b9 ]

dev_attr_show() calls the __uncore_*_show() functions via an indirect
call but their type does not currently match the type of the show()
member in 'struct device_attribute', resulting in a Control Flow
Integrity violation.

$ cat /sys/devices/amd_l3/format/umask
config:8-15

$ dmesg | grep "CFI failure"
[ 1258.174653] CFI failure (target: __uncore_umask_show...):

Update the type in the DEFINE_UNCORE_FORMAT_ATTR macro to match
'struct device_attribute' so that there is no more CFI violation.

Fixes: 06f2c24584f3 ("perf/amd/uncore: Prepare to scale for more attributes that vary per family")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210415001112.3024673-2-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 7f014d450bc2..582c0ffb5e98 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -275,14 +275,14 @@ static struct attribute_group amd_uncore_attr_group = {
 };
 
 #define DEFINE_UNCORE_FORMAT_ATTR(_var, _name, _format)			\
-static ssize_t __uncore_##_var##_show(struct kobject *kobj,		\
-				struct kobj_attribute *attr,		\
+static ssize_t __uncore_##_var##_show(struct device *dev,		\
+				struct device_attribute *attr,		\
 				char *page)				\
 {									\
 	BUILD_BUG_ON(sizeof(_format) >= PAGE_SIZE);			\
 	return sprintf(page, _format "\n");				\
 }									\
-static struct kobj_attribute format_attr_##_var =			\
+static struct device_attribute format_attr_##_var =			\
 	__ATTR(_name, 0444, __uncore_##_var##_show, NULL)
 
 DEFINE_UNCORE_FORMAT_ATTR(event12,	event,		"config:0-7,32-35");
-- 
2.30.2



