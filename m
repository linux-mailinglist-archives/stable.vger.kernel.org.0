Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBF0498C9C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345576AbiAXTXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349832AbiAXTVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:21:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9697EC061797;
        Mon, 24 Jan 2022 11:08:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DDBF60EC4;
        Mon, 24 Jan 2022 19:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42681C340E5;
        Mon, 24 Jan 2022 19:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051301;
        bh=pQnXVxQeSfUMLf41pmrb63t4YYQ2bvU2J9f+z1HT2PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbjnB8FlYfkT6qPx/lNFPR3MeYX+4sNqlqzz5UfnoGRVN+wc3ulapmmjk4fpMjhDy
         7N2t8Ni8MzGMvXgsYHb61u4hD0xro6mXl+nr9C5lQUS9edhanHcMUpmeYzMSlOeYmN
         DodnOHUtmv/5FMedXEEqBLg1LWR5C6itHP5mlD2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Asselstine <mark.asselstine@windriver.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/186] ACPICA: Utilities: Avoid deleting the same object twice in a row
Date:   Mon, 24 Jan 2022 19:43:14 +0100
Message-Id: <20220124183940.941645419@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
index 61a979d0fbc5a..64a90ba71f18c 100644
--- a/drivers/acpi/acpica/utdelete.c
+++ b/drivers/acpi/acpica/utdelete.c
@@ -442,6 +442,7 @@ acpi_ut_update_ref_count(union acpi_operand_object *object, u32 action)
 			ACPI_WARNING((AE_INFO,
 				      "Obj %p, Reference Count is already zero, cannot decrement\n",
 				      object));
+			return;
 		}
 
 		ACPI_DEBUG_PRINT((ACPI_DB_ALLOCATIONS,
-- 
2.34.1



