Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D696A11B30F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388400AbfLKPi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388398AbfLKPi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8D5E24656;
        Wed, 11 Dec 2019 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078705;
        bh=lZN/lImANi61wob+Y5QU6C9PypHby5KeCddY6twx0FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9NzHI8DLnEeS1R6oDM0dZoteqEd9X6sNS6Jo9HDAMf4TiI4I+nUK78OZDJjCcoqf
         zxeZQergw5CwW90qasDSKY5mRuzOmkFEuyBRMIJWEdxZho60C9KoGvkLKP4kvbELls
         hJTUKt2AAcUathk10vq+rsLv1Na+zgwSZdzsW2GU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Steinhauser <asteinhauser@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 11/37] powerpc/security/book3s64: Report L1TF status in sysfs
Date:   Wed, 11 Dec 2019 10:37:47 -0500
Message-Id: <20191211153813.24126-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
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
index 156cfe6d23b09..fc5c49046aa7d 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -161,6 +161,11 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, cha
 
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

