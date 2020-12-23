Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E02F2E163F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgLWC7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:59:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgLWCUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41B4122D73;
        Wed, 23 Dec 2020 02:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689993;
        bh=dbXis86xDPTQu+i1OtGK9IHLf/s7gH+4ybqoclpUXCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAiltPmwOvjn2PScHFcpzxf45AxxFGAEeaNEhTfnRwhMC1rVfFZTN404ZA2scd5Ta
         CTOWmcmr+K2R8qKIqxYslYn02ajge2txPiuJo5ry+AoSJNmshK70ZU70bF5wFcsdZx
         Am5lvdEhB/LsJzGF3U9tccSLOtfvOWQk4yJwFOZLg/6uqwgQCGjN1/S1XDR24xMrrd
         h3x+hjdal+OnaVnJqflbazCZSDkGpU0WlpU8GEhDwbsSRvzhAdQhsOx/LdI8tUf4VH
         Gm5sRC2sEOEJd3lLc9DXbRiZrBZ1POvFRg0XSeLXOGj6npxnMKfHbHrAVdO074FW5d
         9nXH+fClwqApw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 077/130] x86/pci: Fix the function type for check_reserved_t
Date:   Tue, 22 Dec 2020 21:17:20 -0500
Message-Id: <20201223021813.2791612-77-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit 83321c335dccba262a57378361d63da96b8166d6 ]

e820__mapped_all() is passed as a callback to is_mmconf_reserved(),
which expects a function of type:

  typedef bool (*check_reserved_t)(u64 start, u64 end, unsigned type);

However, e820__mapped_all() accepts enum e820_type as the last argument
and this type mismatch trips indirect call checking with Clang's
Control-Flow Integrity (CFI).

As is_mmconf_reserved() only passes enum e820_type values for the
type argument, change the typedef and the unused type argument in
is_acpi_reserved() to enum e820_type to fix the type mismatch.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20201130193900.456726-1-samitolvanen@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/mmconfig-shared.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 6fa42e9c4e6fa..234998f196d4d 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -425,7 +425,7 @@ static acpi_status find_mboard_resource(acpi_handle handle, u32 lvl,
 	return AE_OK;
 }
 
-static bool is_acpi_reserved(u64 start, u64 end, unsigned not_used)
+static bool is_acpi_reserved(u64 start, u64 end, enum e820_type not_used)
 {
 	struct resource mcfg_res;
 
@@ -442,7 +442,7 @@ static bool is_acpi_reserved(u64 start, u64 end, unsigned not_used)
 	return mcfg_res.flags;
 }
 
-typedef bool (*check_reserved_t)(u64 start, u64 end, unsigned type);
+typedef bool (*check_reserved_t)(u64 start, u64 end, enum e820_type type);
 
 static bool __ref is_mmconf_reserved(check_reserved_t is_reserved,
 				     struct pci_mmcfg_region *cfg,
-- 
2.27.0

