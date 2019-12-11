Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0660B11B1D8
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbfLKPdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732817AbfLKP2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:28:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D98F224658;
        Wed, 11 Dec 2019 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078126;
        bh=F6FNZD+WafbeRICAiehtuCPVTxROPy7vsvvpcW+wcEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxcWEa1u9szZ9/WvS9W5C9l/2oXJAayo3AdTkGv+5szX/NFdDe46A6ibmsR+GAGLB
         b9EbCZLNO7Kie8ztVVdDE3VHrYzjMRyRgCUWWe7lEQ2ER/c6XaZsQvWl2IuMu1PBxC
         cMmUkN5NgPEYZxy6MOWdCun5dqWfV2Uu0aZ7GRkY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Steinhauser <asteinhauser@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 14/58] powerpc/security/book3s64: Report L1TF status in sysfs
Date:   Wed, 11 Dec 2019 10:27:47 -0500
Message-Id: <20191211152831.23507-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Steinhauser <asteinhauser@google.com>

[ Upstream commit 8e6b6da91ac9b9ec5a925b6cb13f287a54bd547d ]

Some PowerPC CPUs are vulnerable to L1TF to the same extent as to
Meltdown. It is also mitigated by flushing the L1D on privilege
transition.

Currently the sysfs gives a false negative on L1TF on CPUs that I
verified to be vulnerable, a Power9 Talos II Boston 004e 1202, PowerNV
T2P9D01.

Signed-off-by: Anthony Steinhauser <asteinhauser@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[mpe: Just have cpu_show_l1tf() call cpu_show_meltdown() directly]
Link: https://lore.kernel.org/r/20191029190759.84821-1-asteinhauser@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/security.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kernel/security.c b/arch/powerpc/kernel/security.c
index f5d6541bf8c27..fef3f09fc238b 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -160,6 +160,11 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, cha
 
 	return sprintf(buf, "Vulnerable\n");
 }
+
+ssize_t cpu_show_l1tf(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_meltdown(dev, attr, buf);
+}
 #endif
 
 ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr, char *buf)
-- 
2.20.1

