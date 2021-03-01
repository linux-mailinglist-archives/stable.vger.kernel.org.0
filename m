Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51CF328800
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhCARbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:31:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234122AbhCARYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:24:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 127876507F;
        Mon,  1 Mar 2021 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617412;
        bh=n6fuFjJ5k7r+7HgNo84B62wBzB7WxdXp4vOAnl/2ay8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAwxzjer8HJMBNcNSTyP5AyLMBQ7NRMQuxjHRyl5TEIACud3hCuoskamWIXOrF6Lt
         8Y7PPwWPB5po/3Pipzlc4gZmJ8batmHj89KLh1RW6sD059KnAuK3j/u3kf0nI5na9d
         65HNcWCyQgt3RBTn5a88NxFQvPv1nkzLsub41M3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/340] ACPICA: Fix exception code class checks
Date:   Mon,  1 Mar 2021 17:09:39 +0100
Message-Id: <20210301161050.041772115@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 3dfaea3811f8b6a89a347e8da9ab862cdf3e30fe ]

ACPICA commit 1a3a549286ea9db07d7ec700e7a70dd8bcc4354e

The macros to classify different AML exception codes are broken. For
instance,

  ACPI_ENV_EXCEPTION(Status)

will always evaluate to zero due to

  #define AE_CODE_ENVIRONMENTAL      0x0000
  #define ACPI_ENV_EXCEPTION(Status) (Status & AE_CODE_ENVIRONMENTAL)

Similarly, ACPI_AML_EXCEPTION(Status) will evaluate to a non-zero
value for error codes of type AE_CODE_PROGRAMMER, AE_CODE_ACPI_TABLES,
as well as AE_CODE_AML, and not just AE_CODE_AML as the name suggests.

This commit fixes those checks.

Fixes: d46b6537f0ce ("ACPICA: AML Parser: ignore all exceptions resulting from incorrect AML during table load")
Link: https://github.com/acpica/acpica/commit/1a3a5492
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/acexcep.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/acpi/acexcep.h b/include/acpi/acexcep.h
index 233a72f169bb7..e1de0fe281644 100644
--- a/include/acpi/acexcep.h
+++ b/include/acpi/acexcep.h
@@ -59,11 +59,11 @@ struct acpi_exception_info {
 
 #define AE_OK                           (acpi_status) 0x0000
 
-#define ACPI_ENV_EXCEPTION(status)      (status & AE_CODE_ENVIRONMENTAL)
-#define ACPI_AML_EXCEPTION(status)      (status & AE_CODE_AML)
-#define ACPI_PROG_EXCEPTION(status)     (status & AE_CODE_PROGRAMMER)
-#define ACPI_TABLE_EXCEPTION(status)    (status & AE_CODE_ACPI_TABLES)
-#define ACPI_CNTL_EXCEPTION(status)     (status & AE_CODE_CONTROL)
+#define ACPI_ENV_EXCEPTION(status)      (((status) & AE_CODE_MASK) == AE_CODE_ENVIRONMENTAL)
+#define ACPI_AML_EXCEPTION(status)      (((status) & AE_CODE_MASK) == AE_CODE_AML)
+#define ACPI_PROG_EXCEPTION(status)     (((status) & AE_CODE_MASK) == AE_CODE_PROGRAMMER)
+#define ACPI_TABLE_EXCEPTION(status)    (((status) & AE_CODE_MASK) == AE_CODE_ACPI_TABLES)
+#define ACPI_CNTL_EXCEPTION(status)     (((status) & AE_CODE_MASK) == AE_CODE_CONTROL)
 
 /*
  * Environmental exceptions
-- 
2.27.0



