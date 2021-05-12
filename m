Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777F137C641
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbhELPtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235272AbhELPnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:43:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B2C361C8D;
        Wed, 12 May 2021 15:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832952;
        bh=gHumCT2Bq/aO1rrARC0tkzCXKm++3NEnGMitLRGdozs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P03l3EtODaIWW38001qdP1JubEF+9X8yOQPqydYVikHxhamtefgm7RJEMAli4eSQ5
         fLP5ZWV97XG/brHXAnzvcMxY5ti4Ju2hpvlonVNWtydpYjvAY2jvKrrUqrTP6tlLpe
         q/SHO77akHvTSVnf2R20CVsqIkZn6BlJHBIpSDgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/530] powerpc/perf: Fix the threshold event selection for memory events in power10
Date:   Wed, 12 May 2021 16:50:00 +0200
Message-Id: <20210512144835.853543016@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 66d9b7492887d34c711bc05b36c22438acba51b4 ]

Memory events (mem-loads and mem-stores) currently use the threshold
event selection as issue to finish. Power10 supports issue to complete
as part of thresholding which is more appropriate for mem-loads and
mem-stores. Hence fix the event code for memory events to use issue
to complete.

Fixes: a64e697cef23 ("powerpc/perf: power10 Performance Monitoring support")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1614840015-1535-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/power10-events-list.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/perf/power10-events-list.h b/arch/powerpc/perf/power10-events-list.h
index 60c1b8111082..e66487804a59 100644
--- a/arch/powerpc/perf/power10-events-list.h
+++ b/arch/powerpc/perf/power10-events-list.h
@@ -66,5 +66,5 @@ EVENT(PM_RUN_INST_CMPL_ALT,			0x00002);
  *     thresh end (TE)
  */
 
-EVENT(MEM_LOADS,				0x34340401e0);
-EVENT(MEM_STORES,				0x343c0401e0);
+EVENT(MEM_LOADS,				0x35340401e0);
+EVENT(MEM_STORES,				0x353c0401e0);
-- 
2.30.2



