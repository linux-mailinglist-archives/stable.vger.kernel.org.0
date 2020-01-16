Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6427B13EE32
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgAPSHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393419AbgAPRjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A021246D5;
        Thu, 16 Jan 2020 17:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196344;
        bh=5KK9hVvP7HtS8Nhi7+wZ7prpIoAH8W+uEaDpuuwJxjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGgR8rjEwWhZNbq+9/CxhhD+hRW89aA1/58j2S7o0qD4Ts8LLnrUnhAn0+SG2Tb9a
         67P/mtEmrQmjAj9NP+p3DNMYpklyQWSwgiIVh2OrRbfp8oULcWXBJYbvausi23F4Ue
         1otD4HC4PNPCsYkCOXEit02KDtl+M01JazjfPD1o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Douglas Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 140/251] kdb: do a sanity check on the cpu in kdb_per_cpu()
Date:   Thu, 16 Jan 2020 12:34:49 -0500
Message-Id: <20200116173641.22137-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b586627e10f57ee3aa8f0cfab0d6f7dc4ae63760 ]

The "whichcpu" comes from argv[3].  The cpu_online() macro looks up the
cpu in a bitmap of online cpus, but if the value is too high then it
could read beyond the end of the bitmap and possibly Oops.

Fixes: 5d5314d6795f ("kdb: core for kgdb back end (1 of 2)")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 5a58421d7e2d..a52a6da8c3d0 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2632,7 +2632,7 @@ static int kdb_per_cpu(int argc, const char **argv)
 		diag = kdbgetularg(argv[3], &whichcpu);
 		if (diag)
 			return diag;
-		if (!cpu_online(whichcpu)) {
+		if (whichcpu >= nr_cpu_ids || !cpu_online(whichcpu)) {
 			kdb_printf("cpu %ld is not online\n", whichcpu);
 			return KDB_BADCPUNUM;
 		}
-- 
2.20.1

