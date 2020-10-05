Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD8D283AFE
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgJEPi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbgJEPak (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A03C20874;
        Mon,  5 Oct 2020 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911839;
        bh=ZyqEYFMRTu+NxCwOkLho6pO1a/Hk+uLuvaL3z0XRiIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssGnPu3FuN2Ja/6Pw2SmdkYFXW3wPvsma3K8Z2i6GN0Mw8Ix1bIQAGz3y64sfrZlm
         8G7Ble3kchVxEeWstSsSfDcrpjeKidUDRJqqaPlnsfvL5TuEX3xWoxhelESGeHtMtP
         e9DTRI2PBl4P7YlH1f4yJRA5dLH9NDpn+yvPaQvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/57] scripts/dtc: only append to HOST_EXTRACFLAGS instead of overwriting
Date:   Mon,  5 Oct 2020 17:26:57 +0200
Message-Id: <20201005142111.974361953@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
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
index b5a5b1c548c9b..c2dac994896b4 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -9,7 +9,7 @@ dtc-objs	:= dtc.o flattree.o fstree.o data.o livetree.o treesource.o \
 dtc-objs	+= dtc-lexer.lex.o dtc-parser.tab.o
 
 # Source files need to get at the userspace version of libfdt_env.h to compile
-HOST_EXTRACFLAGS := -I $(srctree)/$(src)/libfdt
+HOST_EXTRACFLAGS += -I $(srctree)/$(src)/libfdt
 
 ifeq ($(shell pkg-config --exists yaml-0.1 2>/dev/null && echo yes),)
 ifneq ($(CHECK_DTBS),)
-- 
2.25.1



