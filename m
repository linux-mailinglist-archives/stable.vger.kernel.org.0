Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF994521D4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245593AbhKPBG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245374AbhKOTUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1FE363469;
        Mon, 15 Nov 2021 18:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001211;
        bh=DuuZNpNRLNMo72yR3ajc61kNnOCFi0ZnzQLrAZOjwe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOWv9dD2F4p8sPRXC6F8kmHXm8fXGCdCp4Sl5943XZ+Xd4QzmDf/z+pYmuxOWCQ7m
         qhOuOcgei6OH5cCuKYnENJbly6ZpiBEEu9foRIDKEn6BNYK6Jd+mLt4uVe3zFqfpKq
         4OTZkNYJg8NOClgmphOKJ19sjTU4kR/7zuo4TMTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 104/917] perf/x86/intel/uncore: Fix Intel ICX IIO event constraints
Date:   Mon, 15 Nov 2021 17:53:19 +0100
Message-Id: <20211115165432.281456895@linuxfoundation.org>
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

commit f42e8a603c88f72bf047a710b9fc1d3579f31e71 upstream.

According to the latest uncore document, both NUM_OUTSTANDING_REQ_OF_CPU
(0x88) event and COMP_BUF_OCCUPANCY(0xd5) event also have constraints. Add
them into the event constraints table.

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1629991963-102621-4-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5076,8 +5076,10 @@ static struct event_constraint icx_uncor
 	UNCORE_EVENT_CONSTRAINT(0x02, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x03, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x83, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x88, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0xc0, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0xc5, 0xc),
+	UNCORE_EVENT_CONSTRAINT(0xd5, 0xc),
 	EVENT_CONSTRAINT_END
 };
 


