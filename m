Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAFE11B761
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbfLKQHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730713AbfLKPMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 075382467F;
        Wed, 11 Dec 2019 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077150;
        bh=FsGRS6i1JQA/Fs5w9IlywZtU1wgcApDmYXC3E95CFLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fL88RWqaLkWJ+vbzYl2yvCOP7tJXpUh0zmEms1zT0lefMNEJYWnXMLWj3XH35oR1k
         32AsMzzGtcjynUj4cVVnBf39ON380OsLMwaUa91sKzqY35snDWrDtNayrmcSNEgxP4
         +YYVnY4MBzHgmnqf8630pZ0LlDGgDhUxygXnWC1o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Modilaynen <pavel.modilaynen@axis.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 037/134] dtc: Use pkg-config to locate libyaml
Date:   Wed, 11 Dec 2019 10:10:13 -0500
Message-Id: <20191211151150.19073-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Modilaynen <pavel.modilaynen@axis.com>

[ Upstream commit 067c650c456e758f933aaf87a202f841d34be269 ]

Using Makefile's wildcard with absolute path to detect
the presence of libyaml results in false-positive
detection when cross-compiling e.g. in yocto environment.
The latter results in build error:
| scripts/dtc/yamltree.o: In function `yaml_propval_int':
| yamltree.c: undefined reference to `yaml_sequence_start_event_initialize'
| yamltree.c: undefined reference to `yaml_emitter_emit'
| yamltree.c: undefined reference to `yaml_scalar_event_initialize'
...
Use pkg-config to locate libyaml to address this scenario.

Signed-off-by: Pavel Modilaynen <pavel.modilaynen@axis.com>
[robh: silence stderr]
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/dtc/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
index 82160808765c3..b5a5b1c548c9b 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -11,7 +11,7 @@ dtc-objs	+= dtc-lexer.lex.o dtc-parser.tab.o
 # Source files need to get at the userspace version of libfdt_env.h to compile
 HOST_EXTRACFLAGS := -I $(srctree)/$(src)/libfdt
 
-ifeq ($(wildcard /usr/include/yaml.h),)
+ifeq ($(shell pkg-config --exists yaml-0.1 2>/dev/null && echo yes),)
 ifneq ($(CHECK_DTBS),)
 $(error dtc needs libyaml for DT schema validation support. \
 	Install the necessary libyaml development package.)
@@ -19,7 +19,7 @@ endif
 HOST_EXTRACFLAGS += -DNO_YAML
 else
 dtc-objs	+= yamltree.o
-HOSTLDLIBS_dtc	:= -lyaml
+HOSTLDLIBS_dtc	:= $(shell pkg-config yaml-0.1 --libs)
 endif
 
 # Generated files need one more search path to include headers in source tree
-- 
2.20.1

