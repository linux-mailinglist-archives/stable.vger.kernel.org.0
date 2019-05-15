Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1066E1F388
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfEOLEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbfEOLEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A042C20881;
        Wed, 15 May 2019 11:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918245;
        bh=w5hkg+vbRu2d+V+WxG2zm1dOgYprY6sw7r2tBXuaWcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVZdKUkcjPwPPHrmX7kNZszj9t4LJN7lKqDDBguK/QKF59dxhlVKK+Y9wIWGYWlg8
         YWSiQTnmhmnnuOodwwVln5Omw61QpOUv5OG1UnOr2pebFCv07lVCFCWwU/KoGsfb2d
         tJL+X5Z14u/vePeaOsYmdWH6z7opR93CQushTVG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Craciun <diana.craciun@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 059/266] powerpc/fsl: Fix spectre_v2 mitigations reporting
Date:   Wed, 15 May 2019 12:52:46 +0200
Message-Id: <20190515090724.435839040@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

commit 7d8bad99ba5a22892f0cad6881289fdc3875a930 upstream.

Currently for CONFIG_PPC_FSL_BOOK3E the spectre_v2 file is incorrect:

  $ cat /sys/devices/system/cpu/vulnerabilities/spectre_v2
  "Mitigation: Software count cache flush"

Which is wrong. Fix it to report vulnerable for now.

Fixes: ee13cb249fab ("powerpc/64s: Add support for software count cache flush")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/security.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -23,7 +23,7 @@ enum count_cache_flush_type {
 	COUNT_CACHE_FLUSH_SW	= 0x2,
 	COUNT_CACHE_FLUSH_HW	= 0x4,
 };
-static enum count_cache_flush_type count_cache_flush_type;
+static enum count_cache_flush_type count_cache_flush_type = COUNT_CACHE_FLUSH_NONE;
 
 bool barrier_nospec_enabled;
 static bool no_nospec;


