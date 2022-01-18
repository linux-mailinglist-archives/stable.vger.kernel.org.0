Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE8C491C7C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356157AbiARDPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:15:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42524 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343877AbiARDJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:09:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADDF5B811D7;
        Tue, 18 Jan 2022 03:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9486AC36AEB;
        Tue, 18 Jan 2022 03:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475362;
        bh=APRlrZwJ6X3OBsQ3EZddS6M4NM8EdOAtXMLFF5uyKy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxrVqELaP80Gqj/0tG9fcug9B/fC+UGxUwNNT5G48FxBeDL4DECmeqKQ7qaedk9wr
         JFIXL2Vn1pBHR2vz+fYxNOjL1XDZywd2WJHuQADb9Dxe9wVu29piKRAe8waySVxVMj
         qsdFvAo1g+i/z8KmypbqJ6NGMSjyDTXE0HWd350qvqXum4uAcmFaxa4Lw6+/Ky2eQd
         CsKRJdEa1aImSl5nQY/3wltm2yEoHsCbOvBQ0K/Bvw6OFlL7pgInxTwf4o3EeZkiNX
         dVKpzgoizqJsioBCQuOwOuCP1XqHaDUbc9cQghm1siTf7jUyF5jjCdiHJ4uVX+oDo2
         l+aqS4ycqsncw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Bob Moore <robert.moore@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.4 20/29] ACPICA: Utilities: Avoid deleting the same object twice in a row
Date:   Mon, 17 Jan 2022 22:08:13 -0500
Message-Id: <20220118030822.1955469-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 1cdfe9e346b4c5509ffe19ccde880fd259d9f7a3 ]

ACPICA commit c11af67d8f7e3d381068ce7771322f2b5324d687

If original_count is 0 in acpi_ut_update_ref_count (),
acpi_ut_delete_internal_obj () is invoked for the target object, which is
incorrect, because that object has been deleted once already and the
memory allocated to store it may have been reclaimed and allocated
for a different purpose by the host OS.  Moreover, a confusing debug
message following the "Reference Count is already zero, cannot
decrement" warning is printed in that case.

To fix this issue, make acpi_ut_update_ref_count () return after finding
that original_count is 0 and printing the above warning.

Link: https://github.com/acpica/acpica/commit/c11af67d
Link: https://github.com/acpica/acpica/pull/652
Reported-by: Mark Asselstine <mark.asselstine@windriver.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utdelete.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpica/utdelete.c b/drivers/acpi/acpica/utdelete.c
index 9f8b088e21d7e..d90b2cf310fb1 100644
--- a/drivers/acpi/acpica/utdelete.c
+++ b/drivers/acpi/acpica/utdelete.c
@@ -439,6 +439,7 @@ acpi_ut_update_ref_count(union acpi_operand_object *object, u32 action)
 			ACPI_WARNING((AE_INFO,
 				      "Obj %p, Reference Count is already zero, cannot decrement\n",
 				      object));
+			return;
 		}
 
 		ACPI_DEBUG_PRINT((ACPI_DB_ALLOCATIONS,
-- 
2.34.1

