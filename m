Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47CC37CF17
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbhELRIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236981AbhELQs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:48:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6565561E84;
        Wed, 12 May 2021 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836152;
        bh=9r8ZGwTAYUpbIBMs5UGRDXRJM6e9EczXBc5XA4Rw3mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4up87l3zhNWZTy+1V87CQdy3R+HtnHtUrko6xojBX+qOKgKbwLJa0ceBPlOshtVE
         UprXJ+EiSMZEiaorBNW+oH894pxw004msRzf9J3jfgvZd1j6Xdnx1KW+TeDZSQmpeb
         W3LnJiA5LJGC2HcKapunmj5IZusZw0ZQB052P8Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 630/677] powerpc/perf: Fix the threshold event selection for memory events in power10
Date:   Wed, 12 May 2021 16:51:16 +0200
Message-Id: <20210512144858.300482779@linuxfoundation.org>
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
index e45dafe818ed..93be7197d250 100644
--- a/arch/powerpc/perf/power10-events-list.h
+++ b/arch/powerpc/perf/power10-events-list.h
@@ -75,5 +75,5 @@ EVENT(PM_RUN_INST_CMPL_ALT,			0x00002);
  *     thresh end (TE)
  */
 
-EVENT(MEM_LOADS,				0x34340401e0);
-EVENT(MEM_STORES,				0x343c0401e0);
+EVENT(MEM_LOADS,				0x35340401e0);
+EVENT(MEM_STORES,				0x353c0401e0);
-- 
2.30.2



