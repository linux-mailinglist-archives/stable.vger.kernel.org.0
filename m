Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E362266FC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733219AbgGTQHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732979AbgGTQHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62FD722CB1;
        Mon, 20 Jul 2020 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261273;
        bh=3oPGSMJ+CCoMWNyzcSZvQciZmoZMmXKBLO7zBC0880Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Fy05nynvX59/23A9xIgaqUWh8Yq0NG5AyJcJDhqqztRHluhlook0qS9MGOc2FRBD
         AcODWRtXeZgWnas2nQSrSHvpvzNjHi0DEaPMidZ3IWX5qJUKx7wCWZExyKB2iT/Lgy
         djw5n2b04qF1h8tCzp5+cWgPLb3Pi8RA1/29u3ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 057/244] arm64: Add KRYO4XX silver CPU cores to erratum list 1530923 and 1024718
Date:   Mon, 20 Jul 2020 17:35:28 +0200
Message-Id: <20200720152828.568239183@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit 9b23d95c539ebc5d6d6b5d6f20d2d7922384e76e ]

KRYO4XX silver/LITTLE CPU cores with revision r1p0 are affected by
erratum 1530923 and 1024718, so add them to the respective list.
The variant and revision bits are implementation defined and are
different from the their Cortex CPU counterparts on which they are
based on, i.e., r1p0 is equivalent to rdpe.

Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Link: https://lore.kernel.org/r/7013e8a3f857ca7e82863cc9e34a614293d7f80c.1593539394.git.saiprakash.ranjan@codeaurora.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst | 4 ++++
 arch/arm64/kernel/cpu_errata.c         | 2 ++
 arch/arm64/kernel/cpufeature.c         | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 6902feba6b412..7dc8f8ac69eea 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -151,6 +151,10 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo4xx Gold    | N/A             | ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
+| Qualcomm Tech. | Kryo4xx Silver  | N/A             | ARM64_ERRATUM_1530923       |
++----------------+-----------------+-----------------+-----------------------------+
+| Qualcomm Tech. | Kryo4xx Silver  | N/A             | ARM64_ERRATUM_1024718       |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | A64FX           | E#010001        | FUJITSU_ERRATUM_010001      |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index e0f8474979b19..dbf266212808e 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -765,6 +765,8 @@ static const struct midr_range erratum_speculative_at_vhe_list[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1530923
 	/* Cortex A55 r0p0 to r2p0 */
 	MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 2, 0),
+	/* Kryo4xx Silver (rdpe => r1p0) */
+	MIDR_REV(MIDR_QCOM_KRYO_4XX_SILVER, 0xd, 0xe),
 #endif
 	{},
 };
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b0fb1d5bf2235..cadc9d9a7477b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1177,6 +1177,8 @@ static bool cpu_has_broken_dbm(void)
 	static const struct midr_range cpus[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1024718
 		MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 1, 0),  // A55 r0p0 -r1p0
+		/* Kryo4xx Silver (rdpe => r1p0) */
+		MIDR_REV(MIDR_QCOM_KRYO_4XX_SILVER, 0xd, 0xe),
 #endif
 		{},
 	};
-- 
2.25.1



