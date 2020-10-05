Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDFF283A9C
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgJEPft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbgJEPdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93B2A208C7;
        Mon,  5 Oct 2020 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912025;
        bh=jKqINKOnh2VFQ2GLMWE5bNupakZfRmWizmycKI9kb5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5A6V/xvj9+n8W+db/KxRd7QAyLkwIYm/KqjN4MQW8p1gpFPkdsopoR28KAoetuWM
         TM9HRYbr2QIGg1blChSiBLjLkhhTLPr1zq4HzCtchzNE+ouKnHKzdL7g2SgX3k8+BE
         1/5xtkG7emKTNOxytxUscSqsMVnE59vzw3JHfAIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 70/85] scripts/dtc: only append to HOST_EXTRACFLAGS instead of overwriting
Date:   Mon,  5 Oct 2020 17:27:06 +0200
Message-Id: <20201005142118.099357462@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit efe84d408bf41975db8506d3a1cc02e794e2309c ]

When building with

	$ HOST_EXTRACFLAGS=-g make

the expectation is that host tools are built with debug informations.
This however doesn't happen if the Makefile assigns a new value to the
HOST_EXTRACFLAGS instead of appending to it. So use += instead of := for
the first assignment.

Fixes: e3fd9b5384f3 ("scripts/dtc: consolidate include path options in Makefile")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/dtc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
index 0b44917f981c7..d4129e0275e4a 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -10,7 +10,7 @@ dtc-objs	:= dtc.o flattree.o fstree.o data.o livetree.o treesource.o \
 dtc-objs	+= dtc-lexer.lex.o dtc-parser.tab.o
 
 # Source files need to get at the userspace version of libfdt_env.h to compile
-HOST_EXTRACFLAGS := -I $(srctree)/$(src)/libfdt
+HOST_EXTRACFLAGS += -I $(srctree)/$(src)/libfdt
 
 ifeq ($(shell pkg-config --exists yaml-0.1 2>/dev/null && echo yes),)
 ifneq ($(CHECK_DT_BINDING)$(CHECK_DTBS),)
-- 
2.25.1



