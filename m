Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DA245138C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348401AbhKOTwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:52:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343633AbhKOTVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C29C635C0;
        Mon, 15 Nov 2021 18:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001802;
        bh=1rgxF6xqu1vqfOrv0PQJNO6XrVYAvsZh301CTdXXWu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mz3cpXmDjO+kcgpR36DklGOlf7y+2iKjo91DMeQLVCJev6Ua2sfSqrj2FgpqgXMvv
         fJQLubAIAfeyRiEQyJT23Mv0lB3BEt7D32UEpEqzR2d+Tyf3o4EHVGK6wB+Jhoykh5
         CfJTm4GsB0ifvzZugpTgcLYbMiFs5vWSOxVThuXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 326/917] perf/x86/intel/uncore: Fix Intel SPR M3UPI event constraints
Date:   Mon, 15 Nov 2021 17:57:01 +0100
Message-Id: <20211115165439.801298147@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 4034fb207e302cc0b1f304084d379640c1fb1436 ]

SPR M3UPI have the exact same event constraints as ICX, so add the
constraints.

Fixes: 2a8e51eae7c8 ("perf/x86/intel/uncore: Add Sapphire Rapids server M3UPI support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/1629991963-102621-8-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index cd53057fd52de..eb2c6cea9d0d5 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5776,6 +5776,7 @@ static struct intel_uncore_type spr_uncore_upi = {
 static struct intel_uncore_type spr_uncore_m3upi = {
 	SPR_UNCORE_PCI_COMMON_FORMAT(),
 	.name			= "m3upi",
+	.constraints		= icx_uncore_m3upi_constraints,
 };
 
 static struct intel_uncore_type spr_uncore_mdf = {
-- 
2.33.0



