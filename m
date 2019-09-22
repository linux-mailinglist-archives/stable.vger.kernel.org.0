Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD7FBAAFC
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388732AbfIVTdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391046AbfIVSri (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F21521D6C;
        Sun, 22 Sep 2019 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178058;
        bh=9zoyOyktiRtH8YkllJBaaJyXkixplE8SKeCBP01NexQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfzC9g2NaboETv1fBV0LgIlZzx7OwPeIPg8fuEeBzjK/weVbe7gfukscibrtTN5W0
         DOujdq6O2/UUQUSkzXI3Tt6y8rkejtYwJmW+PfcRF4DlZY3RhK12tNUHae8RuXJt+3
         v87BYntb0e/gPwGesv8qntCO1oWT5h028w2OvDHs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Stone <ahs3@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 134/203] ACPI / CPPC: do not require the _PSD method
Date:   Sun, 22 Sep 2019 14:42:40 -0400
Message-Id: <20190922184350.30563-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Stone <ahs3@redhat.com>

[ Upstream commit 4c4cdc4c63853fee48c02e25c8605fb65a6c9924 ]

According to the ACPI 6.3 specification, the _PSD method is optional
when using CPPC.  The underlying assumption is that each CPU can change
frequency independently from all other CPUs; _PSD is provided to tell
the OS that some processors can NOT do that.

However, the acpi_get_psd() function returns ENODEV if there is no _PSD
method present, or an ACPI error status if an error occurs when evaluating
_PSD, if present.  This makes _PSD mandatory when using CPPC, in violation
of the specification, and only on Linux.

This has forced some firmware writers to provide a dummy _PSD, even though
it is irrelevant, but only because Linux requires it; other OSPMs follow
the spec.  We really do not want to have OS specific ACPI tables, though.

So, correct acpi_get_psd() so that it does not return an error if there
is no _PSD method present, but does return a failure when the method can
not be executed properly.  This allows _PSD to be optional as it should
be.

Signed-off-by: Al Stone <ahs3@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 15f103d7532b0..3b2525908dd8c 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -365,8 +365,10 @@ static int acpi_get_psd(struct cpc_desc *cpc_ptr, acpi_handle handle)
 	union acpi_object  *psd = NULL;
 	struct acpi_psd_package *pdomain;
 
-	status = acpi_evaluate_object_typed(handle, "_PSD", NULL, &buffer,
-			ACPI_TYPE_PACKAGE);
+	status = acpi_evaluate_object_typed(handle, "_PSD", NULL,
+					    &buffer, ACPI_TYPE_PACKAGE);
+	if (status == AE_NOT_FOUND)	/* _PSD is optional */
+		return 0;
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-- 
2.20.1

