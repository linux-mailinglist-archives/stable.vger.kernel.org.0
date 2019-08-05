Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B054581BC0
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbfHENFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbfHENFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:05:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4230F206C1;
        Mon,  5 Aug 2019 13:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010348;
        bh=Vc4MbkvPCY6ix1pL5p3SF2Nx1KQb2lWKpvH9nCpevqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVDQJxK0lKgdHLowgtNa3V9grH7Kdt4H4IYjlieJP6g+cF+k/NHgFKGWUqOQeVI+9
         c5uMbc42zGPdo1nNFDEVoZaosZSMqGaHKTNmbumqJLOhokj1aEWb5BfkGRR27kXIiZ
         Jfz3a0VWNoSAwsiHTFk9H32EU6fZyMy7o4nvtfls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.9 32/42] drivers/perf: arm_pmu: Fix failure path in PM notifier
Date:   Mon,  5 Aug 2019 15:02:58 +0200
Message-Id: <20190805124928.764838956@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124924.788666484@linuxfoundation.org>
References: <20190805124924.788666484@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 0d7fd70f26039bd4b33444ca47f0e69ce3ae0354 upstream.

Handling of the CPU_PM_ENTER_FAILED transition in the Arm PMU PM
notifier code incorrectly skips restoration of the counters. Fix the
logic so that CPU_PM_ENTER_FAILED follows the same path as CPU_PM_EXIT.

Cc: <stable@vger.kernel.org>
Fixes: da4e4f18afe0f372 ("drivers/perf: arm_pmu: implement CPU_PM notifier")
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/perf/arm_pmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -804,8 +804,8 @@ static int cpu_pm_pmu_notify(struct noti
 		cpu_pm_pmu_setup(armpmu, cmd);
 		break;
 	case CPU_PM_EXIT:
-		cpu_pm_pmu_setup(armpmu, cmd);
 	case CPU_PM_ENTER_FAILED:
+		cpu_pm_pmu_setup(armpmu, cmd);
 		armpmu->start(armpmu);
 		break;
 	default:


